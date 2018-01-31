//
//  AgeView.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AgeDelegata <NSObject>
- (void)ageNum:(NSString *)str;
- (void)ageMove;

@end
@interface AgeView : UIView
@property(nonatomic,weak)id<AgeDelegata>delegate;
-(instancetype)initWithFrame:(CGRect)frame ageArray:(NSArray *)perArray labelString:(NSString *)labelString;
@end
