//
//  AppDelegate.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "AppDelegate.h"
//#import "IQKeyboardManager.h"
#import "LoginVC.h"
#import "NavigationController.h"
#import <UMSocialCore/UMSocialCore.h>

#define USHARE_DEMO_APPKEY @"5a30d5b7f29d980cba000262"

@interface AppDelegate ()



@end

@implementation AppDelegate

+ (AppDelegate *)share
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.window makeKeyAndVisible];
    
    // 状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //    [NSThread sleepForTimeInterval:1];
    
    
//    // 键盘遮盖处理第三方库(影响KeyBoard，注意！！！！！)
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    manager.enableAutoToolbar = NO;
    
    // 友盟第三方登录或分享----------------
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    // 判断登录状态
    [self isLoginedState];
    
    return YES;
}

// 判断登录状态
- (void)isLoginedState
{
    if (![[InfoCache getValueForKey:@"LoginedState"] integerValue]) {
        LoginVC *loginVC = [[LoginVC alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }
    else {
        
//        NSString *account = [InfoCache unarchiveObjectWithFile:@"accid"];
//        NSString *token = [InfoCache unarchiveObjectWithFile:@"accToken"];
        
        TabBarController *tabVC = [[TabBarController alloc] init];
        self.tabVC = tabVC;
        self.window.rootViewController = tabVC;
    }
}

// ------------登录或分享
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxf00168c852807c02" appSecret:@"8a65003b5ef2c6122ba47b3597c4ad38" redirectURL:nil];
    
    
    
}


// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
