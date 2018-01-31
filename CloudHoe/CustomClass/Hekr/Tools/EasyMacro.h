//
//  EasyMacro.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/22.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef EasyMacro_h
#define EasyMacro_h


#endif /* EasyMacro_h */
#define rgb(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define rgba(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define ringLineBackGroundColor   rgb(190,240,230)
#define ringLineColor rgb(75,200,200)

#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height
#define Hrange(x)  (x/750.0)*ScreenWidth
#define Vrange(x)  (x/750.0)*ScreenWidth
//#define Vrange(x)  (x/1334.0)*ScreenHeight

#define sHrange(x)  (x/375.0)*ScreenWidth
#define sVrange(x)  (x/375.0)*ScreenWidth
#define loginVrange(x)  (x/667.0)*ScreenHeight

#define BUTTONWIDTH sHrange(320)
#define BUTTONHEIGHT sVrange(40)
#define BUTTONRadius 3.0f
#define MAX_STARWORDS_LENGTH 16
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#define iPhone4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 电量条 高
#define StatusBarHeight (iPhoneX ? 44.f : 20.f)
// 导航栏 高
#define StatusBarAndNavBarHeight (iPhoneX ? 88.f : 64.f)
// 分栏 高
#define TabbarHeight (iPhoneX ? (49.f+34.f) : 49.f)

#define BarViewRectMake CGRectMake(0, 0, ScreenWidth, StatusBarAndNavBarHeight)
#define CoverViewRectMake CGRectMake(0, StatusBarAndNavBarHeight, ScreenWidth, ScreenHeight-StatusBarAndNavBarHeight)



