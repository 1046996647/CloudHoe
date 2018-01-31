//
//  changeThemeViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/10/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "changeThemeViewController.h"
#import "Tool.h"
#import <HekrAPI.h>

@interface changeThemeViewController ()<ThemeViewDelegate>
@property (nonatomic, strong)HekrNavigationBarView *nav;
@property (nonatomic, strong)ThemeView *blueTheme;
@property (nonatomic, strong)ThemeView *creamTheme;
@property (nonatomic, strong)ThemeView *greenTheme;
@property (nonatomic, strong)ThemeView *nightTheme;
@property (nonatomic, strong)ThemeView *currentTheme;
@end

@implementation changeThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createView];
}

- (void)initNavView
{
    if (_nav) {
        return;
    }
    
    _nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"主题换肤" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:_nav];
    
}

- (void)createView{
//    CGFloat height = sVrange(215)+18+15;
    CGFloat height = sVrange(240);
    CGFloat width = sHrange(170);
    _blueTheme = [[ThemeView alloc]initWithFrame:CGRectMake(sHrange(10), StatusBarAndNavBarHeight+sVrange(20), width, height) withThemeImage:[UIImage imageNamed:@"theme_blue"] withThemeTitle:NSLocalizedString(@"蓝色山水", nil)];
    _blueTheme.delegate = self;
    [self.view addSubview:_blueTheme];
    
    _creamTheme = [[ThemeView alloc]initWithFrame:CGRectMake(sHrange(195), StatusBarAndNavBarHeight+sVrange(20), width, height) withThemeImage:[UIImage imageNamed:@"theme_cream"] withThemeTitle:NSLocalizedString(@"一米阳光", nil)];
    _creamTheme.delegate = self;
    [self.view addSubview:_creamTheme];
    
    _greenTheme = [[ThemeView alloc]initWithFrame:CGRectMake(sHrange(10), CGRectGetMaxY(_blueTheme.frame)+sVrange(20), width, height) withThemeImage:[UIImage imageNamed:@"theme_green"] withThemeTitle:NSLocalizedString(@"心在路上", nil)];
    _greenTheme.delegate = self;
    [self.view addSubview:_greenTheme];
    
    _nightTheme = [[ThemeView alloc]initWithFrame:CGRectMake(sHrange(195), CGRectGetMaxY(_blueTheme.frame)+sVrange(20), width, height) withThemeImage:[UIImage imageNamed:@"theme_night"] withThemeTitle:NSLocalizedString(@"纯净酷黑", nil)];
    _nightTheme.delegate = self;
    [self.view addSubview:_nightTheme];
    
    NSString *string = getThemeName();
    if ([string isEqualToString:@"Green"]) {
        [_greenTheme setSelected:getNavBackgroundColor()];
        _currentTheme = _greenTheme;
    }else if ([string isEqualToString:@"Cream"]){
        [_creamTheme setSelected:getNavBackgroundColor()];
        _currentTheme = _creamTheme;
    }else if ([string isEqualToString:@"Night"]){
        [_nightTheme setSelected:getNavBackgroundColor()];
        _currentTheme = _nightTheme;
    }else{
        [_blueTheme setSelected:getNavBackgroundColor()];
        _currentTheme = _blueTheme;
    }
    
}

- (void)changeTheme:(NSString *)themeName{
    ThemeView *newTheme;
    NSString *key = [NSString stringWithFormat:@"HekrTheme"];
    if ([themeName isEqualToString:NSLocalizedString(@"蓝色山水", nil)]) {
        newTheme = _blueTheme;
        [[NSUserDefaults standardUserDefaults] setObject:@"Blue" forKey:key];
    }else if ([themeName isEqualToString:NSLocalizedString(@"一米阳光", nil)]){
        newTheme = _creamTheme;
        [[NSUserDefaults standardUserDefaults] setObject:@"Cream" forKey:key];
    }else if ([themeName isEqualToString:NSLocalizedString(@"心在路上", nil)]){
        newTheme = _greenTheme;
        [[NSUserDefaults standardUserDefaults] setObject:@"Green" forKey:key];
    }else if ([themeName isEqualToString:NSLocalizedString(@"纯净酷黑", nil)]){
        newTheme = _nightTheme;
        [[NSUserDefaults standardUserDefaults] setObject:@"Night" forKey:key];
    }
    if (newTheme == _currentTheme)return;
    
    [_currentTheme deselect];
    
    _currentTheme = newTheme;
    
    [_currentTheme setSelected:getNavBackgroundColor()];
    
    [_nav refreshBackgroundColor];
    
    self.view.backgroundColor = getViewBackgroundColor();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHekrTheme" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@interface ThemeView ()
@property (nonatomic, strong)UIImage *themeImage;
@property (nonatomic, strong)NSString *themeTitle;
@property (nonatomic, strong)UIImageView *themeImageView;
@property (nonatomic, strong)UIButton *useButton;

@end

@implementation ThemeView
- (instancetype)initWithFrame:(CGRect)frame withThemeImage:(UIImage *)themeImage withThemeTitle:(NSString *)themeTitle{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.0f;
        self.layer.masksToBounds = YES;
        
        _themeImage = themeImage;
        _themeTitle = themeTitle;
        [self createViews];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(changeTheme) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:button];
    }
    return self;
}

- (void)createViews{
    
    _themeImageView = [[UIImageView alloc]initWithImage:_themeImage];
    _themeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_themeImageView];
    
    
    
    UILabel *bgLabel = [UILabel new];
    bgLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgLabel];
    
    UILabel *themeName = [UILabel new];
    themeName.font = getButtonTitleFont();
    themeName.textColor = getTitledTextColor();
    themeName.text = _themeTitle;
    themeName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:themeName];
    
    _useButton = [UIButton new];
    [_useButton setTitle:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"使用中", nil)] forState:UIControlStateNormal];
    [_useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_useButton setImage:[UIImage imageNamed:@"theme_use"] forState:UIControlStateNormal];
    _useButton.titleLabel.font = getDescTitleFont();
    _useButton.hidden = YES;
    [self addSubview:_useButton];
    
    WS(weakSelf);
    [_themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sHrange(170), sVrange(180)));
    }];
    [bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sHrange(170), sVrange(60)));
    }];
    [themeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgLabel.mas_centerY);
        make.centerX.equalTo(bgLabel.mas_centerX);
        make.size.mas_equalTo(bgLabel);
    }];
    [themeName setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.themeImageView.mas_centerX);
        make.centerY.equalTo(weakSelf.themeImageView.mas_centerY);
        make.width.mas_equalTo(weakSelf.themeImageView);
        make.height.mas_equalTo(20);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, sHrange(170), sVrange(180)) byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, sHrange(170), sVrange(180));
    maskLayer.path = maskPath.CGPath;
    _themeImageView.layer.mask = maskLayer;
}

- (void)changeTheme{
    [self.delegate changeTheme:_themeTitle];
}

- (void)setSelected:(UIColor *)color{
    _useButton.hidden = NO;
    
    self.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    self.layer.shadowOffset = CGSizeMake(4,4);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5;
}

- (void)deselect{
    _useButton.hidden = YES;
    
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
}

@end
