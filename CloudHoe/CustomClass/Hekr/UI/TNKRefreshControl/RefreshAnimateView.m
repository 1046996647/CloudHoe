//
//  RefreshAnimateView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/5/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "RefreshAnimateView.h"


@interface RefreshAnimateView ()
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, assign) BOOL isOnce;
@property (nonatomic, assign) BOOL isShowAnimate;
@property (nonatomic, assign) BOOL isAnimateEnd;
@end

@implementation RefreshAnimateView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isOnce = YES;
        _isAnimateEnd = YES;
        _ballView = [UIView new];
        _ballView.backgroundColor = [UIColor colorWithRed:232/255.0 green:237/255.0 blue:243/255.0 alpha:1.0];
        [self addSubview:_ballView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_isOnce) {
        _ballView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        _ballView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _ballView.layer.cornerRadius = _ballView.frame.size.height/2;
        _isOnce = NO;
    }
}

- (void)beginAnimat{
    _isShowAnimate = YES;
    [self animateAction];
}

-(void)stopAnimat{
    _isShowAnimate = NO;

}


- (void)animateAction{
    if (_isShowAnimate == NO) {
        return;
    }
    if (_isAnimateEnd != YES) {
        return;
    }
    _isAnimateEnd = NO;
    [UIView setAnimationDuration:0.0];
    
    [UIView animateWithDuration:0.5 animations:^{
        _ballView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.5 animations:^{
            _ballView.frame = CGRectMake(self.frame.size.width/2-self.frame.size.height/2, 0, self.frame.size.height, self.frame.size.height);
        } completion:^(BOOL finished) {
            _isAnimateEnd = YES;
            [self animateAction];
        }];
    }];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
