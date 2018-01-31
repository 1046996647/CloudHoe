//
//  StatusBar.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTStatusBarOverlay.h"
#import <MessageUI/MFMailComposeViewController.h>

typedef NS_ENUM(NSUInteger, HekrEnvironmentType) {
    HekrEnvironmentTypeFormal,         //正式环境
    HekrEnvironmentTypeTest,      //测试环境
};

@interface StatusBar : UIWindow <MTStatusBarOverlayDelegate,MFMailComposeViewControllerDelegate>

+ (StatusBar *)sharedInstance;
-(void) setEnvironmentType:(HekrEnvironmentType )type;
-(HekrEnvironmentType) getEnvironmentType;

@end
