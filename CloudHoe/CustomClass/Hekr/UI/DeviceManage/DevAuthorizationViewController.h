//
//  DevAuthorizationViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesModel.h"
@interface DevAuthorizationViewController : UIViewController
- (instancetype)initWith:(HekrDevice *)data UID:(NSString *)uid;
@end
