//
//  UpdataEmailViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UpdataEmailViewController.h"
#import "Tool.h"
#import <Masonry.h>
#import "LoginViewController.h"
#import "UserViewController.h"

@interface UpdataEmailViewController ()
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *navTitle;
@property (nonatomic, assign)BOOL isUpdata;
@end

@implementation UpdataEmailViewController

- (instancetype)initWithEmil:(NSString *)email NavTitle:(NSString *)navTitle isUpData:(BOOL)isUpdata{
    self = [super init];
    if (self) {
        _email = email;
        _navTitle = navTitle;
        _isUpdata = isUpdata;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createViews];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:_navTitle leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_changeemail"]];
    [self.view addSubview:image];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"邮箱地址：",nil)];
//    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = getTitledTextColor();
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *emailLabel = [UILabel new];
    emailLabel.font = [UIFont boldSystemFontOfSize:18];
    emailLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),_email];
    emailLabel.adjustsFontSizeToFitWidth = YES;
    emailLabel.textColor = getTitledTextColor();
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emailLabel];
    
    UILabel *downLabel = [UILabel new];
    downLabel.font = [UIFont boldSystemFontOfSize:14];
    downLabel.text = NSLocalizedString(@"验证链接已发送至您的邮箱，请前往登录邮箱，点击链接完成验证。",nil);
    downLabel.textColor = getDescriptiveTextColor();
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.numberOfLines = 0;
    [self.view addSubview:downLabel];
    
    UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) frame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT) target:self action:@selector(tureAction)];
    [self.view addSubview:btn];
    
    WS(weakSelf);
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(140)+StatusBarAndNavBarHeight);
        make.size.mas_equalTo(CGSizeMake(Vrange(150), Vrange(114)));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(Vrange(76));
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 20));
    }];
    
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 20));
    }];
    
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emailLabel.mas_centerX);
        make.top.equalTo(emailLabel.mas_bottom).offset(Vrange(40));
        make.width.mas_equalTo(Width - 20);
    }];
    [downLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(downLabel.mas_bottom).offset(Vrange(168));
        make.size.mas_equalTo(CGSizeMake(sHrange(320), sVrange(40)));
    }];
}

- (void)tureAction{
    if (_isUpdata == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataEmail" object:nil userInfo:@{@"Email":_email}];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[UserViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
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
