//
//  SectorImageView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/11.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "SectorImageView.h"
#import "Tool.h"

@interface SectorImageView ()
@property (nonatomic, strong)CAShapeLayer *circleLayer;           //圆环图层
@property (nonatomic ,assign)float fromValue;
@end

@implementation SectorImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromHex(0xcccccc);
        self.layer.cornerRadius = self.frame.size.width * 0.5f;

        //提取比例数据
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:MIN(self.frame.size.width/2, self.frame.size.height/2) startAngle:-M_PI/2 endAngle:-M_PI/2 clockwise:YES];
        [path addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.fillColor = getButtonBackgroundColor().CGColor;//设置填充颜色
        _circleLayer.path = path.CGPath;
        [self.layer addSublayer:_circleLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame step:(NSInteger)step{
    self = [super initWithFrame:frame];
    if (self) {
        
        //1.中心点
        CGFloat centerWidth = self.frame.size.width * 0.5f;
        CGFloat centerHeight = self.frame.size.height * 0.5f;
        CGFloat centerX = centerWidth;
        CGFloat centerY = centerHeight;
        CGPoint centerPoint = CGPointMake(centerX, centerY);
        CGFloat radiusBasic = centerWidth > centerHeight ? centerHeight : centerWidth;
        
        self.backgroundColor = UIColorFromHex(0xcccccc);
        self.layer.cornerRadius = radiusBasic;
        
        //2.背景路径
        CGFloat bgRadius = radiusBasic * 0.5;
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                              radius:bgRadius
                                                          startAngle:-M_PI_2
                                                            endAngle:M_PI_2 * 3
                                                           clockwise:YES];
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.fillColor   = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = getButtonBackgroundColor().CGColor;
        _circleLayer.strokeStart = 0.0f;
        _circleLayer.strokeEnd   = 1.0f;
        _circleLayer.zPosition   = 1;
        _circleLayer.lineWidth   = bgRadius * 2.0f;
        _circleLayer.path        = bgPath.CGPath;
        
        [self.layer addSublayer:_circleLayer];
        
        _fromValue = 0.2f*step;
        [self stroke:0.2f*(step+1)];
    }
    return self;
}

-(void)setStrokeStep:(NSInteger)step{
    [self stroke:(0.2f*(step+1))];
}

- (void)stroke:(float)value{
    if (_fromValue==value) {
        return;
    }
    //画图动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = 1;
    animation.fromValue = [NSNumber numberWithFloat:_fromValue];
    animation.toValue   = [NSNumber numberWithFloat:value];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_circleLayer addAnimation:animation forKey:@"circleAnimation"];
    
    _fromValue = value;
}

-(void)setSectorStep:(NSInteger)step{
    //设置开始弧度
    CGFloat endDegres = M_PI*2*(0.2f*(step+1))-M_PI/2;
    //提取比例数据
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:MIN(self.frame.size.width/2, self.frame.size.height/2) startAngle:-M_PI/2 endAngle:endDegres clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    _circleLayer.path = path.CGPath;
}

@end
