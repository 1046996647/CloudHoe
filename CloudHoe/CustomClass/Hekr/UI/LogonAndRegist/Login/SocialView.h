//
//  SocialView.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SocialDelegata <NSObject>
- (void)socialLoginAction:(UIButton *)btn;

@end
@interface SocialView : UIView

@property (weak, nonatomic) IBOutlet UIButton *wechat;

@property (weak, nonatomic) IBOutlet UILabel *socialLable;
@property(nonatomic,weak)id<SocialDelegata>delegate;

@end
