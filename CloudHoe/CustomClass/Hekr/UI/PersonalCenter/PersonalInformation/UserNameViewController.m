//
//  UserNameViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserNameViewController.h"
#import "EasyMacro.h"
#import "Tool.h"
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
//#define MAX_STARWORDS_LENGTH 16

@interface UserNameViewController ()<UITextFieldDelegate>

@end

@implementation UserNameViewController
{
    UITextField *_userName;
    NSString *_name;
}

- (instancetype)initWIthName:(NSString *)name{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
}


- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"修改用户名" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:@"完成" leftBarButtonAction:^{
        [self save];
    }];
    [self.view addSubview:nav];

}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save{
    if ([_userName isFirstResponder]) {
        [_userName resignFirstResponder];
    }

    if (_userName.text.length>16) {
        [self showAlertPromptWithTitle:@"用户名不能超过16个字符" actionCallback:nil];

    }else if (_userName.text.length<=0){
        [self showAlertPromptWithTitle:@"请输入用户名" actionCallback:nil];
        
    }else{
        [self.delegate saveUserName:_userName.text];
        [self popClick];
    }
    
}

- (void)createView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, Hrange(100))];
    view.backgroundColor = getCellBackgroundColor();
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(30), 64, ScreenWidth-2*Hrange(30), Hrange(100))];
    _userName.textColor = getInputTextColor();
    _userName.placeholder = NSLocalizedString(@"修改用户名", nil);
    [_userName setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    _userName.delegate = self;
    _userName.text = _name;
    [_userName addTarget:self action:@selector(TextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:view];
    [self.view addSubview:_userName];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_userName isFirstResponder]) {
        [_userName resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    isMore=YES;
//    if ([string isEqualToString:@""]) {
//        return YES;
//    }
//    if (textField.text.length > 15) {
//        isMore=NO;
//        return NO;
//    }
    return YES;
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
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
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
