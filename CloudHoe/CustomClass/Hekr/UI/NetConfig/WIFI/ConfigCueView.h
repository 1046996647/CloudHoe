//
//  ConfigCueView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/5/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigCueView : UIView
@property(nonatomic ,strong)UIView *bgView;

- (instancetype)initWithFrame:(CGRect)frame NetAction:(SEL)netAction Cancel:(SEL)cancel Next:(SEL)next Delegate:(id)delegate;
@end
