//
//  ConfigCueView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/5/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ConfigCueView.h"
#import "EasyMacro.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define WIDTH                     [UIScreen mainScreen].bounds.size.width
//#define HEIGHT                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*WIDTH
//#define Vrange(x)  (x/1334.0)*HEIGHT

@implementation ConfigCueView

- (instancetype)initWithFrame:(CGRect)frame NetAction:(SEL)netAction Cancel:(SEL)cancel Next:(SEL)next Delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubviews:delegate NetAction:netAction Cancel:cancel Next:next];
    }
    return self;
}

-(void)layoutSubviews:(id)delegate NetAction:(SEL)netAction Cancel:(SEL)cancel Next:(SEL)next
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        self.backgroundColor = getViewBackgroundColor();
    }
    else{
        self.backgroundColor = [UIColor clearColor];
    }
    self.alpha = 0;
    UIBlurEffectStyle style = isNightTheme() ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        _visualEffectView.alpha = 0;
    [self addSubview:visualEffectView];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Hrange(700), Vrange(1000))];
    _bgView.center = CGPointMake(ScreenWidth/2, (ScreenHeight-StatusBarAndNavBarHeight)/2);
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.alpha = 0;
    [self addSubview:_bgView];
    
    UIButton *btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_cancel.frame = CGRectMake(Hrange(30), Hrange(30), 30, 30);
    [btn_cancel setImage:[UIImage imageNamed:@"iconfont-quxiao"] forState:UIControlStateNormal];
    [btn_cancel setImageEdgeInsets:UIEdgeInsetsMake((30-Hrange(32))/2, (30-Hrange(32))/2, (30-Hrange(32))/2, (30-Hrange(32))/2)];
    [btn_cancel addTarget:delegate action:cancel forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:btn_cancel];
    
    UIImageView *wifi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Hrange(560), Vrange(380))];
    wifi.center = CGPointMake(_bgView.frame.size.width/2, CGRectGetMinY(_bgView.frame)+wifi.frame.size.height/2);
    wifi.image = [UIImage imageNamed:@"icon-WIFI"];
    [_bgView addSubview:wifi];
    
    UILabel *uplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(wifi.frame)+Vrange(110), _bgView.frame.size.width, 20)];
    uplabel.text = NSLocalizedString(@"请确认您要添加的设备进入配置模式", nil);
    uplabel.textAlignment = NSTextAlignmentCenter;
    uplabel.numberOfLines = 0;
    uplabel.textColor = getDescriptiveTextColor();
    uplabel.font = [UIFont systemFontOfSize:15];
    
    CGSize size = [uplabel.text boundingRectWithSize:CGSizeMake(uplabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:uplabel.font} context:nil].size;

    uplabel.frame = CGRectMake(0, CGRectGetMaxY(wifi.frame)+Vrange(110), _bgView.frame.size.width, size.height);
    
    [_bgView addSubview:uplabel];
    
    UILabel *downlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(uplabel.frame)+10, _bgView.frame.size.width, 20)];
    downlabel.text = NSLocalizedString(@"如何进入配网模式？", nil);
    downlabel.textAlignment = NSTextAlignmentCenter;
    downlabel.textColor = rgb(244, 126, 39);
    downlabel.font = [UIFont systemFontOfSize:18];
    downlabel.userInteractionEnabled = YES;
    [downlabel setExclusiveTouch:YES];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:netAction];
    [downlabel addGestureRecognizer:tgr];
    [_bgView addSubview:downlabel];
    
    UIButton *nextButton = [UIButton buttonWithTitle:NSLocalizedString(@"下一步", nil) frame:CGRectMake(0, 0, sHrange(231), sVrange(40)) target:delegate action:next];
    nextButton.center = CGPointMake(downlabel.center.x, downlabel.center.y + Vrange(90));
//    nextButton.frame = CGRectMake((_bgView.frame.size.width-Hrange(560))/2, CGRectGetMaxY(downlabel.frame)+Vrange(90), Hrange(560), Vrange(80));
//    [nextButton setBackgroundColor:rgb(6, 164, 240)];
//    [nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
//    [nextButton setTitleColor:rgb(254, 254, 255) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
//    nextButton.layer.cornerRadius = nextButton.frame.size.height/2;
//    [nextButton setExclusiveTouch:YES];
//    [nextButton addTarget:delegate action:next forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:nextButton];
}

@end
