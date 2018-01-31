//
//  InputTextField.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/30.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "InputTextField.h"
#import "Tool.h"

@implementation InputTextField

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];

    
}

@end
