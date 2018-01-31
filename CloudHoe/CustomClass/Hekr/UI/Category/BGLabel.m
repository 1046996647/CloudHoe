//
//  BGLabel.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/30.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "BGLabel.h"
#import "Tool.h"

@implementation BGLabel

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 3.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = rgba(204,204,204,0.5).CGColor;
    
}

@end
