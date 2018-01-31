//
//  LoadingAniView.m
//  loadingAni
//
//  Created by Info on 16/2/29.
//  Copyright © 2016年 skogt. All rights reserved.
//

#import "LoadingAniView.h"
#import "UIColor+YYAdd.h"


@interface LoadingAniView()

@property (nonatomic,strong) UIImageView *innerImageView;
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,assign) NSInteger posIndex;
@property (nonatomic,strong) NSTimer *timer;

@end

typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转
    
} AnimationType;

@implementation LoadingAniView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRGB:0x56B5E5];
        self.layer.cornerRadius = 10.f;
        
        _imgArr = @[@"iconfont-caozuobingxiang",@"iconfont-hekriconshebeidianshan",@"iconfont-hekriconshebeizhazhijidoujiangji",@"iconfont-shebeikongqijinghuaqi"];
        
        _innerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 60, 60)];
        _innerImageView.image = [UIImage imageNamed:_imgArr[0]];
        [self addSubview:_innerImageView];
        
        _posIndex = 0;
        
        self.tintColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)startLoadingAni
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.7f
                                                  target:self
                                                selector:@selector(oglFlip)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    [self performSelector:@selector(startAni)
               withObject:nil
               afterDelay:0.1f];

}
- (void)stopLoadingAni
{
    [_timer invalidate];
    _timer = nil;
    
    [self.innerImageView.layer removeAnimationForKey:@"animation"];
    [self removeFromSuperview];
}

- (void)startAni
{
    [_timer fire];
}

- (void)oglFlip
{
    [self transitionWithType:@"oglFlip" WithSubtype:kCATransitionFromLeft ForView:self.innerImageView];
    _posIndex = (_posIndex + 1) % _imgArr.count;
    self.innerImageView.image = [UIImage imageNamed:_imgArr[_posIndex]];    
}

- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.4f;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
    
}

@end
