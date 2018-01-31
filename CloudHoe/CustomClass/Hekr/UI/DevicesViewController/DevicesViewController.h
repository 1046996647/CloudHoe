//
//  DevicesViewController.h
//  HekrSDKAPP
//
//  Created by Mike on 16/2/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesModel.h"

@interface DevicesViewController : UIViewController
@property (nonatomic, copy)NSString *upText;
@property (nonatomic,strong) DevicesModel * model;//数据源model
- (void)isShowBack;
@end
