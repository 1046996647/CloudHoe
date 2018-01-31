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
//#import <UMSocialCore/UMSocialCore.h>

//#define USHARE_DEMO_APPKEY @"5a30d5b7f29d980cba000262"

#import <HekrAPI.h>
#import <ZipArchive.h>
//#import "SideViewController.h"
#import "Tool.h"
//#import "WelcomeController.h"
//#import "UserViewController.h"
#import "DebugView.h"
#import "MyCustomLoggeer.h"
#import "MTStatusBarOverlay.h"
#import "StatusBar.h"
//#import "ConfigurationNetController.h"
#import "DevicesModel.h"
//#import "ManagerViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <HekrWebView.h>

#endif
extern NSDictionary * ApiMap;
extern NSString * SocketMap;

@interface AppDelegate ()<UINavigationControllerDelegate,MTStatusBarOverlayDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) StatusBar * statusBar;
@property (nonatomic,strong) DevicesModel * model;

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
    
//    // 友盟第三方登录或分享----------------
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
//
//    [self configUSharePlatforms];
//
//    [self confitUShareSettings];
    
    // 个推-------------------------------
    // [ GTSdk ]：是否允许APP后台运行
    //    [GeTuiSdk runBackgroundEnable:YES];
    
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
//    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-Channel"];
    
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT启动个推
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册APNs - custom method - 开发者自定义的方法
    [self registerRemoteNotification];
    
    // 判断登录状态
    [self isLoginedState];
    
#ifdef DEBUG
//    self.statusBar = [StatusBar sharedInstance];
//    self.statusBar.frame =CGRectMake(Hrange(469), 0,ScreenWidth - Hrange(469) - Hrange(117), 20);
//    [self.window addSubview:self.statusBar];
    
    //进入app环境,不设置默认为正式环境 HekrEnvironmentTypeFormal:正式环境;HekrEnvironmentTypeTest:测试环境↓
    //    [self.statusBar setEnvironmentType:HekrEnvironmentTypeTest];
    
    MyCustomLoggeer *logger = [MyCustomLoggeer sharedInstance];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    //保存周期
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    [DDLog addLogger:fileLogger];
    [DDLog addLogger:logger];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //
#endif
    ApiMap = @{@"user.openapi.hekr.me":@"https://user-openapi.hekr.me",@"uaa.openapi.hekr.me":@"https://uaa-openapi.hekr.me",@"console.openapi.hekr.me":@"https://console-openapi.hekr.me"};
    SocketMap = @"wss://asia-app.hekr.me:186";
    if (self.statusBar) {
        if ([[StatusBar sharedInstance] getEnvironmentType] == HekrEnvironmentTypeTest) {
            ApiMap = @{@"user.openapi.hekr.me":@"http://test-user-openapi.hekr.me",@"uaa.openapi.hekr.me":@"http://test-uaa-openapi.hekr.me",@"console.openapi.hekr.me":@"http://test-console-openapi.hekr.me"};
            SocketMap = @"wss://test-asia-dev.hekr.me:186";
        }
    }
    
    //UMeng统计
    [[UMAnalyticsConfig sharedInstance] setAppKey:@"57317c4de0f55a86a4000bf6"];
    [[UMAnalyticsConfig sharedInstance] setEPolicy:BATCH];
    [[UMAnalyticsConfig sharedInstance] setChannelId:@"AppStore"];
    [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
    
    //设置主题颜色
    NSDictionary *profile = [Tool getJsonDataFromFile:@"profile.json"];
    NSString *Theme = [profile objectForKey:@"Theme"];
    if (Theme&&Theme.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:Theme forKey:@"HekrTheme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSDictionary *config = [Tool getJsonDataFromFile:@"config.json"];
    
    [[Hekr sharedInstance] config:config startPage:@"http://app.hekr.me/templates/home/html/index.html" launchOptions:launchOptions];
    
    [[Hekr sharedInstance] sso:KeyOfHekr controller:nil ssoType:HekrSSOLogin anonymous:YES callback:^(id token, id user, NSError * err) {
        _ssoToken = token;
    }];
    
    self.model = [[DevicesModel alloc] initTool];

    
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

//// ------------登录或分享
//- (void)confitUShareSettings
//{
//    /*
//     * 打开图片水印
//     */
//    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
//
//    /*
//     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
//     <key>NSAppTransportSecurity</key>
//     <dict>
//     <key>NSAllowsArbitraryLoads</key>
//     <true/>
//     </dict>
//     */
//    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
//
//}
//
//- (void)configUSharePlatforms
//{
//    /*
//     设置微信的appKey和appSecret
//     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxf00168c852807c02" appSecret:@"8a65003b5ef2c6122ba47b3597c4ad38" redirectURL:nil];
//
//
//
//}


//// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        
//    }
//    return result;
//}


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

- (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // [ GTSdk ]：Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

#pragma mark - 远程通知(推送)回调

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [[Hekr sharedInstance] didRegisterUserNotificationSettings:notificationSettings];
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
    [[Hekr sharedInstance] registNotificationsWithDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [[Hekr sharedInstance] didReceiveRemoteNotification:userInfo];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[Hekr sharedInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    [_viewController logMsg:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]];
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - (App运行在后台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 显示APNs信息到页面
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], userInfo];
//    [_viewController logMsg:record];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif


#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSdk ]：个推SDK已注册，返回clientId
    NSLog(@">>[GTSdk RegisterClient]:%@", clientId);
    
    [InfoCache archiveObject:clientId toFile:@"clientId"];
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        
        if ([payloadMsg isEqualToString:@"关注了你"]) {
            //加好友
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kAddlistNotification" object:nil];

        }
        if ([payloadMsg isEqualToString:@"同意了你的关注"]) {
            //互关
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kMyfriendsNotification" object:nil];
            
        }
        
    }
    
    // 页面显示日志
    NSString *record = [NSString stringWithFormat:@"%d, %@, %@%@", ++_lastPayloadIndex, [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @""];
//    [_viewController logMsg:record];
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"%@ : %@%@", [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@">>[GTSdk ReceivePayload]:%@, taskId: %@, msgId :%@", msg, taskId, msgId);
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 页面显示：上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//    [_viewController logMsg:record];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // 页面显示：个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 页面显示更新通知SDK运行状态
//    [_viewController updateStatusView:self];
}

/** SDK设置推送模式回调  */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    // 页面显示错误信息
    if (error) {
//        [_viewController logMsg:[NSString stringWithFormat:@">>>[SetModeOff error]: %@", [error localizedDescription]]];
        return;
    }
    
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@", isModeOff ? @"开启" : @"关闭"]];
    
//    // 页面更新按钮事件
//    UIViewController *vc = _naviController.topViewController;
//    if ([vc isKindOfClass:[ViewController class]]) {
//        ViewController *nextController = (ViewController *) vc;
//        [nextController updateModeOffButton:isModeOff];
//    }
}


@end
