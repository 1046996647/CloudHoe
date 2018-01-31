//
//  DevAuthorizationViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DevAuthorizationViewController.h"
#import <HekrAPI.h>
#import <AFNetworking.h>
#import "GiFHUD.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface DevAuthorizationViewController ()

@property (nonatomic ,strong) UILabel *validLabel;

@end

@implementation DevAuthorizationViewController
{
    HekrDevice *_data;
    NSString *_uid;
    UIImageView *_image;
    UILabel *_label;
    UIView *_bgView;
    UIView *_refurbishView;
}

- (instancetype)initWith:(HekrDevice *)data UID:(NSString *)uid{
    self = [super init];
    if (self) {
        _data = data;
        _uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    _bgView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - Hrange(600))/2, Vrange(100)+64, Hrange(600), Vrange(880))];
    _bgView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:_bgView];
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"DevAuthorization"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick endLogPageView:@"DevAuthorization"];
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"共享授权", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    label.backgroundColor = getCellLineColor();
//    [self.view addSubview:label];
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"共享授权" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickAction{
    _refurbishView.userInteractionEnabled = YES;
}

- (void)createViews{
    _refurbishView.userInteractionEnabled = NO;
    [self performSelector:@selector(clickAction) withObject:nil afterDelay:1.0];
    if (_image == nil) {
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(Hrange(80), Vrange(100), Hrange(440), Hrange(440))];
        [_bgView addSubview:_image];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _bgView.frame.size.height-Vrange(160), _bgView.frame.size.width, Vrange(40))];
        _label.textColor = getDescriptiveTextColor();
        _label.font = getListTitleFont();
        _label.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_label];
        
        _validLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_label.frame)+Vrange(40), _bgView.frame.size.width, Vrange(40))];
        _validLabel.textColor = getPlaceholderTextColor();
        _validLabel.font = getDescTitleFont();
        _validLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_validLabel];
    }
    if (_refurbishView) {
        _refurbishView.hidden = YES;
    }
    [GiFHUD showWithOverlay];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager POST:@"http://user.openapi.hekr.me/authorization/reverse/authUrl" parameters:@{@"grantor":_uid,@"devTid":_data.props[@"devTid"],@"ctrlKey":_data.props[@"ctrlKey"],@"expire":@(3110400000),@"mode":@"ALL",@"enableScheduler":@(YES),@"enableIFTTT":@(YES)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[获取设备二维码]：%@",responseObject);
        [GiFHUD dismiss];
        NSString * token = responseObject[@"reverseAuthorizationTemplateId"];
        if (token) {
            // 1、创建过滤器
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            // 2、恢复滤镜的默认属性
            [filter setDefaults];
            // 3、设置内容
            NSString *str = [NSString stringWithFormat:@"http://www.hekr.me?action=rauth&token=%@",token];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            // 使用KVO设置属性
            [filter setValue:data forKey:@"inputMessage"];
            // 4、获取输出文件
            CIImage *outputImage = [filter outputImage];
            // 5、显示二维码
            _image.image = [self createNonInterpolatedUIImageFormCIImage:outputImage size:CGRectGetWidth(_image.frame)];
            _image.backgroundColor = [UIColor whiteColor];
            _label.text = NSLocalizedString(@"对方扫一扫，快速分享授权", nil);
            
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            now = now + 300;
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            // 时间戳转时间
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:now];
            NSString *confromTimespStr = [dateformatter stringFromDate:confromTimesp];
            _validLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"有效期至: ", nil),confromTimespStr];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        _image.image = [UIImage imageNamed:@"ic_Authorization"];
        _image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createViews)];
        [_image addGestureRecognizer:tgr];
        _label.text = NSLocalizedString(@"页面加载失败，请刷新", nil);
//        [self createRefurbishView];
    }];
    
    
    
    
}

- (void)createRefurbishView{
    if (_refurbishView == nil) {
        _refurbishView = [[UIView alloc]initWithFrame:_bgView.frame];
        _refurbishView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_refurbishView];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vrange(126), Vrange(126))];
        img.center = CGPointMake(_refurbishView.frame.size.width/2, _refurbishView.frame.size.height/2- img.frame.size.height/2 - 10);
        img.image = [UIImage imageNamed:@"ic_Authorization"];
        img.userInteractionEnabled = YES;
        [_refurbishView addSubview:img];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _refurbishView.frame.size.width, 18)];
        label.center = CGPointMake(_refurbishView.frame.size.width/2, _refurbishView.frame.size.height/2+19);
        label.textColor = getDescriptiveTextColor();
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"页面加载失败，请刷新", nil);
        [_refurbishView addSubview:label];
        UIView *clickView = [[UIView alloc]initWithFrame:CGRectMake(Hrange(80), Vrange(100), Hrange(440), Hrange(440))];
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createViews)];
        [clickView addGestureRecognizer:tgr];
        [_refurbishView addSubview:clickView];
        
    }else{
        _refurbishView.hidden = NO;
    }
}



- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight
{
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    CGColorSpaceRelease(cs);
    return [self imageBlackToTransparent:newImage withRed:0.0f andGreen:0.0f andBlue:0.0f];
//    return isNightTheme() ? [self imageBlackToTransparent:newImage withRed:123.0f andGreen:123.0f andBlue:123.0f] : [self imageBlackToTransparent:newImage withRed:0.0f andGreen:0.0f andBlue:0.0f];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    
    const int imageWidth = image.size.width;
    
    const int imageHeight = image.size.height;
    
    size_t      bytesPerRow = imageWidth * 4;
    
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
            
        {
            
            // 改成下面的代码，会将图片转成想要的颜色
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[3] = red; //0~255
            
            ptr[2] = green;
            
            ptr[1] = blue;
            
        }
        
        else
            
        {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[0] = 0;
            
        }
        
    }
    
    // 输出图片
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        
                                        NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
