//
//  SafetyQuestionViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SafetyQuestionViewController.h"
#import "Tool.h"
#import "UserViewController.h"
#import "ResetPassWordForPhoneViewController.h"
#import "PhoneNumberViewController.h"
#import "GiFHUD.h"
#import <HekrAPI.h>
#import <SHAlertViewBlocks.h>

@interface SafetyQuestionViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL isOne;
@property (nonatomic, copy)NSString *myTitle;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, assign)SafetyQuestionViewType type;
@property (nonatomic, strong)UITextField *nameTextField;
@property (nonatomic, strong)UITextField *idCardTextField;
@property (nonatomic, strong)UILabel *birthdayLabel;
@property (nonatomic, strong)UIDatePicker *pickerView;
@property (nonatomic, strong)UIView *pickerBgView;
@property (nonatomic, strong)UIView *datePickerBgView;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, strong)UILabel *hintLabel;

@end

@implementation SafetyQuestionViewController

- (instancetype)initWithIsOne:(BOOL)isOne Num:(NSString *)num Title:(NSString *)title ViewType:(SafetyQuestionViewType)type{
    self = [super init];
    if (self) {
        _isOne = isOne;
        _myTitle = title;
        _type = type;
        _num = num;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
    [self initNavView];
}

- (void)initNavView
{
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, StatusBarAndNavBarHeight)];
    nav.backgroundColor = getNavBackgroundColor();
    [self.view addSubview:nav];
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    titLabel.center = CGPointMake(Width/2, 44);
    titLabel.backgroundColor = [UIColor clearColor];
    titLabel.textAlignment = NSTextAlignmentCenter;
    titLabel.text = NSLocalizedString(_myTitle, nil);
    titLabel.font = [UIFont systemFontOfSize:18];
    titLabel.textColor = getNavTitleColor();
    [nav addSubview:titLabel];
    if (_isOne == NO) {
        UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
        popButton.frame = CGRectMake(0, 20, 44, 44);
        [popButton setImage:[UIImage imageNamed:getNavPopBtnImg()] forState:UIControlStateNormal];
        [popButton addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
        [nav addSubview:popButton];
    }else{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(Width-Hrange(32)-100, 25, 100, 44);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0xa8a8a8) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [nav addSubview:button];
    }
    
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nav.frame)-0.5, Width, 0.5)];
    downLabel.backgroundColor = getCellLineColor();
    [nav addSubview:downLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, Vrange(14))];
    view.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:view];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)disMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)createView{
    
    _tableView = [UITableView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor orangeColor];//self.view.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    UILabel *upLabel = [UILabel new];
    upLabel.textColor = UIColorFromHex(0x06a4f0);
    upLabel.font = [UIFont systemFontOfSize:13];
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.backgroundColor = self.view.backgroundColor;
    upLabel.numberOfLines = 0;
    if (_type == setSafetyQuestion) {
        upLabel.text = NSLocalizedString(@"为了您的账户安全，请设置个人信息", nil);
    }else{
        upLabel.text = NSLocalizedString(@"为了您的账户安全，请先验证个人信息", nil);
    }
    [self.view addSubview:upLabel];
    NSString *str;
    if (_type == setSafetyQuestion) {
        str = NSLocalizedString(@"完成", nil);
    }else{
        str = NSLocalizedString(@"下一步", nil);
    }
    
    _hintLabel = [UILabel new];
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    _hintLabel.numberOfLines = 0;
    [self.view addSubview:_hintLabel];
    
    UIButton *finishBtn = [UIButton buttonWithTitle:str frame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT) target:self action:@selector(finishAction)];
    [self.view addSubview:finishBtn];
    
    WS(weakSelf);
    
    [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(64+Vrange(14));
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.width.mas_equalTo(Width - 20);
    }];
    [upLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upLabel.mas_bottom).offset(Vrange(46));
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(600)));
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width-Hrange(64), 36));
    }];
    
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(Vrange(104)+20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, BUTTONHEIGHT));
    }];
    
    if (_isOne == YES) {
        UILabel *onceLabel = [UILabel new];
        onceLabel.text = NSLocalizedString(@"如需修改，请在个人中心进行设置", nil);
        onceLabel.textColor = UIColorFromHex(0xa8a8a8);
        onceLabel.font = [UIFont systemFontOfSize:13];
        onceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:onceLabel];
        [onceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(finishBtn.mas_bottom).offset(Vrange(20));
            make.left.equalTo(weakSelf.view.mas_left).offset(10);
            make.width.mas_equalTo(Width - 20);
        }];
        [onceLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
}

- (void)finishAction{
    if ([_nameTextField isFirstResponder]) {
        [_nameTextField resignFirstResponder];
    }else if([_idCardTextField isFirstResponder]){
        [_idCardTextField resignFirstResponder];
    }
    
    if (_idCardTextField.text.length != 6 || _nameTextField.text.length <= 0) {
        _hintLabel.text = NSLocalizedString(@"请输入问题答案", nil);
        return;
    }
    _hintLabel.text = @"";
    NSString *str = [[_birthday componentsSeparatedByString:@" / "] componentsJoinedByString:@""];
    
    if (_type == setSafetyQuestion) {
        UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"", nil) withMessage:NSLocalizedString(@"密保问题答案一旦忘记则无法找回修改，请务必确认设置真实的信息",nil)];
        [alert SH_addButtonWithTitle:NSLocalizedString(@"确定",nil) withBlock:^(NSInteger theButtonIndex) {
            //设置问题
            [GiFHUD showWithOverlay];
            NSDictionary *dic = @{@"firstSecurityQues":_nameTextField.text,@"secondSecurityQues":str,@"thirdSecurityQues":_idCardTextField.text};
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa.openapi.hekr.me/setSecurityQuestion" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [GiFHUD dismiss];
                [self settingAction];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GiFHUD dismiss];
                if ([APIError(error) isEqualToString:@"0"]) {
                    [self.view.window makeToast:NSLocalizedString(@"设置失败", nil) duration:1.0 position:@"center"];
                }else{
                    [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                }
            }];
        }];
        [alert SH_addButtonWithTitle:NSLocalizedString(@"取消", nil) withBlock:nil];
        [alert show];
        
    }else{
        //验证
        [GiFHUD showWithOverlay];
        NSDictionary *dic = @{@"firstSecurityQues":_nameTextField.text,@"phoneNumber" : _num,@"secondSecurityQues":str,@"thirdSecurityQues":_idCardTextField.text,@"pid":[Hekr sharedInstance].pid};
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa.openapi.hekr.me/sms/checkSecurityQuestion" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            [self verifyAction:responseObject[@"token"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            if (APIErrorCode(error) == 3400018) {
                _hintLabel.text = NSLocalizedString(@"您输入的答案有误，请重新输入", nil);
                _nameTextField.text = @"";
                _idCardTextField.text = @"";
            }else{
                if ([APIError(error) isEqualToString:@"0"]) {
                    [self.view.window makeToast:NSLocalizedString(@"验证失败", nil) duration:1.0 position:@"center"];
                }else{
                    [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                }
            }
        }];
    }
}

- (void)settingAction{
    if (_isOne == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HekrSettingSafety" object:nil];
        for (UIViewController *controller  in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[UserViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

- (void)verifyAction:(NSString *)token{
    if (_type == resetSafetyQuestion) {
        SafetyQuestionViewController *view = [[SafetyQuestionViewController alloc]initWithIsOne:NO Num:nil Title:NSLocalizedString(@"密保问题", nil) ViewType:setSafetyQuestion];
        [self.navigationController pushViewController:view animated:YES];
    }else if (_type == changeBind){
        [self.navigationController pushViewController:[[PhoneNumberViewController alloc] initWithToken:token] animated:YES];
    }else if (_type == resetPassWord){
        ResetPassWordForPhoneViewController *view = [[ResetPassWordForPhoneViewController alloc]initWithToken:token Num:_num isSafety:YES];
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SafetyQuestionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SafetyQuestionCell"];
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }else{
        cell.backgroundColor = getCellBackgroundColor();
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            cell.backgroundColor = self.view.backgroundColor;
            UILabel *label = [self createQuestionLabel:NSLocalizedString(@"您的真实姓名", nil)];
            label.textColor = getTitledTextColor();
            [cell.contentView addSubview:label];
        }
            break;
        case 1:
        {
            _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(32), 0, Width-Hrange(64), Vrange(100))];
            _nameTextField.textColor = getInputTextColor();
            _nameTextField.font = [UIFont systemFontOfSize:16];
            _nameTextField.placeholder = NSLocalizedString(@"请输入", nil);
            [_nameTextField setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
            [cell.contentView addSubview:_nameTextField];
        }
            break;
        case 2:
        {
            cell.backgroundColor = self.view.backgroundColor;
            UILabel *label = [self createQuestionLabel:NSLocalizedString(@"您的出生年月", nil)];
            label.textColor = getTitledTextColor();
            [cell.contentView addSubview:label];
        }
            break;
        case 3:
        {
            _birthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hrange(32), 0, Width-Hrange(64), Vrange(100))];
            _birthdayLabel.textColor = getInputTextColor();
            _birthdayLabel.font = [UIFont systemFontOfSize:16];
            _birthdayLabel.text = @"1980 / 01 / 01";
            _birthday = @"1980 / 01 / 01";
            [cell.contentView addSubview:_birthdayLabel];
        }
            break;
        case 4:
        {
            cell.backgroundColor = self.view.backgroundColor;
            UILabel *label = [self createQuestionLabel:NSLocalizedString(@"您的身份证后6位", nil)];
            label.textColor = getTitledTextColor();
            [cell.contentView addSubview:label];
        }
            break;
        case 5:
        {
            _idCardTextField = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(32), 0, Width-Hrange(64), Vrange(100))];
            _idCardTextField.textColor = getInputTextColor();
            _idCardTextField.font = [UIFont systemFontOfSize:16];
            _idCardTextField.placeholder = NSLocalizedString(@"请输入", nil);
            [_idCardTextField setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
            _idCardTextField.delegate = self;
            [_idCardTextField addTarget:self action:@selector(TextDidChange:) forControlEvents:UIControlEventEditingChanged];
            //            _idCardTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentView addSubview:_idCardTextField];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_nameTextField isFirstResponder]) {
        [_nameTextField resignFirstResponder];
        return;
    }
    if ([_idCardTextField isFirstResponder]) {
        [_idCardTextField resignFirstResponder];
        return;
    }
    if (indexPath.row == 3) {
        _pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _pickerBgView.backgroundColor = [UIColor blackColor];
        _pickerBgView.alpha = 0;
        [self.view addSubview:_pickerBgView];
        
        _datePickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, Width, Vrange(450))];
        _datePickerBgView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:_datePickerBgView];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(Hrange(32), 0, 100, Vrange(80));
        cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancel setTitleColor:UIColorFromHex(0x727272) forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(birthdatViewMove) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerBgView addSubview:cancel];
        
        UIButton *ture = [UIButton buttonWithType:UIButtonTypeCustom];
        ture.frame = CGRectMake(Width - 100 - Hrange(32), 0, 100, Vrange(80));
        ture.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [ture setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [ture setTitleColor:UIColorFromHex(0x727272) forState:UIControlStateNormal];
        [ture addTarget:self action:@selector(saveBirthday) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerBgView addSubview:ture];
        
        
        _pickerView = [self createPickerView];
        [_pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [_datePickerBgView addSubview:_pickerView];
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(birthdatViewMove)];
        [_pickerBgView addGestureRecognizer:tgr];
        [UIView animateWithDuration:0.3 animations:^{
            _pickerBgView.alpha = 0.4;
            _datePickerBgView.transform = CGAffineTransformMakeTranslation(0, -Vrange(450));
        }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(100);
}

- (UILabel *)createQuestionLabel:(NSString *)title{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Hrange(32), 0, Width-Hrange(64), Vrange(100))];
    label.text = title;
    label.textColor = UIColorFromHex(0x727272);
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

- (UIDatePicker *)createPickerView{
    UIDatePicker *dataPiceker = [[UIDatePicker alloc]init];
    dataPiceker.frame = CGRectMake(0, Vrange(60), Width, Vrange(390));
    dataPiceker.datePickerMode = UIDatePickerModeDate;
    dataPiceker.minimumDate = [self dateFromString:@"1900 01 01"];
    dataPiceker.maximumDate = [self dateFromString:@"2016 01 01"];
    [dataPiceker setDate:[self dateFromString:[[_birthday componentsSeparatedByString:@"/ "] componentsJoinedByString:@""]] animated:NO];
    return dataPiceker;
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    _birthday = [self stringFromDate:control.date];
}

- (void)saveBirthday{
    if (_birthday) {
        _birthdayLabel.text = _birthday;
    }
    [self birthdatViewMove];
}

- (void)birthdatViewMove{
    [UIView animateWithDuration:0.3 animations:^{
        _pickerBgView.alpha = 0;
        _datePickerBgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _pickerBgView = nil;
        [_pickerBgView removeFromSuperview];
        _pickerView = nil;
        [_pickerView removeFromSuperview];
        _datePickerBgView = nil;
        [_datePickerBgView removeFromSuperview];
    }];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy MM dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy / MM / dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark --UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _idCardTextField) {
        if (ScreenHeight >= 667 && ScreenHeight < 736){
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.transform = CGAffineTransformMakeTranslation(0, -20);
            }];
        }else if (ScreenHeight >= 568 && ScreenHeight < 667){
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.transform = CGAffineTransformMakeTranslation(0, -Vrange(120));
            }];
        }else if (ScreenHeight >= 480 && ScreenHeight < 568){
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.transform = CGAffineTransformMakeTranslation(0, -Vrange(300));
            }];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _idCardTextField) {
        if (ScreenHeight >= 480 && ScreenHeight < 736) {
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (void)TextDidChange:(UITextField *)textfield
{
    NSString *toBeString = textfield.text;
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    //    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!selectedRange)
    {
        if (toBeString.length > 6)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:6];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:6];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 6)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
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
