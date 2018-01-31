//
//  DevInfoViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesModel.h"
#import "Tool.h"
@interface DevInfoViewController : UIViewController

- (instancetype)initWIthupData:(BOOL)isUpdata Data:(HekrDevice *)data OtaRule:(id)otarule;

@end
