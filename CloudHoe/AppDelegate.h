//
//  AppDelegate.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import <GTSDK/GeTuiSdk.h>

#import "SideViewController.h"
#import "Tool.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

// 杭州个推官网
#define kGtAppId @"pZd0vDo1o8AoQl8wiGIM7A"
#define kGtAppKey @"Nnuow5bnJV51QWo4suJij"
#define kGtAppSecret @"WxeKLcGzan7jgbBUxgDaE5"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarController *tabVC;
+ (AppDelegate *)share;
@property (assign, nonatomic) int lastPayloadIndex;


@property (nonatomic, assign)BOOL isPhone;

@property (nonatomic,strong) NSString * ssoToken;//for background be killed;

@property (nonatomic,readonly) UINavigationController * rootNav;

@property (nonatomic, strong) SideMenuController * side;

@property (nonatomic, assign)BOOL isBackground;


#define TheAPPDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])
@end

