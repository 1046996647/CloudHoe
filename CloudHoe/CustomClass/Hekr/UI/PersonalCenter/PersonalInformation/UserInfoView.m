//
//  UserInfoView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserInfoView.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+ThemeColor.h"

@interface UserInfoView ()
@property (nonatomic, strong)UIImageView *userLogo;
@property (nonatomic, strong)UILabel *userName;
@property (nonatomic, strong)UIImageView *sexImg;
@property (nonatomic, strong)UILabel *userAge;
@property (nonatomic, strong)UILabel *cityName;
@property (nonatomic, strong)UIView *downView;
@end

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self createViews];
//    }
//    return self;
//}

- (void)createViews{
    UIImageView *topImg = [UIImageView new];
    topImg.image = [UIImage imageNamed:getUserTopBgImg()];
    topImg.userInteractionEnabled = YES;
    [self addSubview:topImg];
    
    UIImageView *userLogoBg = [UIImageView new];
    userLogoBg.userInteractionEnabled = YES;
    userLogoBg.image = [UIImage imageNamed:@"ic_user_bg"];
    [self addSubview:userLogoBg];
    
    _userLogo = [UIImageView new];
    _userLogo.userInteractionEnabled = YES;
    _userLogo.layer.cornerRadius = Vrange(158)/2;
    _userLogo.layer.masksToBounds = YES;
    _userLogo.layer.borderWidth = 1;
    _userLogo.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self addSubview:_userLogo];
    
    _userName = [UILabel new];
    _userName.font = [UIFont boldSystemFontOfSize:16];
    _userName.textColor = [UIColor whiteColor];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    _userName.layer.shadowOffset = CGSizeMake(1,1.5);
    _userName.layer.shadowOpacity = 0.2;
    _userName.layer.shadowRadius = 1.0;
    [self addSubview:_userName];
    
    _sexImg = [UIImageView new];
    _sexImg.userInteractionEnabled = YES;
    [self addSubview:_sexImg];
    
    _downView = [UIView new];
    [self addSubview:_downView];
    
    UIImageView *ageImg = [UIImageView new];
    ageImg.image = [UIImage imageNamed:@"ic_user_age"];
    [_downView addSubview:ageImg];
    
    _userAge = [UILabel new];
    _userAge.font = [UIFont systemFontOfSize:14];
    _userAge.textColor = [UIColor whiteColor];
    _userAge.textAlignment = NSTextAlignmentCenter;
    _userAge.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    _userAge.layer.shadowOffset = CGSizeMake(1,1.5);
    _userAge.layer.shadowOpacity = 0.2;
    _userAge.layer.shadowRadius = 1.0;
    [_downView addSubview:_userAge];
    
    UIImageView *cityImg = [UIImageView new];
    cityImg.image = [UIImage imageNamed:@"ic_user_city"];
    [_downView addSubview:cityImg];
    
    _cityName = [UILabel new];
    _cityName.font = [UIFont systemFontOfSize:14];
    _cityName.textColor = [UIColor whiteColor];
    _cityName.textAlignment = NSTextAlignmentCenter;
    _cityName.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    _cityName.layer.shadowOffset = CGSizeMake(1,1.5);
    _cityName.layer.shadowOpacity = 0.2;
    _cityName.layer.shadowRadius = 1.0;
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"WEATHER_CITY"];
    city.length > 0 ? (_cityName.text = city) : (_cityName.text = NSLocalizedString(@"北京", nil));
    [_downView addSubview:_cityName];
    
    UIButton *change = [UIButton buttonWithType:UIButtonTypeCustom];
    [change addTarget:self action:@selector(changeUser) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:change];
    
    WS(weakSelf);
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [userLogoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).offset(StatusBarAndNavBarHeight);
        make.size.mas_equalTo(CGSizeMake(Hrange(332), Vrange(194)));
    }];
    
    [_userLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userLogoBg.mas_centerX);
        make.centerY.equalTo(userLogoBg.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Vrange(158), Vrange(158)));
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLogoBg.mas_bottom).offset(Vrange(35));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(18);
    }];
    [_userName setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userName.mas_right).offset(Hrange(10));
        make.centerY.equalTo(_userName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [ageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [_userAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(ageImg.mas_right).offset(Hrange(12));
        make.height.mas_equalTo(16);
    }];
    [_userAge setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [cityImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ageImg.mas_top);
        make.left.equalTo(_userAge.mas_right).offset(Hrange(66));
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(ageImg.mas_height);
    }];
    
    [_cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userAge.mas_top);
        make.left.equalTo(cityImg.mas_right).offset(Hrange(12));
        make.height.equalTo(_userAge.mas_height);
    }];
    [_cityName setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_cityName.mas_right);
        make.height.mas_equalTo(16);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(_userName.mas_bottom).offset(Vrange(33));
    }];
    
    [change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLogoBg.mas_top);
        make.left.equalTo(_downView.mas_left);
        make.bottom.equalTo(_downView.mas_bottom);
        make.right.equalTo(_downView.mas_right);
    }];

    _height = Vrange(262)+44+StatusBarAndNavBarHeight;
    self.frame = CGRectMake(0, 0, ScreenWidth, _height);
}

- (void)changeUser{
    [self.delegate changeUserInfos];
}

- (void)setUserInfos:(NSMutableDictionary *)info{
    if (info[@"avatarUrl"] && ![info[@"avatarUrl"] isKindOfClass:[NSNull class]]) {
        
        NSString *smallimage = info[@"avatarUrl"][@"small"];
        
        [_userLogo sd_setImageWithURL:[NSURL URLWithString:smallimage] placeholderImage:[UIImage imageNamed:@"icon_user_default"]];
    }else{
        _userLogo.image = [UIImage imageNamed:@"icon_user_default"];
        
    }
    
    if (info[@"lastName"] && ![info[@"lastName"] isKindOfClass:[NSNull class]]) {
        _userName.text = info[@"lastName"];
    }else{
        _userName.text = NSLocalizedString(@"游客", nil);
    }
    if (info[@"age"] && ![info[@"age"] isKindOfClass:[NSNull class]]) {
        NSString *str = [NSString stringWithFormat:@"%@",info[@"age"]];
        _userAge.text = isEN() ? str : [NSString stringWithFormat:@"%@岁",str];
    }else{
        _userAge.text = isEN() ? @"21" : @"21岁";
    }
    if (info[@"gender"] && ![info[@"gender"] isKindOfClass:[NSNull class]]) {
        if ([info[@"gender"] isEqualToString:@"MAN"]) {
            _sexImg.image = [UIImage imageNamed:@"ic_user_man"];
//            [_sexImg setThemeImageNamed:@"ic_user_man"];
        }else if([info[@"gender"] isEqualToString:@"WOMAN"]){
            _sexImg.image = [UIImage imageNamed:@"ic_user_woman"];
//            [_sexImg setThemeImageNamed:@"ic_user_woman"];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
