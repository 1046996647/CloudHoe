//
//  WordsButton.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/29.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "WordsButton.h"
#import "Tool.h"

@implementation WordsButton

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
}

@end
