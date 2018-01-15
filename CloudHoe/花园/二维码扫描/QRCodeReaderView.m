/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>

//#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
//#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate kScreenWidth/320
#define Scanwidth widthRate*225

#define contentTitleColorStr @"666666" //正文颜色较深

@interface QRCodeReaderView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    
    NSTimer * countTime;
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@end

@implementation QRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {

        [self instanceDevice];
  }
  
  return self;
}

- (void)instanceDevice
{
    //扫描区域
    UIImage *hbImage=[UIImage imageNamed:@"scanscanBg"];
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = hbImage;
    //添加一个背景图片
    CGRect mImagerect = CGRectMake((self.width-Scanwidth)/2, 75, Scanwidth, Scanwidth);
    [scanZomeBack setFrame:mImagerect];
//    CGRect scanCrop=[self getScanCrop:mImagerect readerViewBounds:self.frame];
    
    CGRect scanCrop = CGRectMake(75/kScreenHeight, (kScreenWidth/2 -scanZomeBack.height/2)/kScreenWidth, scanZomeBack.width/kScreenHeight, scanZomeBack.height/kScreenWidth);
//    CGRect scanCrop = CGRectMake(0.05, 0.2, 0.7, 0.6);
;

    [self addSubview:scanZomeBack];
    self.scanZomeBack = scanZomeBack;
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView:scanZomeBack];
    
    //开始捕获
    [session startRunning];
    
    
}

-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
    CGRect rect = CGRectMake(0, 0, Scanwidth, 2);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
    }
    else{
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self.scanZomeBack addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        _readLineView.frame =CGRectMake(0, self.scanZomeBack.height-2, Scanwidth, 2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion) {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}

- (void)setOverlayPickerView:(UIImageView *)imgView
{
    
//    CGFloat wid = 75*widthRate;
//    CGFloat heih = (DeviceMaxHeight-Scanwidth)/2;
    
//    //最上部view
//    CGFloat alpha = 0.6;
//    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, imgView.top)];
//    upView.alpha = alpha;
//    upView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
//    [self addSubview:upView];
////    upView.backgroundColor = [UIColor redColor];
//    
//    //左侧的view
//    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imgView.left, kScreenHeight)];
//    cLeftView.alpha = alpha;
//    cLeftView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
//    [self addSubview:cLeftView];
//    
//    //右侧的view
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(imgView.right, 0, imgView.left, kScreenHeight)];
//    rightView.alpha = alpha;
//    rightView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
//    [self addSubview:rightView];
//    
//    //底部view
//    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, imgView.bottom, kScreenWidth, kScreenHeight-imgView.bottom)];
//    downView.alpha = alpha;
//    downView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
//    [self addSubview:downView];
    
//    //开关灯button
//    UIButton * turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnBtn.backgroundColor = [UIColor clearColor];
//    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateNormal];
//    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateSelected];
//    turnBtn.frame=CGRectMake((DeviceMaxWidth-50*widthRate)/2, (CGRectGetHeight(downView.frame)-50*widthRate)/2, 50*widthRate, 50*widthRate);
//    [turnBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:turnBtn];
    
    UILabel *label = [UILabel labelWithframe:CGRectMake(0, imgView.bottom+30, kScreenWidth, 16) text:@"将二维码放入框中，即可自动扫描" font:SystemFont(15) textAlignment:NSTextAlignmentCenter textColor:@"#FFFFFF"];
    [self addSubview:label];
    
    UIButton *inputBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth/2-135-10, self.height-44-60, 135, 44) text:@"输入设备号" font:[UIFont systemFontOfSize:16] textColor:@"#50DBD1" backgroundColor:@"" normal:@"" selected:nil];
    inputBtn.layer.cornerRadius = inputBtn.height/2;
    inputBtn.layer.masksToBounds = YES;
    inputBtn.layer.borderColor = [UIColor colorWithHexString:@"#50DBD1"].CGColor;
    inputBtn.layer.borderWidth = .5;
    [self addSubview:inputBtn];
    inputBtn.tag = 0;
    self.inputBtn = inputBtn;
    
    UIButton *recordBtn = [UIButton buttonWithframe:CGRectMake(inputBtn.right+10, self.height-44-60, 135, 44) text:@"设备记录" font:[UIFont systemFontOfSize:16] textColor:@"#50DBD1" backgroundColor:@"" normal:@"" selected:nil];
    recordBtn.layer.cornerRadius = recordBtn.height/2;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.layer.borderColor = [UIColor colorWithHexString:@"#50DBD1"].CGColor;
    recordBtn.layer.borderWidth = .5;
    [self addSubview:recordBtn];
    recordBtn.tag = 1;
    self.recordBtn = recordBtn;
    
}

- (void)turnBtnEvent:(UIButton *)button_
{
    button_.selected = !button_.selected;
    if (button_.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

//-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
//{
//
//    CGFloat x,y,width,height;
//
////    width = (CGFloat)(rect.size.height+10)/readerViewBounds.size.height;
////
////    height = (CGFloat)(rect.size.width-50)/readerViewBounds.size.width;
////
////    x = (1-width)/2;
////    y = (1-height)/2;
//
//    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
//    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
//    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
//    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
//
//    return CGRectMake(x, y, width, height);
//
//}

- (void)start
{
    [session startRunning];
}

- (void)stop
{
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}

#pragma mark - 颜色
//获取颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


@end
