//
//  ReleaseDynamicVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ReleaseDynamicVC.h"

@interface ReleaseDynamicVC ()<UITextViewDelegate>

@property(nonatomic,strong) UITextView *tv;
@property(nonatomic,strong) UILabel *remind;


@end

@implementation ReleaseDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 124)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _tv = [[UITextView alloc] initWithFrame:CGRectMake(20, 14, kScreenWidth-40, view.height-28)];
    _tv.font = [UIFont systemFontOfSize:16];
    [view addSubview:_tv];
    _tv.delegate = self;
//    _tv.backgroundColor = [UIColor redColor];
    
    _remind = [UILabel labelWithframe:CGRectMake(3, 10, 200, 17) text:@"请输入内容" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
    [_tv addSubview:_remind];
    
    UIButton *addBtn = [UIButton buttonWithframe:CGRectMake(20, view.bottom+20, 78, 78) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group" selected:nil];
    [self.view addSubview:addBtn];
//    [addBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, addBtn.bottom+20, kScreenWidth-40, 44) text:@"确定上传" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
//    [loginBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 内容发生改变编辑 自定义文本框placeholder
 有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可
 @param textView textView
 */
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length < 1) {
        self.remind.hidden = NO;
    }
    else {
        self.remind.hidden = YES;
        
    }
    
}

@end
