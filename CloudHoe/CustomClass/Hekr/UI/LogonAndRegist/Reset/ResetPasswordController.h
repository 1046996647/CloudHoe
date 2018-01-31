//
//  ResetPasswordController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/4/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetPasswordDelegate <NSObject>

- (void)PassingOnUserNum:(NSString *)num;

@end

@interface ResetPasswordController : UIViewController
@property (nonatomic, weak)id <ResetPasswordDelegate>delegate;
@end
