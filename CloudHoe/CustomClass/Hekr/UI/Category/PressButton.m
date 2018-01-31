//
//  PressButton.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/29.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "PressButton.h"
#import "Tool.h"

@implementation PressButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self setBackgroundColor:getButtonBackgroundColor()];
    self.layer.cornerRadius = 3.0f;
    [self setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];

}


@end
