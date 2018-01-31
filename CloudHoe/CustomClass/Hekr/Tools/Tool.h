//
//  Tool.h
//  HekrSDKAPP
//
//  Created by 马滕亚 on 15/11/20.
//  Copyright © 2015年 Mike. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <UMMobClick/MobClick.h>
#import "UIButton+HeKrButton.h"
#import "EasyMacro.h"
//#import "Toast+UIView.h"
#import "UIView+Toast.h"
#import "HekrNavigationBarView.h"
#import <Masonry.h>
#import "UIViewController+CustomAlertView.h"

const static NSUInteger ddLogLevel = DDLogLevelAll;
typedef void(^BlockType)(id result);
@interface Tool : NSObject

// 解析Json数据
+ (id)getJsonDataFromFile:(NSString *)fileName;
+ (NSData *)jsonToData:(id)json;
+ (id)dataToJson:(NSData *)data;
+(NSDictionary *)getProfileJsonData;

@end
BOOL isEN();
NSString* lang();
NSString* md5(NSString* str);

NSString * APIError(NSError* error);
NSUInteger APIErrorCode(NSError* error);
BOOL validateMobile(NSString *mobile);
BOOL validateEmail(NSString *email);
BOOL validatePassWord(NSString *passWord);
BOOL isNightTheme();
UIColor * getNavBackgroundColor();
NSString * getNavPopBtnImg();
UIColor * getNavTitleColor();
UIColor * getViewBackgroundColor();
UIColor * getButtonBackgroundColor();
UIColor * getDevOnlineColor();
UIColor * getDevOfflineColor();
UIColor * getCellBackgroundColor();
UIColor * getCellLineColor();
UIColor * getTitledTextColor();
UIColor * getDescriptiveTextColor();
UIColor * getPlaceholderTextColor();
UIColor * getInputTextColor();
UIColor * getTempColor();
UIColor * getCityColor();
UIColor * getHumColor();
UIColor * getSuggestColor();
NSString *getDeviseViewBgImg();
NSString *getDeviseTopBgImg();
NSString *getUserTopBgImg();
NSString *getSideBgImg();
NSString *getOnLineImg();
NSArray *getDeviseIcon(BOOL isShow);
NSString *getThemeName();
NSUInteger getThemeCode();
NSString *getWifiName();
NSString *getConfigGuideBgImg();

UIFont *getNavTitleFont();
UIFont *getButtonTitleFont();
UIFont *getListTitleFont();
UIFont *getDescTitleFont();
