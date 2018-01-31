//
//  ConfigAniProgressView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/1.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigAniProgressView.h"
#import "Tool.h"
#import "UIImageView+ThemeColor.h"

#define downTime 100

@interface ConfigAniProgressView ()<CAAnimationDelegate>

@property (nonatomic, strong)UIView *loopView;                  //圆环背景view
@property (nonatomic, strong)CAShapeLayer *ringLayer;           //圆环图层
@property (nonatomic, strong)CAShapeLayer *ringBackGroundLayer; //圆环背景图层

@property (nonatomic, strong)IBOutlet UILabel *descLabel;
@property (nonatomic, strong)UIImageView *stateImage;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic ,strong) NSTimer *downTimer;
@property (nonatomic ,assign) NSInteger downNum;

@end

@implementation ConfigAniProgressView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ConfigAniProgressView" owner:self options:nil] objectAtIndex:0];
        view.frame = self.bounds;
        [self addSubview:view];
        
        [self drawAniProgressView];
    }
    return self;
}

-(void)drawAniProgressView{
    
    _descLabel.text = NSLocalizedString(@"尽可能使设备、路由器、手机相互靠近", nil);
    
    _stateImage = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-Hrange(100))/2, Hrange(142), Hrange(100), Hrange(100))];
    _stateImage.image = [UIImage imageNamed:@"ic_router_fail"];
    [self addSubview:_stateImage];
    //半径
    CGFloat radius = Hrange(124);
    
    CGFloat ringLineWidth = 4;
    
    _loopView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-Hrange(248))/2, Hrange(66), Hrange(248), Hrange(248))];
    _loopView.backgroundColor = UIColorFromHex(0xf3f3f3);
    [self addSubview:_loopView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:_loopView.bounds];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"100s";
    _timeLabel.font = [UIFont systemFontOfSize:36.0f];
    [_loopView addSubview:_timeLabel];

    //背景圆环
    _ringBackGroundLayer = [CAShapeLayer layer];
    _ringBackGroundLayer.fillColor = [UIColor clearColor].CGColor;
    _ringBackGroundLayer.strokeColor = UIColorFromHex(0xcccccc).CGColor;
    _ringBackGroundLayer.lineWidth = ringLineWidth;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_loopView.frame.size.width/2, _loopView.frame.size.height/2) radius:radius startAngle:-M_PI/2 endAngle:3*M_PI/2 clockwise:YES];
    //    path.lineCapStyle = kCGLineCapRound;
    //    path.lineJoinStyle = kCGLineCapRound;
    _ringBackGroundLayer.path = path.CGPath;
    [_loopView.layer addSublayer:_ringBackGroundLayer];
    //动画圆环
    _ringLayer = [CAShapeLayer layer];
    _ringLayer.fillColor = [UIColor clearColor].CGColor;
    _ringLayer.strokeColor = getButtonBackgroundColor().CGColor;
    _ringLayer.lineWidth = ringLineWidth;
    //round
    //    square
    //弧形线帽
    _ringLayer.lineCap = @"round";
    [_loopView.layer addSublayer:_ringLayer];
    
    _ringLayer.path = path.CGPath;
    {
        CAKeyframeAnimation *ringAnimationEnd = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        ringAnimationEnd.delegate = self;
        ringAnimationEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        ringAnimationEnd.repeatCount = MAXFLOAT;
        ringAnimationEnd.duration = downTime;
        ringAnimationEnd.values = @[@1,@0];
        ringAnimationEnd.autoreverses = NO;
        ringAnimationEnd.removedOnCompletion = NO;
        ringAnimationEnd.fillMode = kCAFillModeBoth;
        [_ringLayer addAnimation:ringAnimationEnd forKey:nil];
        
        [self pauseAnimation];
    }
    
    [self resumeAnimation];
    
}

#pragma mark - 动画开始&&暂停
// 停止动画
- (void)pauseAnimation
{
    self.loading = NO;
    // 取出当前的时间点，就是暂停的时间点
    //    CFTimeInterval pausetime = [_ringLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设定时间偏移量，让动画定格在那个时间点
    [_ringLayer setTimeOffset:0];
    
    // 将速度设为0
    [_ringLayer setSpeed:0.0f];
    
}

// 恢复动画
- (void)resumeAnimation
{
     self.loading = YES;
    [self setInitTime];

    // 获取暂停的时间
    CFTimeInterval pausetime = _ringLayer.timeOffset;
    
    // 计算出此次播放时间(从暂停到现在，相隔了多久时间)
    CFTimeInterval starttime = CACurrentMediaTime() - pausetime;
    
    // 将时间偏移量设为0(重新开始)；
    _ringLayer.timeOffset = 0.0;
    
    // 设置开始时间(beginTime是相对于父级对象的开始时间,系统会根据时间间隔帮我们算出什么时候开始动画)
    _ringLayer.beginTime = starttime;
    
    // 将速度恢复，设为1
    _ringLayer.speed = 1.0;
    
}

-(void)setInitTime{
    if (_downTimer) {
        [_downTimer invalidate];
        _downTimer = nil;
    }
    _downNum = -1;
    [self timerFunc];
    _downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
}

-(void)timerFunc{
    _downNum++;
    _timeLabel.text = [NSString stringWithFormat:@"%lds",downTime-_downNum];
    if (_delegate && [_delegate respondsToSelector:@selector(aniProgressTimerFunc)]) {
        [_delegate aniProgressTimerFunc];
    }
    if (self.downNum==downTime-10) {
        if (_delegate && [_delegate respondsToSelector:@selector(aniProgressStopConfig)]) {
            [_delegate aniProgressStopConfig];
        }
        
    }else if (self.downNum==downTime-15) {
        if (_delegate && [_delegate respondsToSelector:@selector(aniProgressInterFunc)]) {
            [_delegate aniProgressInterFunc];
        }
    }else if (self.downNum==downTime) {
        if (_downTimer) {
            [_downTimer invalidate];
            _downTimer = nil;
        }
        [self pauseAnimation];
        if (_delegate && [_delegate respondsToSelector:@selector(aniProgressEnd)]) {
            [_delegate aniProgressEnd];
        }
    }
}

-(void)start{
    _descLabel.text = NSLocalizedString(@"尽可能使设备、路由器、手机相互靠近", nil);
    _loopView.hidden = NO;
    [self resumeAnimation];
   
}

-(void)stop{
    if (_downTimer) {
        [_downTimer invalidate];
        _downTimer = nil;
    }
    [self pauseAnimation];
}

-(void)fail:(NSString *)title{
    if (_downTimer) {
        [_downTimer invalidate];
        _downTimer = nil;
    }
    _descLabel.text = NSLocalizedString(title, nil);
    _stateImage.image = [UIImage imageNamed:@"ic_router_fail"];

    _loopView.hidden = YES;
    [self pauseAnimation];
}

-(void)success{
    if (_downTimer) {
        [_downTimer invalidate];
        _downTimer = nil;
    }
    _descLabel.text = NSLocalizedString(@"设备连接成功", nil);
    
//    _stateImage.tintColor = getButtonBackgroundColor();
//    UIImage *placeholderImage = [UIImage imageNamed:@"ic_router_success"];
//    placeholderImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    _stateImage.image = placeholderImage;
    
    [_stateImage setThemeImageNamed:@"ic_router_success"];
    
    _loopView.hidden = YES;
    [self pauseAnimation];
}

@end
