//
//  StatusBar.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "StatusBar.h"
#import "DebugView.h"

//#define WIDTH                     [UIScreen mainScreen].bounds.size.width
//#define HEIGHT                    [UIScreen mainScreen].bounds.size.height

@interface StatusBar ()
@property (nonatomic, assign) BOOL isModalTransition;
@property (nonatomic, strong)  DebugView *modalView;
@property (nonatomic, strong)  MTStatusBarOverlay *overlay;
@property (nonatomic, assign)  HekrEnvironmentType envType;

@end
@implementation StatusBar

+ (StatusBar *)sharedInstance {
    static dispatch_once_t pred;
    __strong static StatusBar *statusBar = nil;
    
    dispatch_once(&pred, ^{
        statusBar = [[StatusBar alloc] init];
    });
    
    return statusBar;
}
-(instancetype) init{
    self = [super init];
    if (self) {
        [self loadEnvironmentType];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self addStatuBarWithFrame:frame];
}
-(void)addStatuBarWithFrame:(CGRect)frame{
    
    
    self.overlay = [MTStatusBarOverlay sharedInstance];
    
    self.overlay.animation = MTStatusBarOverlayAnimationNone;
    self.overlay.detailViewMode = MTDetailViewModeCustom;
    self.overlay.delegate = self;
    self.overlay.frame =frame;
    [self.overlay postMessage:@"debung" animated:YES];
    
    self.overlay.hidesActivity = NO;
    
}
-(NSURL*) cacheURL{
    NSString* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSURL * url = [NSURL fileURLWithPath:path];
    return [url URLByAppendingPathComponent:@"environmentTypeCache.dat"];
}
-(void)loadEnvironmentType{
    NSString *typeCache = [NSString stringWithContentsOfURL:[self cacheURL] encoding:NSUTF8StringEncoding error:nil];
    _envType = [typeCache integerValue]==1?HekrEnvironmentTypeTest:HekrEnvironmentTypeFormal;
}
-(void) setEnvironmentType:(HekrEnvironmentType )type{
    _envType = type;
    NSString *typeCache = [NSString stringWithFormat:@"%ld",(unsigned long)type];
    if (![typeCache writeToURL:[self cacheURL] atomically:YES encoding:NSUTF8StringEncoding error:nil]) {
        DDLogVerbose(@"typeCache NOT Written ");
    }
}
-(HekrEnvironmentType) getEnvironmentType{
    return _envType;
}
#pragma MARK ---MTStatusBarOverlayDelegate ---
- (void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer{
    
    id result = [self getCurrentVC];
    UIViewController *currentCV = [self getCurrentVC];
    if ([result isKindOfClass:[UINavigationController class]]) {
    
        result = [result topViewController];
    }
    UIViewController *resultCV = (UIViewController *)result;
    
    if (_isModalTransition) {
        
        [_modalView removeFromSuperview];
//        _modalView = nil;
        
    }else{
        
        if (!_modalView) {
            _modalView = [[DebugView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
            _modalView.backgroundColor = [UIColor whiteColor];
        }
        [resultCV.view endEditing:YES];
        [currentCV.view addSubview:_modalView];
    }
    _isModalTransition = !_isModalTransition;
}
#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [self showMessage:msg];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)showMessage:(NSString *)msg{

    [self.window makeToast:msg duration:1.0 position:@"center"];
}


//获取当前屏幕显示的viewcontroller
- (id)getCurrentVC
{
    id result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController ;
        
    }
    
    return result;
}
@end
