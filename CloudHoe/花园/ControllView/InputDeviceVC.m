//
//  InputDeviceVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/11.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "InputDeviceVC.h"

@interface InputDeviceVC (){
    UITextField *_tv;

    
}

@end

@implementation InputDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
    
    _tv = [[UITextField alloc] initWithFrame:CGRectMake(0, 12, kScreenWidth, 44)];
    _tv.backgroundColor = [UIColor whiteColor];
    //    _tv.delegate = self;
//    _tv.text = self.text;
    _tv.leftViewMode = UITextFieldViewModeAlways;
    _tv.leftView = leftView;
    _tv.placeholder = @"输入设备号";
    _tv.font = [UIFont systemFontOfSize:16];
    _tv.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tv becomeFirstResponder];
    [self.view addSubview:_tv];
    _tv.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *viewBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 36, 22) text:@"绑定" font:SystemFont(15) textColor:@"#FFFFFF" backgroundColor:nil normal:nil selected:nil];
    [viewBtn addTarget:self action:@selector(bangDingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bangDingAction
{
    
}

@end
