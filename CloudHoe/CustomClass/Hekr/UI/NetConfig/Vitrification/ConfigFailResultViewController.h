//
//  ConfigFailResultViewController.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/6.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HekrMainViewController.h"

@interface ConfigFailResultViewController : HekrMainViewController

-(void)setConfigDeviceType:(ConfigDeviceType )type configStep:(ConfigDeviceStep )step device:(NSDictionary *)device;

@end
