//
//  UserDetailedViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDetailedViewDelegate <NSObject>

- (void)saveUserInfo:(NSMutableDictionary *)info;

@end

@interface UserDetailedViewController : UIViewController

@property (nonatomic, weak)id<UserDetailedViewDelegate>delegate;

- (instancetype)initWithData:(NSMutableDictionary *)data;

@end
