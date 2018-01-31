//
//  ConfigFailResultViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/6.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigFailResultViewController.h"
#import "ConfigDevModel.h"
#import <UIImageView+WebCache.h>
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "ConfigPWViewController.h"

@interface ConfigFailResultViewController ()<UIWebViewDelegate>

@property (nonatomic ,assign) ConfigDeviceType configType;
@property (nonatomic ,assign) ConfigDeviceStep configStep;
@property (nonatomic ,strong) NSDictionary *device;

@property (nonatomic ,weak) IBOutlet UILabel *titleLabel;

@property (nonatomic ,weak) IBOutlet UILabel *devLabel;
@property (nonatomic ,weak) IBOutlet UILabel *failLabel;
@property (nonatomic ,weak) IBOutlet UIImageView *devImageView;
@property (nonatomic ,weak) IBOutlet UIView *devView;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *devContraint;
@property (nonatomic ,weak) IBOutlet UILabel *descLabel;
@property (nonatomic ,weak) IBOutlet UIWebView *descWeb;
@property (nonatomic ,weak) IBOutlet UIImageView *bgImageView;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *moveTopContraint;

@end

@implementation ConfigFailResultViewController

-(void)setConfigDeviceType:(ConfigDeviceType )type configStep:(ConfigDeviceStep )step device:(NSDictionary *)device{
    _configType = type;
    _configStep = step;
    _device = device;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"失败原因";
    [self initNavView];
    _moveTopContraint.constant = StatusBarAndNavBarHeight;
    if (@available(iOS 11.0, *)) {
        _descWeb.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    if (_configType == ConfigDeviceTypeNormal) {
    
        UIButton *softAPButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, StatusBarHeight, 100, 44)];
        [softAPButton setTitle:NSLocalizedString(@"兼容模式", nil) forState:UIControlStateNormal];
        [softAPButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        softAPButton.titleLabel.textAlignment = NSTextAlignmentRight;
        softAPButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [softAPButton addTarget:self action:@selector(goSoftAP) forControlEvents:UIControlEventTouchUpInside];
        [self.nav addSubview:softAPButton];
//    }
    
    switch (_configStep) {
        case ConfigDeviceStepFirst:{
            _descLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"1. 检查路由器、手机APP网络是否通畅\n2. 配网过程中尽可能使设备、路由器、手机相互靠近\n3. 请联系厂家，确认是否服务器在维护中", nil)];
            _titleLabel.text = NSLocalizedString(@"无法连接服务器", nil);
        }
            break;
        case ConfigDeviceStepSecond:{
            _titleLabel.text = NSLocalizedString(@"设备无法正常连接路由器", nil);
            [self loadImageView];
        }
            break;
        case ConfigDeviceStepThird:{
            _descLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"1. 检查路由器、手机APP网络是否通畅\n2. 请联系厂家，检查设备参数配置是否正确", nil)];
            _titleLabel.text = NSLocalizedString(@"设备参数异常", nil);
        }
            break;
        case ConfigDeviceStepFourth:{
            _descLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"1. 检查路由器、手机APP网络是否通畅\n2. 配网过程中尽可能使设备、路由器、手机相互靠近\n3. 请联系厂家，确认是否服务器在维护中", nil)];
            _titleLabel.text = NSLocalizedString(@"无法连接服务器", nil);
        }
            break;
        case ConfigDeviceStepFinish:{
            
            if (!_device[@"logo"]) {
                _devImageView.image = [UIImage imageNamed:@"ic_dev_fail"];
                _bgImageView.hidden = YES;
            }else{
                [_devImageView sd_setImageWithURL:[NSURL URLWithString:_device[@"logo"]] completed:nil];
            }
            
            _bgImageView.layer.cornerRadius = Hrange(50);
            _bgImageView.backgroundColor = UIColorFromHex(0xcccccc);

            _titleLabel.text = [ConfigDevModel devFailResult:_device];
            
            _devContraint.constant = Hrange(180);
            [self.view layoutIfNeeded];
            _devView.hidden = NO;
            
            _descLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"1. 该设备不支持强制绑定，请联系绑定者删除设备后重新尝试\n2. 无法找到绑定者？请截图反馈给厂家处理", nil)];
            
            _failLabel.text = [ConfigDevModel devFailReason:_device comeType:NO];
            _devLabel.text = _device[@"name"];
            
            if ([[ConfigDevModel devFailResult:_device] isEqualToString:NSLocalizedString(@"被其他账号绑定", nil)]) {
                softAPButton.hidden = YES;
            }
            
        }
            break;
        default:
            break;
    }
    
    [UILabel changeLineSpaceForLabel:_descLabel WithSpace:12];
    
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    //    [MobClick beginLogPageView:@"Config"];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //    [MobClick endLogPageView:@"Config"];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    
//    //    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goSoftAP{
    [[Hekr sharedInstance] stopConfig];

    ConfigPWViewController *cpwVC = [[ConfigPWViewController alloc] initWithNibName:@"ConfigPWViewController" bundle:nil];
    [cpwVC setConfigDeviceType:ConfigDeviceTypeSoftAP];
    [self.navigationController pushViewController:cpwVC animated:YES];
}

- (void)loadImageView{
    self.descWeb.hidden = NO;
    self.descWeb.scrollView.bounces = NO;
    self.descWeb.scrollView.showsHorizontalScrollIndicator = NO;
    self.descWeb.scrollView.showsVerticalScrollIndicator = NO;
    //编码图片
    UIImage *selectedImage = [UIImage imageNamed:isEN()?@"ic_fail_reason_en":@"ic_fail_reason"];
    NSString *stringImage = [self htmlForJPGImage:selectedImage];
    
    //构造内容
    NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
    NSString *content =[NSString stringWithFormat:
                        @"<html><style type=\"text/css\">img{max-width:100%%}</style><body>%@</body></html>",contentImg];
    
    //让self.contentWebView加载content
    [self.descWeb loadHTMLString:content baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //状态栏不显示网络状态，因为当前内容不是由网络下载的
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
}


@end
