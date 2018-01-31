//
//  ResetPhoneViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/4/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetPhoneViewDelegate <NSObject>

- (void)PassingOnUser:(NSString *)num;

@end

@interface ResetPhoneViewController : UIViewController
@property (nonatomic, weak)id <ResetPhoneViewDelegate>delegate;
- (instancetype)initWithNumber:(NSString *)number;

@end
