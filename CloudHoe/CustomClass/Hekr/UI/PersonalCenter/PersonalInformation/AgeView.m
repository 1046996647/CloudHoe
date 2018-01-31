//
//  AgeView.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/7.
//  Copyright © 2016年 Mike. All rights reserved.
//
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
//#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
#import "AgeView.h"
#import "UIButton+HeKrButton.h"
#import "EasyMacro.h"
#import "Tool.h"
#import "UIImageView+ThemeColor.h"

@interface AgeView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy)   NSString *age;
@property(nonatomic, strong)  NSMutableArray *priArr;

@end
@implementation AgeView

-(instancetype)initWithFrame:(CGRect)frame ageArray:(NSArray *)perArray labelString:(NSString *)labelString{
    self = [super initWithFrame:frame];
    if (self) {
        _priArr = (NSMutableArray *)perArray;
        //        UIPickerView *pickerView = [[UIPickerView alloc] init];
        _pickerView = [UIPickerView new];
        self.pickerView.frame = CGRectMake(0, 0, ScreenWidth, Vrange(370));
        self.pickerView.center = CGPointMake(ScreenWidth/2,Vrange(245));
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = NO;
        [self addSubview:_pickerView];
        [_pickerView selectRow:[labelString integerValue]-1 inComponent:0 animated:NO];
        _age = labelString;
        
        UIButton *ture = [UIButton buttonWithTitle:nil image:@"" titleColor:nil frame:CGRectMake(ScreenWidth-Hrange(100), 0, Hrange(100), Vrange(80)) target:self action:@selector(ageAction)];
        [self addSubview:ture];
        
        UIButton *cancel = [UIButton buttonWithTitle:nil image:@"" titleColor:nil frame:CGRectMake(0, 0, Hrange(100), Vrange(80)) target:self action:@selector(ageCancel)];
        [self addSubview:cancel];
        
        UIImageView *tureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Vrange(48), Vrange(48))];
        tureImageView.center = ture.center;
        [tureImageView setThemeImageNamed:@"ic_agecheck"];
        [self insertSubview:tureImageView belowSubview:ture];
        
        UIImageView *cancelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Vrange(48), Vrange(48))];
        cancelImageView.center = cancel.center;
        [cancelImageView setThemeImageNamed:@"ic_ageclose"];
        [self insertSubview:cancelImageView belowSubview:cancel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, Vrange(80))];
        label.center = CGPointMake(ScreenWidth/2, cancel.center.y);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"年龄",nil);
        label.font = getButtonTitleFont();
        label.textColor = getTitledTextColor();
        [self addSubview:label];
    }
    return self;
    
}

#pragma mark - UIPickerView  delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _priArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _priArr[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.text = _priArr[row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:25];
    label.textColor = getDescriptiveTextColor();
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.textColor = getButtonBackgroundColor();
    label.font = [UIFont systemFontOfSize:Vrange(70)];
    _age = label.text;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return Vrange(70);
}
- (void)ageAction{
    if (_age && [_delegate respondsToSelector:@selector(ageNum:)]) {
        [self.delegate ageNum:_age];
    }
    
}
- (void)ageCancel{
    
    if ([_delegate respondsToSelector:@selector(ageMove)]) {
        [self.delegate ageMove];
        
    }
    
}
@end
