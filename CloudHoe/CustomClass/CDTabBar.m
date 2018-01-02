//
//  CDTabBar.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDTabBar.h"
//#import "UIButton+Edge.h"

@interface CDTabBar()
@property (nonatomic, strong) UIButton *middleBtn;
@end

@implementation CDTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width/5.0;
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setImage:[UIImage imageNamed:@"拍摄"] forState:UIControlStateNormal];
    sendBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [sendBtn setTitle:@"拍摄" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.size = CGSizeMake(w, 80);
    sendBtn.centerX = self.width / 2;
    sendBtn.centerY = 9;
    [sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    self.middleBtn = sendBtn;
//    sendBtn.backgroundColor = [UIColor redColor];
    
    UILabel *label = [UILabel labelWithframe:CGRectMake(0, sendBtn.height-14, sendBtn.width, 12) text:@"拍摄" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter textColor:@""];
    label.textColor = [UIColor grayColor];
    [sendBtn addSubview:label];

    // 其他位置按钮
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0 , j = 0; i < count; i++)
    {
        UIView *view = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class])
        {
            view.width = self.width / 5.0;
            view.left = self.width * j / 5.0;
            j++;
            if (j == 2)
            {
                j++;
            }
        }
    }

}
// 发布
- (void)didClickPublishBtn:(UIButton*)sender {
    if (self.didMiddBtn) {
        self.didMiddBtn();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden == NO)
    {
        CGPoint newP = [self convertPoint:point toView:self.middleBtn];
        if ( [self.middleBtn pointInside:newP withEvent:event])
        {
            return self.middleBtn;
        }else
        {
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
}

@end
