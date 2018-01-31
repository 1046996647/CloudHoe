//
//  ResetPassWordForPhoneViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/9/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetPassWordForPhoneDelegate <NSObject>

- (void)resetPassWordForPhoneDelegateAction:(NSString *)num;

@end

@interface ResetPassWordForPhoneViewController : UIViewController

@property (nonatomic, weak)id<ResetPassWordForPhoneDelegate>delegate;

- (instancetype)initWithToken:(NSString *)token Num:(NSString *)num isSafety:(BOOL)isSafety;

@end
