//
//  ConfigPassWordView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/7/6.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfigPassWordDelegate <NSObject>
- (void)congfigStarActionWifiName:(NSString *)wifiName PassWord:(NSString *)passWord;
@end

@interface ConfigPassWordView : UIView
@property (nonatomic, weak)id <ConfigPassWordDelegate>delegate;

- (void)refreshSSID;

@end
