//
//  DevShareViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesModel.h"

@interface DevShareViewController : UIViewController

- (instancetype)initWithDATA:(HekrDevice *)data isShow:(BOOL)isshow;

@end
