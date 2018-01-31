//
//  ConfigUnderView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/4.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigUnderView.h"
#import "CategoryControl.h"
#import "Tool.h"

@interface ConfigUnderView ()

@property (nonatomic ,weak) IBOutlet PressButton *firstButton;
@property (nonatomic ,weak) IBOutlet PressButton *secondButton;
@property (nonatomic ,weak) IBOutlet UIButton *thirdButton;
@property (nonatomic ,assign) BOOL isSuccess;

@end

@implementation ConfigUnderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIView *view = [[UINib nibWithNibName:@"ConfigUnderView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        view.frame = self.bounds;
        [self addSubview:view];
        
        [self drawConfigUnderView];
    }
    return self;
}

-(void)drawConfigUnderView{
    
    [_firstButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [_secondButton setTitle:NSLocalizedString(@"重新配网", nil) forState:UIControlStateNormal];

    
    [_thirdButton setBackgroundColor:[UIColor clearColor]];
    _thirdButton.layer.borderColor = UIColorFromHex(0x999999).CGColor;
    _thirdButton.layer.borderWidth = 1.0f;
    _thirdButton.layer.cornerRadius = 3.0f;
    [_thirdButton setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
    [_thirdButton setTitle:NSLocalizedString(@"兼容模式", nil) forState:UIControlStateNormal];
}

-(void)configUnderButtonReset{
    _isSuccess = NO;
}

-(void)configUnderButtonSuccess:(BOOL)success{
    
    if (_isSuccess) {
        return;
    }
    _isSuccess = success;
    [_firstButton setTitle:success?NSLocalizedString(@"完成", nil):NSLocalizedString(@"返回我的设备", nil) forState:UIControlStateNormal];
    
    _firstButton.hidden = NO;
    _secondButton.hidden = YES;
    _thirdButton.hidden = YES;
}

-(void)configUnderButtonFail{
    _firstButton.hidden = YES;
    _secondButton.hidden = NO;
    _thirdButton.hidden = NO;
}

-(IBAction)firstClick:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(configFinish)]) {
        [_delegate configFinish];
    }
}

-(IBAction)secondClick:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(configRestart)]) {
        [_delegate configRestart];
    }
}

-(IBAction)thirdClick:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(configSoftAP)]) {
        [_delegate configSoftAP];
    }
}

@end
