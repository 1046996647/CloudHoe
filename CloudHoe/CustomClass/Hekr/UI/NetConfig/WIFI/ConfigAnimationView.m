//
//  ConfigAnimationView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ConfigAnimationView.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>


@interface ConfigAnimationView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *loopView;                 //圆环背景view
@property (nonatomic, strong)CAShapeLayer *ringLayer;           //圆环图层
@property (nonatomic, strong)CAShapeLayer *ringBackGroundLayer; //圆环背景图层
@property (nonatomic, strong)CAShapeLayer *rightLayer;          //对号图层
@property (nonatomic, strong)UILabel *label1;                   //通用label
@property (nonatomic, strong)UILabel *label2;                   //通用label
@property (nonatomic, strong)UILabel *numLabel;                 //连接设备个数
@property (nonatomic, strong)UILabel *pointLabel;               //显示“...”
@property (nonatomic, strong)UIImageView *failImage;            //失败时“X”
@property (nonatomic, strong)UIScrollView *devScroll;           //连接到设备显示滚动视图
@property (nonatomic, strong)UIButton *nextButton;              //“重试”按钮
@property (nonatomic, strong)UILabel *solveLabel;               //"查看常见解决方案"按钮
@property (nonatomic, strong)UIButton *popButton;               //“返回按钮”
@property (nonatomic, strong)UIButton *finishButton;            //“完成按钮”
@property (nonatomic, assign)CGPoint devPoint;
@property (nonatomic, assign)CGFloat maxY;
@property (nonatomic, assign)CGFloat loopWidth;
@property (nonatomic, assign)NSInteger pointNumber;
@property (nonatomic, assign)NSInteger devCount;
@property (nonatomic, assign)NSInteger failCount;
@property (nonatomic, assign)NSInteger arrCount;
@property (nonatomic, strong)NSMutableArray *failDev;
@property (nonatomic, assign)NSInteger bugCount;
@property (nonatomic, strong)UIButton *failReasonBtn;
@property (nonatomic, assign)BOOL isScan;
@end

@implementation ConfigAnimationView

- (instancetype)initWithFrame:(CGRect)frame isScan:(BOOL)isScan{
    self = [super initWithFrame:frame];
    if (self) {
        _isScan = isScan;
        _isHave = NO;
        _isBackground = NO;
        _devCount = 0;
        _failCount = 0;
        self.alpha = 0;
        _bugCount = 0;
        _failDev = [NSMutableArray new];
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height - 30)];
        [self addSubview:_mainView];
        [self createViews];
    }
    return self;
}

- (void)createViews{

    CGFloat width = self.frame.size.width;
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, 10, 30, 30);
    [cancel setImage:[UIImage imageNamed:@"iconfont-quxiao"] forState:UIControlStateNormal];
    [cancel setImageEdgeInsets:UIEdgeInsetsMake((30-Hrange(32))/2, (30-Hrange(32))/2, (30-Hrange(32))/2, (30-Hrange(32))/2)];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:cancel];
    //半径
    CGFloat radius = Hrange(135);
    //135/750.0*self.view.frame.size.width;
    CGFloat diam = radius*2;
    //圆心
    CGPoint ringCenter = CGPointMake(width/2.0, (radius * 4.0)/3.0*2.0-20);
    
    CGFloat ringLineWidth = 10;
    
    _loopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, diam+10, diam+10)];
    _loopView.backgroundColor = [UIColor clearColor];
    _loopView.center = ringCenter;
    [_mainView addSubview:_loopView];
    
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loopView.frame)+Vrange(100), width, 30)];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.text = NSLocalizedString(@"连接中", nil);
    _label1.textColor = getTitledTextColor();
    _label1.font = [UIFont systemFontOfSize:18];
    CGPoint labelCenter = _label1.center;
    [_mainView addSubview:_label1];
    //背景圆环
    _ringBackGroundLayer = [CAShapeLayer layer];
    _ringBackGroundLayer.fillColor = [UIColor clearColor].CGColor;
    _ringBackGroundLayer.strokeColor = ringLineBackGroundColor.CGColor;
    _ringBackGroundLayer.lineWidth = ringLineWidth;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_loopView.frame.size.width/2, _loopView.frame.size.height/2) radius:radius startAngle:-M_PI/2 endAngle:3*M_PI/2 clockwise:YES];
    //    path.lineCapStyle = kCGLineCapRound;
    //    path.lineJoinStyle = kCGLineCapRound;
    _ringBackGroundLayer.path = path.CGPath;
    [_loopView.layer addSublayer:_ringBackGroundLayer];
    //动画圆环
    _ringLayer = [CAShapeLayer layer];
    _ringLayer.fillColor = [UIColor clearColor].CGColor;
    _ringLayer.strokeColor = ringLineColor.CGColor;
    _ringLayer.lineWidth = ringLineWidth;
    //round
    //    square
    //弧形线帽
    _ringLayer.lineCap = @"round";
    [_loopView.layer addSublayer:_ringLayer];
    
    _ringLayer.path = path.CGPath;
    {
        CAKeyframeAnimation *ringAnimationStart = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        ringAnimationStart.duration = 0.9;
        //    ringAnimationStart.repeatCount = MAXFLOAT;
        ringAnimationStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        ringAnimationStart.values = @[@1,@0];
        ringAnimationStart.delegate = self;
        //    ringAnimationStart.autoreverses = NO;
        ringAnimationStart.removedOnCompletion = YES;
        
        
        CAKeyframeAnimation *ringAnimationEnd = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        ringAnimationEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        ringAnimationEnd.delegate = self;
        //    ringAnimationEnd.repeatCount = MAXFLOAT;
        ringAnimationEnd.duration = 0.9;
        ringAnimationEnd.values = @[@1,@0];
        ringAnimationEnd.beginTime = 0.9f;
        //    ringAnimationEnd.autoreverses = NO;
        ringAnimationEnd.removedOnCompletion = YES;
        //    [_ringLayer addAnimation:ringAnimationEnd forKey:nil];
        
        
        CAAnimationGroup * ringAnimationGroup = [CAAnimationGroup animation];
        ringAnimationGroup.animations = [NSArray arrayWithObjects:ringAnimationStart,ringAnimationEnd, nil];
        ringAnimationGroup.duration = 1.8;
        ringAnimationGroup.repeatCount = MAXFLOAT;
        //    ringAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        ringAnimationGroup.autoreverses = NO;
        ringAnimationGroup.removedOnCompletion = NO;
        //    ringAnimationGroup.removedOnCompletion = YES;
        [_ringLayer addAnimation:ringAnimationGroup forKey:nil];
        //    _ringLayer.speed = 0;
        [self pauseAnimation];
    }
    
    
    //对号动画
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(_loopView.frame.size.width/2+radius/2.0-5, _loopView.frame.size.height/2-radius/3.0)];
    //
    [rightPath addLineToPoint:CGPointMake(_loopView.frame.size.width/2.0-5, _loopView.frame.size.height/2+radius/3.0)];
    [rightPath addLineToPoint:CGPointMake(_loopView.frame.size.width/2-radius/3.0-5, _loopView.frame.size.height/2)];
    [rightPath stroke];
    
    _rightLayer = [CAShapeLayer layer];
    _rightLayer.fillColor = [[UIColor clearColor]CGColor];
    _rightLayer.strokeColor = [[UIColor whiteColor] CGColor];
    _rightLayer.lineWidth = 6;
    _rightLayer.lineCap = @"round";
    _rightLayer.lineJoin = @"round";
    _rightLayer.path = [rightPath CGPath];
    [_loopView.layer addSublayer:_rightLayer];
    
    CAKeyframeAnimation *rightAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    rightAnimation.duration = 0.8;
    //    ringAnimationStart.repeatCount = MAXFLOAT;
    rightAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    rightAnimation.values = @[@1,@0];
    rightAnimation.delegate = self;
    //    ringAnimationStart.autoreverses = NO;
    rightAnimation.removedOnCompletion = NO;
    [_rightLayer addAnimation:rightAnimation forKey:nil];
    [self rightPauseAnimation];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y-20);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _loopView.center = CGPointMake(ringCenter.x, ringCenter.y-3);
            _label1.center = CGPointMake(labelCenter.x, labelCenter.y + 3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _loopView.center = CGPointMake(ringCenter.x, ringCenter.y+3);
                _label1.center = CGPointMake(labelCenter.x, labelCenter.y -3);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    _loopView.center = CGPointMake(ringCenter.x, ringCenter.y);
                    _label1.center = CGPointMake(labelCenter.x, labelCenter.y);
                } completion:^(BOOL finished) {
                    
                    [self resumeAnimation];
                }];
            }];
        }];
    }];
    
}
#pragma mark - 配网失败
- (void)configFail{
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loopView.frame), self.frame.size.width, 30)];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.text = NSLocalizedString(@"连接失败", nil);
    _label2.textColor = getTitledTextColor();
    _label2.font = [UIFont systemFontOfSize:18];
    _label2.alpha = 0;
    [_mainView addSubview:_label2];
    
    _failImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _loopView.frame.size.width/2.5, _loopView.frame.size.width/2.5)];
    _failImage.center = CGPointMake(_loopView.frame.size.width/2, _loopView.frame.size.width/2);
    _failImage.image = [UIImage imageNamed:@"ic_config_fail"];
    _failImage.backgroundColor = [UIColor clearColor];
    _failImage.alpha = 0;
    [_loopView addSubview:_failImage];
    
    [UIView animateWithDuration:0.5 animations:^{
        _label1.transform = CGAffineTransformTranslate(_label1.transform, 0, 20);
        _label1.alpha = 0;
    } completion:^(BOOL finished) {
        [_label1 removeFromSuperview];
        _label1 = nil;
        [self pauseAnimation];
        [UIView animateWithDuration:0.5 animations:^{
            _ringBackGroundLayer.fillColor = [rgb(172, 172, 174) CGColor];
            _ringBackGroundLayer.strokeColor = [rgb(211, 211, 211) CGColor];
            _failImage.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            _label2.transform = CGAffineTransformTranslate(_label2.transform, 0, 20);
            _label2.alpha = 1;
        } completion:^(BOOL finished) {
            CGFloat gap = (40/640.0)*self.frame.size.width;
            CGFloat height = (72/1136.0)*ScreenHeight;
            CGFloat width = self.frame.size.width-2*gap;
            _nextButton = [UIButton buttonWithTitle:NSLocalizedString(@"重试",nil) frame:CGRectMake(gap, CGRectGetMaxY(_label2.frame)+(100/1334.0)*ScreenHeight+20, width, height) target:self action:@selector(nextAction:)];
//            _nextButton.frame = CGRectMake(gap, CGRectGetMaxY(_label2.frame)+(100/1334.0)*ScreenHeight+20, width, height);
//            [_nextButton setTitle:NSLocalizedString(@"重试",nil) forState:UIControlStateNormal];
//            [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            _nextButton.backgroundColor = rgb(6, 164, 240);
            _nextButton.alpha = 0;
            _nextButton.tag = 2222;
//            _nextButton.layer.cornerRadius = height/2;
//            [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
            [_mainView addSubview:_nextButton];
            
            _solveLabel = [self createPromptLabel:CGRectMake(0, CGRectGetMaxY(_nextButton.frame)+40, self.frame.size.width, 20) withStr:NSLocalizedString(@"设备连不上？点击这里",nil) withFont:[UIFont systemFontOfSize:15]];
            _solveLabel.textColor = rgb(233, 119, 119);
            [_mainView addSubview:_solveLabel];
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(solveAction)];
            [_solveLabel addGestureRecognizer:tgr];
            
            [UIView animateWithDuration:0.3 animations:^{
                _nextButton.transform = CGAffineTransformTranslate(_label2.transform, 0, -20);
                _nextButton.alpha = 1;
                _solveLabel.transform = CGAffineTransformTranslate(_label2.transform, 0, -20);
                _solveLabel.alpha = 1;
            }];
            
        }];
    }];

    
}

//配网失败重试
- (void)nextAction:(UIButton *)btn{
    self.isBackground = NO;
    [self performSelector:@selector(nextConfig) withObject:nil afterDelay:0.3];
    [UIView animateWithDuration:0.5 animations:^{
        _label2.transform = CGAffineTransformTranslate(_label2.transform, 0, 20);
        _label2.alpha = 0;
        _nextButton.transform = CGAffineTransformTranslate(_nextButton.transform, 0, 20);
        _nextButton.alpha = 0;
        _solveLabel.transform = CGAffineTransformTranslate(_nextButton.transform, 0, 20);
        _solveLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [_nextButton removeFromSuperview];
        [_solveLabel removeFromSuperview];
        [_label2 removeFromSuperview];
        _nextButton = nil;
        _solveLabel = nil;
        _label2 = nil;
    }];
    
    
}

- (void)nextConfig{
    [UIView animateWithDuration:0.5 animations:^{
        _ringBackGroundLayer.fillColor = [[UIColor clearColor] CGColor];
        _ringBackGroundLayer.strokeColor = ringLineBackGroundColor.CGColor;;
        _failImage.alpha = 0;
        
    } completion:^(BOOL finished) {
        _devCount = 0;
        _bugCount = 0;
        [_failDev removeAllObjects];
        [self.delegata animationViewWillConfig];
        [self resumeAnimation];
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loopView.frame)+Vrange(40), self.frame.size.width, 30)];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.text = NSLocalizedString(@"连接中", nil);
        _label1.textColor = getTitledTextColor();
        _label1.font = [UIFont systemFontOfSize:18];
        _label1.alpha = 0;
        [_mainView addSubview:_label1];
        [UIView animateWithDuration:0.3 animations:^{
            _label1.transform = CGAffineTransformTranslate(_label1.transform, 0, -Vrange(20));
            _label1.alpha = 1;
        }];
        [self.delegata animationViewConfig];
    }];
}
#pragma mark - 配网成功
- (void)configSuccess{
    [self popRoot];
    
}

- (void)successAnimate{
    if (_devCount == _failCount) {
        CGFloat width = Hrange(135)*2+10;
        _failImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width/2.5, width/2.5)];
        _failImage.center = CGPointMake(width/2, width/2);
//        _failImage.center = CGPointMake(_loopView.center.x, _loopView.center.y-60);
        _failImage.image = [UIImage imageNamed:@"ic_config_fail"];
        _failImage.backgroundColor = [UIColor clearColor];
        _failImage.alpha = 0;
        [_loopView addSubview:_failImage];
        
        [UIView animateWithDuration:0.5 animations:^{
            _label1.transform = CGAffineTransformTranslate(_label1.transform, 0, 20);
            _label1.alpha = 0;
        } completion:^(BOOL finished) {
//            [_label1 removeFromSuperview];
//            _label1 = nil;
            _label1.transform = CGAffineTransformIdentity;
            _label1.text = NSLocalizedString(@"连接失败",nil);
            _label1.textColor = getTitledTextColor();
            [UIView animateWithDuration:0.5 animations:^{
                _label1.transform = CGAffineTransformTranslate(_label1.transform, 0, 20);
                _label1.alpha = 1;
            }];
            
            [self pauseAnimation];
            [UIView animateWithDuration:0.5 animations:^{
                _ringBackGroundLayer.fillColor = [rgb(172, 172, 174) CGColor];
                _ringBackGroundLayer.strokeColor = [rgb(211, 211, 211) CGColor];
                _failImage.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        //圆环背景色变化
        [UIView animateWithDuration:1 animations:^{
            _ringBackGroundLayer.fillColor = [rgb(59, 193, 190) CGColor];
        } completion:^(BOOL finished) {
            
        }];
        //圆环动画停止
        [UIView animateWithDuration:0.5 animations:^{
            
            [self pauseAnimation];
        } completion:^(BOOL finished) {
            
            //对号动画开始
            [self rightResumeAnimation];
            _pointLabel.text = @"";
        }];
        
    }
}

#pragma mark - 搜索到设备
- (void)configSearched{
    //圆环下移
    [UIView animateWithDuration:0.2 animations:^{
        _loopView.transform = CGAffineTransformTranslate(_loopView.transform, 0, 10);
    } completion:^(BOOL finished) {
        
        
        
//        for (NSInteger i = logoArray.count+1; i>0; i--) {
//            if (i % 4 == 0) {
//                _arrCount = i;
//                break;
//            }
//        }
        
       
//        [self performSelector:@selector(stopAnamation:) withObject:logoArray afterDelay:0.1];
        _loopWidth = _loopView.frame.size.width;
        
        [UIView animateWithDuration:0.5 animations:^{
            _loopView.transform = CGAffineTransformTranslate(_loopView.transform, 0, -60);
            _loopView.transform = CGAffineTransformScale(_loopView.transform, 0.8, 0.8);
//            _label1.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

#pragma mark - 设备滚动视图
- (void)stopAnamation:(NSMutableArray *)logoArray{
    if (logoArray.count == 1) {
        [self configSearched];
        _maxY = CGRectGetMaxY(_loopView.frame)-60;
        CGFloat gap = (24/750.0)*ScreenWidth;
        CGFloat devWidth = (110/750.0)*ScreenWidth;
        CGFloat Hgap = self.frame.size.width/2-(1.5*gap)-(2*devWidth);
        _devScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(Hgap, _maxY + (50/1334.0)*ScreenHeight, self.frame.size.width-(2*Hgap), devWidth+20)];
        _devScroll.backgroundColor = [UIColor clearColor];
        _devScroll.showsHorizontalScrollIndicator = NO;
        [_mainView addSubview:_devScroll];
    }
    
    if (_label1.alpha > 0) {
        if ([logoArray[_devCount][@"bindResultCode"] boolValue]) {
            
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                _label1.alpha = 0;
            }];
        }
    }
    
    CGFloat gap = (24/750.0)*ScreenWidth;
    CGFloat devWidth = (110/750.0)*ScreenWidth;
    CGFloat devViewWidth = (110/750.0)*ScreenWidth;
    CGFloat devImageWidth = (70/750.0)*ScreenWidth;
    //    [self createNumLabel:logoArray];
    //750 1334
    //60 72 0.65
    
    if (_devCount >= logoArray.count) {
        return;
    }
    _devScroll.contentSize = CGSizeMake((logoArray.count * devWidth)+((logoArray.count+1)*gap), devWidth);
    
    if (logoArray.count > 4) {
        [_devScroll setContentOffset:CGPointMake((logoArray.count - 4) * (gap + devWidth), 0) animated:YES];
    }
    
    
    _devPoint = CGPointMake((logoArray.count - 1) * (gap + devWidth), 0);
    
    UIView *devView = [[UIView alloc]initWithFrame:CGRectMake(_devPoint.x, 20, devViewWidth, devViewWidth)];
    devView.alpha = 0;
    devView.layer.cornerRadius = devWidth/2;
    [_devScroll addSubview:devView];
    UIImageView *devImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, devImageWidth, devImageWidth)];
    devImage.center = CGPointMake(devView.center.x, devView.center.y-20);
    devImage.alpha = 0;
    //        devImage.backgroundColor = [UIColor orangeColor];
    [devImage sd_setImageWithURL:[NSURL URLWithString:logoArray[_devCount][@"logo"]] completed:nil];
    if (_isScan == NO) {
        //配网
        
//        CGFloat gap = (24/750.0)*ScreenWidth;
//        CGFloat devWidth = (110/750.0)*ScreenWidth;
//        CGFloat devViewWidth = (110/750.0)*ScreenWidth;
//        CGFloat devImageWidth = (70/750.0)*ScreenWidth;
        
       
        if ([logoArray[_devCount][@"bindResultCode"] boolValue]) {
            [_failDev addObject:logoArray[_devCount]];
            devView.backgroundColor = rgb(228, 77, 77);
            //        NSString *str = logoArray[_devCount][@"bindResultMsg"];
            //        if ([[[str componentsSeparatedByString:@":"] firstObject] isEqualToString:@"E001"]) {
            //            UIImageView *failImg = [[UIImageView alloc]initWithFrame:CGRectMake(devViewWidth - devViewWidth/3, 0, devViewWidth/3, devViewWidth/3)];
            //            failImg.image = [UIImage imageNamed:@"ic_configFail"];
            //            [devView addSubview:failImg];
            //        }
            
            //        devView.tag = 1020 + _failCount;
            //        devImage.tag = 1020 + _failCount;
            //        UITapGestureRecognizer *viewTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUser:)];
            //        [devView addGestureRecognizer:viewTgr];
            //        UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUser:)];
            //        [devImage addGestureRecognizer:imageTgr];
            //        devImage.userInteractionEnabled = YES;
            [self createNumLabel:logoArray isSuccess:NO];
            _failCount ++;
        }else{
            devView.backgroundColor = rgb(77, 228, 198);
            [self createNumLabel:logoArray isSuccess:YES];
        }
        
        //    NSLog(@"%@",logoArray);
        [_devScroll addSubview:devImage];
        [UIView animateWithDuration:0.5 animations:^{
            devView.alpha = 0.3;
            devImage.alpha = 1;
            devView.transform = CGAffineTransformTranslate(devView.transform, 0, -20);
        }];
        _devCount++;
    }else{
    //扫码

//        _devScroll.contentSize = CGSizeMake((logoArray.count * devWidth)+((logoArray.count+1)*gap), devWidth);
//        
//        if (logoArray.count > 4) {
//            [_devScroll setContentOffset:CGPointMake((logoArray.count - 4) * (gap + devWidth), 0) animated:YES];
//        }
//        
//        
//        _devPoint = CGPointMake((logoArray.count - 1) * (gap + devWidth), 0);
//        
//        UIView *devView = [[UIView alloc]initWithFrame:CGRectMake(_devPoint.x, 20, devViewWidth, devViewWidth)];
//        devView.alpha = 0;
//        devView.layer.cornerRadius = devWidth/2;
//        [_devScroll addSubview:devView];
//        UIImageView *devImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, devImageWidth, devImageWidth)];
//        devImage.center = CGPointMake(devView.center.x, devView.center.y-20);
//        devImage.alpha = 0;
//        //        devImage.backgroundColor = [UIColor orangeColor];
//        [devImage sd_setImageWithURL:[NSURL URLWithString:logoArray[_devCount][@"logo"]] completed:nil];
        if (logoArray[_devCount][@"message"]) {
            [_failDev addObject:logoArray[_devCount]];
            devView.backgroundColor = rgb(228, 77, 77);
//            UIImageView *failImg = [[UIImageView alloc]initWithFrame:CGRectMake(devViewWidth - devViewWidth/3, 0, devViewWidth/3, devViewWidth/3)];
//            failImg.image = [UIImage imageNamed:@"ic_configFail"];
//            [devView addSubview:failImg];
//            devView.tag = 1020 + _failCount;
//            devImage.tag = 1020 + _failCount;
//            UITapGestureRecognizer *viewTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUser:)];
//            [devView addGestureRecognizer:viewTgr];
//            UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUser:)];
//            [devImage addGestureRecognizer:imageTgr];
            devImage.userInteractionEnabled = YES;
            [self createNumLabel:logoArray isSuccess:NO];
            _failCount ++;
        }else{
            devView.backgroundColor = rgb(77, 228, 198);
            [self createNumLabel:logoArray isSuccess:YES];
        }
        
        //    NSLog(@"%@",logoArray);
        [_devScroll addSubview:devImage];
        [UIView animateWithDuration:0.5 animations:^{
            devView.alpha = 0.3;
            devImage.alpha = 1;
            devView.transform = CGAffineTransformTranslate(devView.transform, 0, -20);
        }];
        _devCount++;
        [self pauseAnimation];
        [self configSuccess];
    }

}

//- (void)showUser:(UITapGestureRecognizer *)tgr{
//    if (_toast != nil) {
//        return;
//    }
//    id info;
//    UIView *view = tgr.view;
//    info = _failDev[view.tag - 1020];
////    if ([view isKindOfClass:[UIImageView class]]) {
////        info = _failDev[view.superview.tag - 1020];
////    }else{
////        info = _failDev[view.tag - 1020];
////    }
//    NSString *str = [NSString stringWithFormat:@"%@ 已被用户 %@ 绑定",info[@"cidName"],info[@"message"]];
//    CGFloat height = [self sizeWithText:str maxSize:CGSizeMake(self.frame.size.width - 80, MAXFLOAT) font:[UIFont systemFontOfSize:14]].height;
//    _toast = [[Toast alloc]initWithFrame:CGRectMake(20, _mainView.frame.size.height - height - 60, self.frame.size.width - 40, height + 40) Str:str];
//    _toast.alpha = 0;
//    [_mainView addSubview:_toast];
//    [UIView animateWithDuration:0.3 animations:^{
//        _toast.alpha = 1;
//    } completion:^(BOOL finished) {
//        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dismissUser) userInfo:nil repeats:NO];
//    }];
//}

//- (void)dismissUser{
//    [UIView animateWithDuration:0.3 animations:^{
//        _toast.alpha = 0;
//    } completion:^(BOOL finished) {
//        [_toast removeFromSuperview];
//        _toast = nil;
//    }];
//}

// n个设备连接成功
- (void)createNumLabel:(NSMutableArray *)logoArray isSuccess:(BOOL)success{
    if (_finishButton == nil) {
        [self performSelector:@selector(creatButtons) withObject:nil afterDelay:0.3];
    }
    if (!success) {
        return;
    }
    NSString *string;
    if ([lang() isEqualToString:@"en-US"]) {
        string = [NSString stringWithFormat:@"%ld device to connect success",(unsigned long)logoArray.count - _failDev.count];
    }else{
       string = [NSString stringWithFormat:@"%ld个设备连接成功",(unsigned long)logoArray.count - _failDev.count];
    }
    CGSize size = [self sizeWithText:string maxSize:CGSizeMake(CGFLOAT_MAX, 20) font:[UIFont systemFontOfSize:18]];
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.alpha = 0;
        [_mainView addSubview:_numLabel];
        
//        [self performSelector:@selector(creatButtons) withObject:nil afterDelay:0.3];
        
        [UIView animateWithDuration:0.5 animations:^{
            _numLabel.alpha = 1;
            _numLabel.transform = CGAffineTransformTranslate(_numLabel.transform, 0, -20);
        }];
        
    }
    _numLabel.frame = CGRectMake(self.frame.size.width/2-size.width/2, CGRectGetMaxY(_devScroll.frame) + (60/1334.0)*ScreenHeight+20, size.width, 20);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
   
    if (logoArray.count - _failDev.count >= 10) {
        [str addAttribute:NSForegroundColorAttributeName value:rgb(77, 228, 198) range:NSMakeRange(0,2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2,str.length - 2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, str.length)];
    }else{
        [str addAttribute:NSForegroundColorAttributeName value:rgb(77, 228, 198) range:NSMakeRange(0,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1,str.length - 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, str.length)];
    }
    _numLabel.attributedText = str;
    
    if (_pointLabel == nil) {
        _pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLabel.frame)+5, CGRectGetMinY(_numLabel.frame), 70, 20)];
        _pointLabel.font = [UIFont systemFontOfSize:18];
        [_mainView addSubview:_pointLabel];
        _pointNumber = 0;
        [self setPoint];
    }
}

- (void)setPoint{
    if (self.isHave == YES) {
        switch (_pointNumber) {
            case 0:
                _pointLabel.text = @"";
                break;
            case 1:
                _pointLabel.text = @".";
                break;
            case 2:
                _pointLabel.text = @"..";
                break;
            case 3:
                _pointLabel.text = @"...";
                break;
                
            default:
                break;
        }
        
        _pointNumber++;
        if (_pointNumber > 3) {
            _pointNumber = 0;
        }
        
        [self performSelector:@selector(setPoint) withObject:nil afterDelay:0.5];
    }else{
        _pointLabel.text = @"";
    }
}

#pragma mark - “完成”按钮

- (void)creatButtons{
    CGFloat gap = (40/640.0)*self.frame.size.width;
    CGFloat height = Hrange(72);
    CGFloat width = self.frame.size.width-2*gap;
    CGFloat oriY = CGRectGetMaxY(_devScroll.frame) + (60/1334.0)*ScreenHeight+20;
    _finishButton = [UIButton buttonWithTitle:NSLocalizedString(@"完成", nil) frame:CGRectMake(gap, oriY+(90/1334.0)*ScreenHeight+30, width, height) target:self action:@selector(popRoot)];
//    _finishButton.frame = CGRectMake(gap, oriY+(90/1334.0)*ScreenHeight+30, width, height);
//    [_finishButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
//    [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _finishButton.backgroundColor = rgb(6, 164, 240);
    _finishButton.alpha = 0;
//    _finishButton.layer.cornerRadius = height/2;
//    [_finishButton addTarget:self action:@selector(popRoot) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_finishButton];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _finishButton.alpha = 1;
        _finishButton.transform = CGAffineTransformTranslate(_finishButton.transform, 0, -20);
    }];
}

- (void)popRoot{
    if (self.isBackground == YES && _failDev.count > 0 && _bugCount == 0){
        _bugCount ++;
        [self performSelector:@selector(popRoot) withObject:self afterDelay:1];
        return;
    }
    [self.delegata animationViewStop];
    _finishButton.userInteractionEnabled = NO;
    [self.delegata animationViewWillPop];
//    if (self.isHave == YES) {
//        self.isHave = NO;
        _pointLabel.text = @"";     
        [self cancelPreviousPer];
//        //圆环背景色变化
//        [UIView animateWithDuration:1 animations:^{
//            _ringBackGroundLayer.fillColor = [rgb(59, 193, 190) CGColor];
//        } completion:^(BOOL finished) {
//            
//        }];
//        //圆环动画停止
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            [self pauseAnimation];
//        } completion:^(BOOL finished) {
//            //对号动画开始
//            [self rightResumeAnimation];
//            [self performSelector:@selector(popAction) withObject:nil afterDelay:1.0];
//        }];
        [self successAnimate];
//        [self performSelector:@selector(popAction) withObject:nil afterDelay:1.2];
        CGFloat gap = (40/640.0)*self.frame.size.width;
        CGFloat height = Hrange(72);
        CGFloat width = self.frame.size.width-2*gap;
        CGFloat oriY = CGRectGetMaxY(_devScroll.frame) + (60/1334.0)*ScreenHeight+20;
        CGRect rect = CGRectMake(gap, oriY+(90/1334.0)*ScreenHeight+30, width, height);
        _popButton = [UIButton buttonWithTitle:NSLocalizedString(@"返回主页", nil) frame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) target:self action:@selector(popAction)];
//        _popButton.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
//        [_popButton setTitle:NSLocalizedString(@"返回主页", nil) forState:UIControlStateNormal];
//        [_popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _popButton.backgroundColor = rgb(6, 164, 240);
        _popButton.alpha = 0;
//        _popButton.layer.cornerRadius = rect.size.height/2;
//        [_popButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_popButton];
        if (_failDev.count > 0) {
            _failReasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _failReasonBtn.frame = CGRectMake(rect.origin.x, rect.origin.y+10+height, width, height);
            [_failReasonBtn setTitle:NSLocalizedString(@"查看未连接详情", nil) forState:UIControlStateNormal];
            [_failReasonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _failReasonBtn.backgroundColor = rgb(233, 119, 119);
            _failReasonBtn.alpha = 0;
            _failReasonBtn.layer.cornerRadius = _failReasonBtn.frame.size.height/2;
            [_failReasonBtn addTarget:self action:@selector(promptAction) forControlEvents:UIControlEventTouchUpInside];
            [_mainView addSubview:_failReasonBtn];
        }else{
            _solveLabel = [self createPromptLabel:CGRectMake(0, CGRectGetMaxY(_popButton.frame) + 20, self.frame.size.width, 20) withStr:@"还有疑问？点击这里" withFont:[UIFont systemFontOfSize:14]];
            [_mainView addSubview:_solveLabel];
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(promptAction)];
            [_solveLabel addGestureRecognizer:tgr];
        }
    
        
        [UIView animateWithDuration:0.3 animations:^{
            _finishButton.alpha = 0;
        } completion:^(BOOL finished) {
            [_finishButton removeFromSuperview];
            _finishButton = nil;
            [UIView animateWithDuration:0.3 animations:^{
                _popButton.alpha = 1;
                
                _popButton.transform = CGAffineTransformTranslate(_popButton.transform, 0, -20);
                if (_failDev.count <= 0) {
                    _solveLabel.alpha = 1;
                    _solveLabel.transform = CGAffineTransformTranslate(_solveLabel.transform, 0, -20);
                }else{
                    _failReasonBtn.alpha = 1;
                    _failReasonBtn.transform = CGAffineTransformTranslate(_failReasonBtn.transform, 0, -20);
                }
                
            } completion:^(BOOL finished) {
                
            }];
        }];
        
//    }else{
//        [self popAction];
//    }
}



#pragma mark - 代理方法

- (void)promptAction{
    if (_failDev.count > 0) {
        [self.delegata animationViewPrompt:_failDev];
    }else{
        [self.delegata animationViewsolve];
    }
}

//左上角“X”取消
- (void)cancelAction{
    _devCount = 0;
    _bugCount = 0;
    [_failDev removeAllObjects];
    [self.delegata animationViewCancel];
}


//常见解决方案
- (void)solveAction{
    [self.delegata animationViewsolve];
}


- (void)viewsRemoveFromSuperview{
    [_pointLabel removeFromSuperview];
    [_numLabel removeFromSuperview];
    _numLabel = nil;
    _pointLabel = nil;
}

- (void)cancelPreviousPer{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)popAction{
    [self.delegata animationViewPop];
}

#pragma mark - 动画开始&&暂停
// 停止动画
- (void)pauseAnimation
{
    // 取出当前的时间点，就是暂停的时间点
    //    CFTimeInterval pausetime = [_ringLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设定时间偏移量，让动画定格在那个时间点
    [_ringLayer setTimeOffset:1];
    
    // 将速度设为0
    [_ringLayer setSpeed:0.0f];
    
}

- (void)rightPauseAnimation
{
    // 取出当前的时间点，就是暂停的时间点
    //    CFTimeInterval pausetime = [_ringLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设定时间偏移量，让动画定格在那个时间点
    [_rightLayer setTimeOffset:1];
    
    // 将速度设为0
    [_rightLayer setSpeed:0.0f];
    
}

// 恢复动画
- (void)resumeAnimation
{
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

- (void)rightResumeAnimation
{
    // 获取暂停的时间
    CFTimeInterval pausetime = _ringLayer.timeOffset;
    
    // 计算出此次播放时间(从暂停到现在，相隔了多久时间)
    CFTimeInterval starttime = CACurrentMediaTime() - pausetime;
    
    // 将时间偏移量设为0(重新开始)；
    _rightLayer.timeOffset = 0.0;
    
    // 设置开始时间(beginTime是相对于父级对象的开始时间,系统会根据时间间隔帮我们算出什么时候开始动画)
    _rightLayer.beginTime = starttime;
    
    // 将速度恢复，设为1
    _rightLayer.speed = 1.0;
    
}

#pragma mark - 提示Label
- (UILabel *)createPromptLabel:(CGRect)rect withStr:(NSString *)str withFont:(UIFont *)font{
    UILabel *label = nil;
    label = [[UILabel alloc]initWithFrame:rect];
    label.text = NSLocalizedString(str,nil);
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = rgb(158, 158, 158);
    label.alpha = 0;
    label.userInteractionEnabled = YES;
    CGSize size = [self sizeWithText:NSLocalizedString(str,nil) maxSize:CGSizeMake(MAXFLOAT, rect.size.height) font:font];
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
    downLabel.center = CGPointMake(rect.size.width/2, CGRectGetHeight(rect)-0.5);
    if ([str isEqualToString:NSLocalizedString(@"设备连不上？点击这里",nil)]) {
        downLabel.backgroundColor = rgb(233, 119, 119);
    }else{
        downLabel.backgroundColor = getTitledTextColor();
    }
    
    [label addSubview:downLabel];
    return label;
}

#pragma mark - 字体工具

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
