//
//  ChangePassViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ChangePassViewController.h"

#import <HekrAPI.h>
#import <AFNetworking.h>
#import "Tool.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface ChangePassViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation ChangePassViewController
{
    UITableView *_tableView;
    UITextField *_oldPass;
    UITextField *_newPass1;
    UITextField *_newPass2;
    BOOL _isSuccess;
    UILabel *_hintLabel;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createTableview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChangePassWord"];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChangePassWord"];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"修改密码", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"修改密码" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}   

- (void)createTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+Vrange(32), self.view.frame.size.width, Vrange(300))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
//    UILabel* upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
//    upLabel.backgroundColor = rgb(209, 209, 209);
//    [self.view addSubview:upLabel];
    
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_tableView.frame), Width - 40, 36)];
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    _hintLabel.numberOfLines = 0;
    [self.view addSubview:_hintLabel];
    
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) frame:CGRectMake(0, 0, sHrange(320), sVrange(40)) target:self action:@selector(changePassWord)];
    button.center = CGPointMake(Width/2, CGRectGetMaxY(_tableView.frame)+80);
    [self.view addSubview:button];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changepassCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"changepassCell"];
        UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Vrange(100)-0.5, ScreenWidth, 0.5)];
        downLabel.backgroundColor = getCellLineColor();
        [cell.contentView addSubview:downLabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSInteger count = indexPath.row;
    CGRect frame = cell.contentView.frame;
    switch (count) {
        case 0:
        {
            _oldPass = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, Vrange(100))];
            _oldPass.textColor = getInputTextColor();
            _oldPass.font = getDescTitleFont();
            _oldPass.placeholder = NSLocalizedString(@"请输入旧密码", nil);
            [_oldPass setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
            _oldPass.delegate = self;
            [_oldPass setSecureTextEntry:YES];
            [cell.contentView addSubview:_oldPass];
        }
            break;
        case 1:
        {
            _newPass1 = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, Vrange(100))];
            _newPass1.textColor = getInputTextColor();
            _newPass1.font = getDescTitleFont();
            _newPass1.placeholder = NSLocalizedString(@"请输入新密码", nil);
            [_newPass1 setValue:getPlaceholderTextColor()  forKeyPath:@"_placeholderLabel.textColor"];
            _newPass1.delegate = self;
            [_newPass1 setSecureTextEntry:YES];
            [cell.contentView addSubview:_newPass1];
        }

            break;
        case 2:
        {
            _newPass2 = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, Vrange(100))];
            _newPass2.font = getDescTitleFont();
            _newPass2.textColor = getInputTextColor();
            _newPass2.placeholder = NSLocalizedString(@"请重新输入新密码", nil);
            [_newPass2 setValue:getPlaceholderTextColor()  forKeyPath:@"_placeholderLabel.textColor"];
            _newPass2.delegate = self;
            [_newPass2 setSecureTextEntry:YES];
            [cell.contentView addSubview:_newPass2];
        }

            break;
            
        default:
            break;
    }
    
    cell.backgroundColor = getCellBackgroundColor();
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(100);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_oldPass isFirstResponder]) {
        [_oldPass resignFirstResponder];
    }else if ([_newPass1 isFirstResponder]){
        [_newPass1 resignFirstResponder];
    }else if ([_newPass2 isFirstResponder]){
        [_newPass2 resignFirstResponder];
    }
}


- (void)changePassWord{
    [self.view endEditing:YES];
    if (_oldPass.text.length == 0) {
        _isSuccess = NO;
        _hintLabel.text = NSLocalizedString(@"请输入旧密码", nil);
    }else if (![_newPass1.text isEqualToString:_newPass2.text]){
        _isSuccess = NO;
        _hintLabel.text = NSLocalizedString(@"新密码输入不一致，请重新输入", nil);
    }else if([_oldPass.text isEqualToString:_newPass1.text]){
        _isSuccess = NO;
        _hintLabel.text = NSLocalizedString(@"新密码与旧密码一致，请重新输入",nil);
    }else if(!validatePassWord(_newPass1.text)){
        _isSuccess = NO;
        _hintLabel.text = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成",nil);
    }else{
        [self changePasssWordFromUrl];
    }
}

- (void)changePasssWordFromUrl{
    [GiFHUD showWithOverlay];
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa.openapi.hekr.me/changePassword" parameters:@{@"pid":[Hekr sharedInstance].pid,
                                    @"newPassword":_newPass1.text,
                                    @"oldPassword":_oldPass.text}
    progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        DDLogInfo(@"[修改密码]：%@",responseObject);
        _isSuccess = YES;
        
        [self showAlertPromptWithTitle:@"修改成功，请重新登录" actionCallback:^(UIAlertAction * _Nonnull action) {
            [[Hekr sharedInstance] logout];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HekrSDKUserChangeNotification object:nil];
            }
        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        _isSuccess = NO;

        if (APIErrorCode(error) == 3400007) {
            _hintLabel.text = APIError(error);
        }else if ([APIError(error) isEqualToString:@"0"]) {
            [self.view.window makeToast:NSLocalizedString(@"密码修改失败", nil) duration:1.0 position:@"center"];
        }else{
            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
        }
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _oldPass) {
        [_newPass1 becomeFirstResponder];
    }else if (textField == _newPass1){
        [_newPass2 becomeFirstResponder];
    }else if (textField == _newPass2){
        [self changePassWord];
    }
    
    return YES;
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
