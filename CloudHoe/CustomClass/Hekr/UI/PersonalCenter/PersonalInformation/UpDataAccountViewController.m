//
//  UpDataAccountViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UpDataAccountViewController.h"
#import "Tool.h"
#import "GiFHUD.h"
#import "UpdataEmailViewController.h"
#import "UpdataPhoneViewController.h"
#import <Masonry.h>
#import <HekrAPI.h>

@interface UpDataAccountViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *accountTextField;
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UILabel *hintLabel;
@end

@implementation UpDataAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createView];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"绑定账号" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView{
    UIView *accountView = [UIView new];
    accountView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:accountView];
    
    UIView *passWordView = [UIView new];
    passWordView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:passWordView];
    
    _accountTextField = [UITextField new];
    _accountTextField.textColor = getInputTextColor();
    _accountTextField.placeholder = NSLocalizedString(@"手机/邮箱", ni);
    [_accountTextField setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    _accountTextField.delegate = self;
    [self.view addSubview:_accountTextField];
    
    _passWordTextField = [UITextField new];
    _passWordTextField.textColor = getInputTextColor();
    _passWordTextField.placeholder = NSLocalizedString(@"密码", ni);
    [_passWordTextField setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    [_passWordTextField setSecureTextEntry:YES];
    [self.view addSubview:_passWordTextField];
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    _hintLabel = [UILabel new];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    [self.view addSubview:_hintLabel];
    
    UIButton *next = [UIButton buttonWithTitle:NSLocalizedString(@"确定", ni) frame:CGRectMake(0, 0, sHrange(320), sVrange(40)) target:self action:@selector(nextAction)];
    [self.view addSubview:next];
    
    WS(weakSelf);
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(64+Vrange(32));
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom).offset(1);
        make.left.equalTo(accountView.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_top);
        make.left.equalTo(accountView.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width - Hrange(64), Vrange(100)));
    }];
    
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordView.mas_top);
        make.left.equalTo(passWordView.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width/2, Vrange(100)));
    }];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordTextField.mas_top);
        make.right.equalTo(passWordView.mas_right);
        make.size.mas_equalTo(CGSizeMake(Vrange(100), Vrange(100)));
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordView.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width - Hrange(64), 36));
    }];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passWordView.mas_bottom).offset(Vrange(104));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sHrange(320), sVrange(40)));
    }];
}


- (void)showPassWord:(UIButton *)btn{
    if (_passWordTextField.secureTextEntry == YES) {
        _passWordTextField.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"ic_eyeopen"] forState:UIControlStateNormal];
    }else{
        _passWordTextField.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    }
}




- (void)nextAction{
    [self resignFirst];
    if (!validateEmail(_accountTextField.text) && !validateMobile(_accountTextField.text)) {
        _hintLabel.text = NSLocalizedString(@"请输入正确的手机号码或邮箱账号",nil);
        return;
    }
    if (!validatePassWord(_passWordTextField.text)) {
        NSString *str = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成",nil);
        _hintLabel.text = str;
        return;
    }
    _hintLabel.text = @"";
    
    if (validateEmail(_accountTextField.text)) {
        [GiFHUD showWithOverlay];
        NSDictionary *dict = @{@"uid":[Hekr sharedInstance].user.uid,
                               @"email":_accountTextField.text,
                               @"password":_passWordTextField.text,
                               @"from":@"uaa",};
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa-openapi.hekr.me/accountUpgradeByEmail" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            UpdataEmailViewController *emailView = [[UpdataEmailViewController alloc]initWithEmil:_accountTextField.text NavTitle:NSLocalizedString(@"绑定账号", nil) isUpData:YES];
            [self.navigationController pushViewController:emailView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"邮件发送失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }];
    }else if (validateMobile(_accountTextField.text)) {
        UpdataPhoneViewController *phoneView = [[UpdataPhoneViewController alloc]initWithPhone:_accountTextField.text PassWord:_passWordTextField.text];
        [self.navigationController pushViewController:phoneView animated:YES];
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _accountTextField) {
        if (!validateEmail(_accountTextField.text) && !validateMobile(_accountTextField.text)) {
            _hintLabel.text = NSLocalizedString(@"请输入正确的手机号码或邮箱账号",nil);
        }else{
            _hintLabel.text = @"";
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self resignFirst];
}

- (void)resignFirst{
    if ([_accountTextField isFirstResponder]) {
        [_accountTextField resignFirstResponder];
    }
    if ([_passWordTextField isFirstResponder]) {
        [_passWordTextField resignFirstResponder];
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
