//
//  HekrNavigationBarView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/10/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "HekrNavigationBarView.h"
#import "Tool.h"

@interface HekrNavigationBarView ()
@property (nonatomic, copy)void (^leftBlock)(void);
@property (nonatomic, copy)void (^rightBlock)(void);
@property (nonatomic, strong)UILabel *titLabel;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UILabel *downLabel;
@end

@implementation HekrNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title leftBarButtonAction:(void(^)(void)) leftBlock withRightTitle:(NSString *)rightTitle leftBarButtonAction:(void(^)(void)) rightBlock{
    if (self = [super initWithFrame:frame]) {
        _leftBlock = leftBlock;
        self.backgroundColor = getNavBackgroundColor();
        _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 42)];
        _titLabel.center = CGPointMake(self.frame.size.width/2, StatusBarHeight+22);
        _titLabel.backgroundColor = [UIColor clearColor];
        _titLabel.textAlignment = NSTextAlignmentCenter;
        _titLabel.textColor = getNavTitleColor();
        _titLabel.text = NSLocalizedString(title, nil);
        _titLabel.font = getNavTitleFont();
        [self addSubview:_titLabel];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, StatusBarHeight, 60, 44);
        [_button setImage:[UIImage imageNamed:getNavPopBtnImg()] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        _downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame)-1, self.frame.size.width, 1)];
        _downLabel.backgroundColor = getCellLineColor();
        _downLabel.alpha = 0.5;
        [self addSubview:_downLabel];
        if (rightTitle) {
            _rightBlock = rightBlock;
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(self.frame.size.width - 110, StatusBarHeight, 100, 44);
            [rightBtn setTitle:NSLocalizedString(rightTitle, nil) forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightBtn];
            
        }
    }
    return self;
}

- (void)popClick{
    _leftBlock();
}

- (void)rightAction{
    _rightBlock();
}

- (void)refreshBackgroundColor{
    self.backgroundColor = getNavBackgroundColor();
    _titLabel.textColor = getNavTitleColor();
    _downLabel.backgroundColor = getCellLineColor();
    [_button setImage:[UIImage imageNamed:getNavPopBtnImg()] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
