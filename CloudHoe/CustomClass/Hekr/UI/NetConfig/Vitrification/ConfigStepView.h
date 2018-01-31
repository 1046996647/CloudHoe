//
//  ConfigStepView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/1.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HekrAPI.h>

@interface ConfigStepView : UIView

-(void)start;

-(void)configSuccessWithStep:(ConfigDeviceStep )setp;
-(void)configFailWithStep:(ConfigDeviceStep )setp;

@end
