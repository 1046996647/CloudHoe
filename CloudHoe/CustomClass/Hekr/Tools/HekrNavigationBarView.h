//
//  HekrNavigationBarView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/10/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HekrNavigationBarView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title leftBarButtonAction:(void(^)(void)) leftBlock withRightTitle:(NSString *)rightTitle leftBarButtonAction:(void(^)(void)) rightBlock;

- (void)refreshBackgroundColor;

@end
