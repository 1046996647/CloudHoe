//
//  UserViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/30.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserViewController.h"
#import <HekrAPI.h>
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <SHAlertViewBlocks.h>
#import <Masonry.h>
#import "UserDetailedViewController.h"
#import "SecurityViewController.h"
#import "Tool.h"
#import "UserInfoView.h"
#import "ChangePhoneViewController.h"
#import "ChangeEmailViewController.h"
#import "ChangePassViewController.h"
#import "SsoBindViewController.h"
#import "UpDataAccountViewController.h"
#import "SafetyQuestionViewController.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,UserInfoViewDelegate, UserDetailedViewDelegate, SsoBindViewDelegate>
@property (nonatomic, strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong)UserInfoView *userInfoView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *userIdView;
@property (nonatomic, strong)UIView *passWordView;
@property (nonatomic, strong)UIView *safeQuesView;
@property (nonatomic, strong)UIView *userBindView;
@property (nonatomic, strong)UILabel *userID;
@property (nonatomic, strong)UILabel *passWord;
@property (nonatomic, strong)UILabel *userSafe;
@property (nonatomic, strong)UIImageView *qqImg;
@property (nonatomic, strong)UIImageView *wxImg;
@property (nonatomic, strong)UIImageView *wbImg;
@property (nonatomic, strong)UIImageView *twImg;
@property (nonatomic, strong)UIImageView *ggImg;
@property (nonatomic, strong)UIImageView *fbImg;
@property (nonatomic, strong)UIImageView *safeHintImg;
@property (nonatomic, assign)BOOL isToast;
@property (nonatomic, assign)BOOL showSafety;
@property (nonatomic, assign)BOOL showSocial;

@property (nonatomic, strong)NSArray *showList;

@end

@implementation UserViewController

- (instancetype)initWithShowSafety:(BOOL)showSafety{
    self = [super init];
    if (self) {
        _showSafety = NO;
        NSDictionary *profile = [Tool getProfileJsonData];
        _showSocial = [[profile objectForKey:@"Social"] boolValue];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    _isToast = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhoneNum:) name:@"UpdataPhone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEmail:) name:@"UpdataEmail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSafetyStatus) name:@"HekrSettingSafety" object:nil];
    _dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrUserProfile"];

    _userInfoView = [[UserInfoView alloc] init];
    _userInfoView.delegate = self;
    
    [self createViews];
    [self getUserDataFormUrl];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"UserCenter"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UserCenter"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changePhoneNum:(NSNotification *)notification{
    [_dataDic setValue:notification.userInfo[@"phoneNum"] forKey:@"phoneNumber"];
    [self setUserSafetyInfos];
}

- (void)changeEmail:(NSNotification *)notification{
    [_dataDic setValue:notification.userInfo[@"Email"] forKey:@"email"];
    [self setUserSafetyInfos];
}

- (void)changeSafetyStatus{
    [_dataDic setValue:@NO forKey:@"isSecurity"];
    [self setUserSafetyInfos];
    [[NSUserDefaults standardUserDefaults] setObject:_dataDic forKey:@"kHekrUserProfile"];
}


- (void)createViews{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-Vrange(126)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *btn_back=[[UIButton alloc] initWithFrame:CGRectMake(0, StatusBarHeight, 60, 44)];
    [btn_back setImage:[UIImage imageNamed:@"ic_userBack"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_back];
    
    UIButton *outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outBtn.backgroundColor = getCellBackgroundColor();
    outBtn.titleLabel.font = getListTitleFont();
    [outBtn setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
    [outBtn setTitleColor:UIColorFromHex(0xfc4049) forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];
    
    WS(weakSelf);
    [outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(Vrange(126));
    }];
}

- (void)outClick{
    
    [self showAlertNoMsgWithTitle:@"确定退出登录吗？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"clearData" object:nil]];
        [[Hekr sharedInstance] logout];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HekrSDKUserChangeNotification object:nil];
        }
    }];
    
}

- (void)getUserDataFormUrl{
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager GET:@"http://user.openapi.hekr.me/user/profile" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        _dataDic = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"kHekrUserProfile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self refreshUserPage];
        
        

        DDLogVerbose(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrUserProfile"];
        [self refreshUserPage];
        [self.view.window makeToast:NSLocalizedString(@"信息拉取失败", nil) duration:1.0 position:@"center"];
    }];
}

- (void)refreshUserPage{
    [_userInfoView setUserInfos:_dataDic];
    [self setUserSafetyInfos];
}

- (void)setUserSafetyInfos{
    NSString *phoneNumber;
    NSString *email;
    if (_dataDic[@"phoneNumber"] && ![_dataDic[@"phoneNumber"] isKindOfClass:[NSNull class]]) {
        phoneNumber = _dataDic[@"phoneNumber"];
    }
    if (_dataDic[@"email"] && ![_dataDic[@"email"] isKindOfClass:[NSNull class]]){
        email = _dataDic[@"email"];
    }
    
    if (phoneNumber && phoneNumber.length > 0) {
        _userID.text = phoneNumber;
        _userID.textColor = getDescriptiveTextColor();
        _passWord.text = NSLocalizedString(@"已设置", nil);
        _passWord.textColor = getDescriptiveTextColor();
    }else if(email && email.length > 0){
        _userID.text = email;
        _userID.textColor = getDescriptiveTextColor();
        _passWord.text = NSLocalizedString(@"已设置", nil);
        _passWord.textColor = getDescriptiveTextColor();
    }else{
        _userID.text = NSLocalizedString(@"未设置", nil);
        _userID.textColor = getButtonBackgroundColor();
        _passWord.text = NSLocalizedString(@"未设置", nil);
        _passWord.textColor = getButtonBackgroundColor();
    }
    
    if (_showSafety == YES) {
        if ([_dataDic[@"isSecurity"] boolValue]) {
            _userSafe.text = NSLocalizedString(@"已保护", nil);
            _userSafe.textColor = getDescriptiveTextColor();
            _safeHintImg.hidden = YES;
        }else{
            _userSafe.text = NSLocalizedString(@"未保护", nil);
            _userSafe.textColor = getButtonBackgroundColor();
            _safeHintImg.hidden = NO;
        }
    }
    
    [self setSSOImg];
}

- (void)setSSOImg{
    _qqImg.image = [UIImage imageNamed:@"ic_user_qqN"];
    _wxImg.image = [UIImage imageNamed:@"ic_user_wxN"];
    _wbImg.image = [UIImage imageNamed:@"ic_user_sinaN"];
    _twImg.image = [UIImage imageNamed:@"ic_user_twN"];
    _ggImg.image = [UIImage imageNamed:@"ic_user_gN"];
    _fbImg.image = [UIImage imageNamed:@"ic_user_fbN"];
    for (NSString *str in _dataDic[@"thirdAccount"]) {
        if ([str isEqualToString:@"QQ"]) {
            _qqImg.image = [UIImage imageNamed:@"ic_user_qqS"];
        }else if ([str isEqualToString:@"WECHAT"]) {
            _wxImg.image = [UIImage imageNamed:@"ic_user_wxS"];
        }else if ([str isEqualToString:@"SINA"]) {
            _wbImg.image = [UIImage imageNamed:@"ic_user_sinaS"];
        }else if ([str isEqualToString:@"TWITTER"]) {
            _twImg.image = [UIImage imageNamed:@"ic_user_twS"];
        }else if ([str isEqualToString:@"GOOGLE"]) {
            _ggImg.image = [UIImage imageNamed:@"ic_user_gS"];
        }else if ([str isEqualToString:@"FACEBOOK"]) {
            _fbImg.image = [UIImage imageNamed:@"ic_user_fbS"];
        }
    }
}

#pragma mark --TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _showSocial?4:3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_showSocial == YES) {
        if (section == 3 || section == 0) {
            return 0;
        }else{
            return 1;
        }
    }else{
        if (section == 2 || section == 0) {
            return 0;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userViewCell"];
    }
    cell.backgroundColor = self.view.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger count = section;
    
    if (count == 0) {
        [self refreshUserPage];
        return _userInfoView;
    }else if (count == 1){
        _userIdView = [self createUserIdView];
        return _userIdView;
    }else if (count == 2){
        _passWordView = [self createPassWordView];
        return _passWordView;
    }else if (count == 3) {
        _userBindView = [self createUserBindView];
        return _userBindView;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _userInfoView.height;
    }else{
        return Vrange(134);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (UIView *)createUserIdView{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Vrange(134))];
    view.backgroundColor = getCellBackgroundColor();
    
    UIImageView *arrowhead = [UIImageView new];
    arrowhead.image = [UIImage imageNamed:@"ic_user_arrowhead"];
    [view addSubview:arrowhead];
    
    UIImageView *userImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_user"]];
    [view addSubview:userImg];
    
    UILabel *userLabel = [UILabel new];
    userLabel.font = getDescTitleFont();
    userLabel.textColor = getTitledTextColor();
    userLabel.text = NSLocalizedString(@"手机/邮箱", nil);
    [view addSubview:userLabel];
    
    _userID = [UILabel new];
    _userID.font = getDescTitleFont();
    _userID.textColor = getDescriptiveTextColor();
    [view addSubview:_userID];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changeUserID) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(14), Vrange(24)));
    }];
    
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(38), Vrange(40)));
    }];
    
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImg.mas_right).offset(Hrange(24));
        make.centerY.equalTo(userImg.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [userLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_userID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(70));
        make.centerY.equalTo(userLabel.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [_userID setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left);
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
    }];
    
    return view;
}

- (UIView *)createPassWordView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Vrange(134))];
    view.backgroundColor = getCellBackgroundColor();
    
    UIImageView *arrowhead = [UIImageView new];
    arrowhead.image = [UIImage imageNamed:@"ic_user_arrowhead"];
    [view addSubview:arrowhead];
    
    UIImageView *passWordImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_password"]];
    [view addSubview:passWordImg];
    
    UILabel *passWordLabel = [UILabel new];
    passWordLabel.font = getListTitleFont();
    passWordLabel.textColor = getTitledTextColor();
    passWordLabel.text = NSLocalizedString(@"密码状态", nil);
    [view addSubview:passWordLabel];
    
    _passWord = [UILabel new];
    _passWord.font = getDescTitleFont();
    _passWord.textColor = getDescriptiveTextColor();
    [view addSubview:_passWord];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(14), Vrange(24)));
    }];
    
    [passWordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(38), Vrange(48)));
    }];
    
    [passWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passWordImg.mas_right).offset(Hrange(24));
        make.centerY.equalTo(passWordImg.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [passWordLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(70));
        make.centerY.equalTo(passWordLabel.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [_passWord setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left);
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
    }];
    
    return view;
}

- (UIView *)createSafeQuesView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Vrange(134))];
    view.backgroundColor = getCellBackgroundColor();
    
    UIImageView *arrowhead = [UIImageView new];
    arrowhead.image = [UIImage imageNamed:@"ic_user_arrowhead"];
    [view addSubview:arrowhead];
    
    UIImageView *safetyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_safe"]];
    [view addSubview:safetyImg];
    
    UILabel *safetyLabel = [UILabel new];
    safetyLabel.font = [UIFont systemFontOfSize:15];
    safetyLabel.textColor = getTitledTextColor();
    safetyLabel.text = NSLocalizedString(@"密保问题", nil);
    [view addSubview:safetyLabel];
    
    _userSafe = [UILabel new];
    _userSafe.font = [UIFont systemFontOfSize:15];
    _userSafe.textColor = UIColorFromHex(0x383838);
    [view addSubview:_userSafe];
    
    _safeHintImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_hint"]];
    [view addSubview:_safeHintImg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changeSafety) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(14), Vrange(24)));
    }];

    [safetyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(38), Vrange(44)));
    }];
    
    [safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(safetyImg.mas_right).offset(Hrange(24));
        make.centerY.equalTo(safetyImg.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [safetyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_userSafe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(70));
        make.centerY.equalTo(safetyLabel.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [_userSafe setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_safeHintImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userSafe.mas_centerY);
        make.right.equalTo(_userSafe.mas_left).offset(-Hrange(24));
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left);
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
    }];
    
    return view;
}

- (UIView *)createUserBindView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Vrange(134))];
    view.backgroundColor = getCellBackgroundColor();
    
    UIImageView *arrowhead = [UIImageView new];
    arrowhead.image = [UIImage imageNamed:@"ic_user_arrowhead"];
    [view addSubview:arrowhead];
    
    UIImageView *bindImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_bind"]];
    [view addSubview:bindImg];
    
    UILabel *bindLabel = [UILabel new];
    bindLabel.font = [UIFont systemFontOfSize:15];
    bindLabel.textColor = getTitledTextColor();
    bindLabel.text = NSLocalizedString(@"绑定管理", nil);
    [view addSubview:bindLabel];
    
    _qqImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_qqN"]];
    _qqImg.contentMode = UIViewContentModeScaleAspectFit;

    _wxImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_wxN"]];
    _wxImg.contentMode = UIViewContentModeScaleAspectFit;

    _wbImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_sinaN"]];
    _wbImg.contentMode = UIViewContentModeScaleAspectFit;

    _twImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_twN"]];
    _twImg.contentMode = UIViewContentModeScaleAspectFit;

    _ggImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_gN"]];
    _ggImg.contentMode = UIViewContentModeScaleAspectFit;

    _fbImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user_fbN"]];
    _fbImg.contentMode = UIViewContentModeScaleAspectFit;

    NSMutableArray *arrViews = @[].mutableCopy;
    NSDictionary *socialData = [Tool getProfileJsonData];

    if (isEN()) {
        if ([[socialData objectForKey:KeyOfSocialTwitter] boolValue]) {
            [arrViews addObject:_twImg];
            [view addSubview:_twImg];
        }
        if ([[socialData objectForKey:KeyOfSocialGoogle] boolValue]) {
            [arrViews addObject:_ggImg];
            [view addSubview:_ggImg];
        }
        if ([[socialData objectForKey:KeyOfSocialFacebook] boolValue]) {
            [arrViews addObject:_fbImg];
            [view addSubview:_fbImg];
        }
    }else{
        if ([[socialData objectForKey:KeyOfSocialQQ] boolValue]) {
            [arrViews addObject:_qqImg];
            [view addSubview:_qqImg];
        }
        if ([[socialData objectForKey:KeyOfSocialWeibo] boolValue]) {
            [arrViews addObject:_wxImg];
            [view addSubview:_wxImg];
        }
        if ([[socialData objectForKey:KeyOfSocialWeixin] boolValue]) {
            [arrViews addObject:_wbImg];
            [view addSubview:_wbImg];
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changeBind) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(14), Vrange(24)));
    }];
    
    [bindImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(Hrange(32));
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(38), Vrange(40)));
    }];
    
    [bindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bindImg.mas_right).offset(Hrange(24));
        make.centerY.equalTo(bindImg.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    [bindLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    UIImageView *lastImg = nil;
    for (UIImageView *img in arrViews) {
        if (lastImg) {
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view.mas_centerY);
                make.right.equalTo(lastImg.mas_left).offset(-Hrange(20));
                make.size.mas_equalTo(CGSizeMake(Vrange(36), Vrange(36)));
            }];
        }else{
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_right).offset(-Hrange(70));
                make.centerY.equalTo(view.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(Vrange(36), Vrange(36)));
            }];
        }
        lastImg = img;
    }
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left);
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
    }];
    
    return view;
}


#pragma mark --UserInfoViewDelegate
- (void)changeUserInfos{
    UserDetailedViewController *userDetailedView = [[UserDetailedViewController alloc] initWithData:_dataDic];
    userDetailedView.delegate = self;
    [self.navigationController pushViewController:userDetailedView animated:YES];
}

#pragma mark --UserDetailedViewDelegate
- (void)saveUserInfo:(NSMutableDictionary *)info{
    _dataDic = info;
    [[NSUserDefaults standardUserDefaults] setObject:_dataDic forKey:@"kHekrUserProfile"];
    [_userInfoView setUserInfos:_dataDic];
}

#pragma mark --UserSafetyViewDelegate
- (void)changeUserID{
    NSString *phoneNumber;
    NSString *email;
    if (_dataDic[@"phoneNumber"] && ![_dataDic[@"phoneNumber"] isKindOfClass:[NSNull class]]) {
        phoneNumber = _dataDic[@"phoneNumber"];
    }
    if (_dataDic[@"email"] && ![_dataDic[@"email"] isKindOfClass:[NSNull class]]){
        email = _dataDic[@"email"];
    }
    
    if (phoneNumber && phoneNumber.length > 0) {
        [self.navigationController pushViewController:[ChangePhoneViewController new] animated:YES];
    }else if(email && email.length > 0){
        [self.navigationController pushViewController:[ChangeEmailViewController new] animated:YES];
    }else{
        //第三方升级主账号
        [self.navigationController pushViewController:[UpDataAccountViewController new] animated:YES];
    }
}

- (void)changePassWord{
    NSString *phoneNumber;
    NSString *email;
    if (_dataDic[@"phoneNumber"] && ![_dataDic[@"phoneNumber"] isKindOfClass:[NSNull class]]) {
        phoneNumber = _dataDic[@"phoneNumber"];
    }
    if (_dataDic[@"email"] && ![_dataDic[@"email"] isKindOfClass:[NSNull class]]){
        email = _dataDic[@"email"];
    }
    if ((phoneNumber && phoneNumber.length > 0)||(email && email.length > 0)) {
        [self.navigationController pushViewController:[ChangePassViewController new] animated:YES];
    }else{
        //第三方升级主账号
        if (_isToast == YES) {
            _isToast = NO;
            [self performSelector:@selector(toastDismiss) withObject:nil afterDelay:1.3];
            [self.view.window makeToast:NSLocalizedString(@"请先绑定手机号或邮箱", nil) duration:1.0 position:@"center"];
        }
        
    }
}

- (void)toastDismiss{
    _isToast = YES;
}

- (void)changeSafety{
//    [self.view.window makeToast:NSLocalizedString(@"正在开发中...", nil) duration:1.0 position:@"center"];
    if ([_dataDic[@"isSecurity"] boolValue]) {
        
        SafetyQuestionViewController *safetyView = [[SafetyQuestionViewController alloc]initWithIsOne:NO Num:_dataDic[@"phoneNumber"] Title:NSLocalizedString(@"密保问题", nil) ViewType:resetSafetyQuestion];
        [self.navigationController pushViewController:safetyView animated:YES];
    }else{
        SafetyQuestionViewController *safetyView = [[SafetyQuestionViewController alloc]initWithIsOne:NO Num:nil Title:NSLocalizedString(@"密保问题", nil) ViewType:setSafetyQuestion];
        [self.navigationController pushViewController:safetyView animated:YES];
    }
    
}

- (void)changeBind{
    SsoBindViewController *bindView = [[SsoBindViewController alloc]initWithInfo:_dataDic];
    bindView.deletage = self;
    [self.navigationController pushViewController:bindView animated:YES];
//    [self.view.window makeToast:NSLocalizedString(@"正在开发中...", nil) duration:1.0 position:@"center"];
}

- (void)refurbishSsoImg:(NSMutableDictionary *)dicData{
    _dataDic = dicData;
    [self setSSOImg];
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
