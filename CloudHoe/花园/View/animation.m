//
//  animation.m
//  雷达
//
//  Created by zhangdaqiang on 16/10/24.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "animation.h"

@implementation animation

- (void)drawRect:(CGRect)rect {
    
//    NSLog(@"进入");
    //半径
    CGFloat redbius = 60;
    //开始角度
    CGFloat startAngle = 0;
    //中心点
//    CGRect CGFrome =[UIScreen mainScreen].bounds;
    
    CGFloat CGfrom_x= kScreenWidth;
    
    CGPoint point = CGPointMake(CGfrom_x/2, CGfrom_x/2);
    //结束角
    CGFloat endAngle = 2*M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:redbius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path=path.CGPath;   //添加路径
    layer.strokeColor=[UIColor colorWithHexString:@"#84D9E5"].CGColor;
    layer.fillColor=[UIColor colorWithHexString:@"#84D9E5"].CGColor;
    [self.layer addSublayer:layer];

}

@end
