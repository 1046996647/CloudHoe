//
//  ScanVC.m
//  Rice
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ScanVC.h"
#import "QRCodeReaderView.h"
#import "UIImage+UIImageExt.h"
#import "InputDeviceVC.h"
#import "DeviceRecordVC.h"


#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

// 二维码扫描记得去掉全局断点！！！！！！！！！！！！！！！！
@interface ScanVC ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ScanVC

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    
//    // 右上角按钮
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 22)];
//    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"相册" font:SystemFont(17) textColor:@"#333333" backgroundColor:nil normal:nil selected:nil];
//    [rightView addSubview:viewBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    [viewBtn addTarget:self action:@selector(alumbBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
    
    //注册程序进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (enterForeground) name: UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回
//- (void)backButtonEvent
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    [readview.inputBtn addTarget:self action:@selector(deviceAction:) forControlEvents:UIControlEventTouchUpInside];
    [readview.recordBtn addTarget:self action:@selector(deviceAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}

- (void)deviceAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        InputDeviceVC *vc = [[InputDeviceVC alloc] init];
        vc.title = @"输入设备号";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        DeviceRecordVC *vc = [[DeviceRecordVC alloc] init];
        vc.title = @"设备记录";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 4;
        [alert show];
        
        return;
    }
    
    isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = YES;// 打开识别图片中的二维码
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
//    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    readview.is_Anmotion = YES;
    
    image = [UIImage imageSizeWithScreenImage:image];
    
//    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];// (去掉全局断点，不然会崩)
    
    if (features.count >=1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            //播放扫描二维码的声音(去掉全局断点，不然会崩)
            SystemSoundID soundID;
            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
            
            [self accordingQcode:scannedResult];
        }];
        
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            readview.is_Anmotion = NO;
            [readview start];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    

    //播放扫描二维码的声音(去掉全局断点，不然会崩)
    SystemSoundID soundID = 0;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
    
    [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{

    if ([str containsString:@"?#"]) {
        
        NSArray *arr = [str componentsSeparatedByString:@"?#"];
        str = [arr lastObject];
        if (self.block) {
            self.block(str);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }


}

- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

- (void)enterForeground
{
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self enterForeground];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
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
