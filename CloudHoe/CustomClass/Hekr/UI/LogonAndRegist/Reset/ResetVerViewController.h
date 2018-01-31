//
//  ResetVerViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/9/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetVerViewControllerDelegate <NSObject>

- (void)resetVerViewControllerAction:(NSString *)num;

@end

@interface ResetVerViewController : UIViewController

@property (nonatomic, weak)id<ResetVerViewControllerDelegate>delegate;

- (instancetype)initWithPhoneNum:(NSString *)phoneNum isHaveSecurity:(BOOL)isHaveSecurity;

@end
