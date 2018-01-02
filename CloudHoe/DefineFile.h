//
//  HelpMac.h
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h

//----------------------系统----------------------------
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define iOS_Version_9  [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0

//是否是iOS 7 及 以上版本
#define iOS_Version_7  [[[UIDevice currentDevice] systemVersion] floatValue] > 7.0

//是否是iOS 8 及 以上版本
#define iOS_Version_8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#define Is_iOS_Version_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)?YES:NO


//判断iphone5
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6
#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphoneX
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//-------------------获取设备大小尺寸-------------------------
//设备屏幕尺寸 屏幕Size
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kXBarHeight 34.0
#define kTabBarHeight (kStatusBarHeight > 20 ? 83 : 49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//-------------------获取设备大小尺寸-------------------------
//设备屏幕尺寸 屏幕Size
//#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenHeight (Device_Is_iPhoneX ? ([UIScreen mainScreen].bounds.size.height - kXBarHeight) : ([UIScreen mainScreen].bounds.size.height))

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)



#define scaleWidth kScreenWidth/375
#define scaleY kScreenHeight/568

//#define scaleX kScreen_Width/320

// 字体大小
#define SystemFont(size) [UIFont systemFontOfSize:size]

// 颜色
#define colorWithHexStr(str) [UIColor colorWithHexString:str];



// -------------------重写NSLog------------------------
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr, "\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(format, ...) nil
#endif



#endif /* RequestUrl_h */


