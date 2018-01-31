//
//  ConfigStepTitleCell.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/5.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HekrAPI.h>

@interface ConfigStepTitleCell : UITableViewCell

-(void)setConfigStepWithStep:(ConfigDeviceStep )step state:(BOOL)state device:(NSDictionary *)device show:(BOOL)show;

@end
