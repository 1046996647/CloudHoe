//
//  UserInfoView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/9/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoViewDelegate <NSObject>

- (void)changeUserInfos;

@end

@interface UserInfoView : UIView

@property (nonatomic, weak)id <UserInfoViewDelegate>delegate;
@property (nonatomic ,assign,readonly) float height;

- (void)setUserInfos:(NSMutableDictionary *)info;

@end
