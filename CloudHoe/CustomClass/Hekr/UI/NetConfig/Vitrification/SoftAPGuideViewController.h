//
//  SoftAPGuideViewController.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/31.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "HekrMainViewController.h"

@interface SoftAPGuideViewController : HekrMainViewController

-(void)setConfigType:(ConfigDeviceType )type ssid:(NSString *)ssid password:(NSString *)pwd pinCode:(NSString *)pin;

@end
