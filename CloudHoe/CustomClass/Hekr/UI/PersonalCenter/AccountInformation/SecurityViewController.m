//
//  SecurityViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SecurityViewController.h"
#import "ChangePassViewController.h"
#import "AppDelegate.h"
#import "ChangePhoneViewController.h"
#import "ChangeEmailViewController.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height

@interface SecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SecurityViewController
{
    UITableView *_tableView;
    NSArray *_dataArray;
    AppDelegate *_appdelegate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = @[NSLocalizedString(@"修改密码", nil)];
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createTableview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"账号与安全", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"账号与安全" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 60)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    UILabel* upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    upLabel.backgroundColor = rgb(209, 209, 209);
    [self.view addSubview:upLabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"securityCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"securityCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor =[UIColor colorWithRed:121/255.0 green:122/255.0 blue:123/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 59.5, ScreenWidth, 0.5)];
    downLabel.backgroundColor = getCellLineColor();
    [cell.contentView addSubview:downLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[ChangePassViewController new] animated:YES];
    
    /*
     NSInteger count = indexPath.row;
     switch (count) {
     case 0:
     {
     NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isPhone"];
     _appdelegate.isPhone = YES;
     if ([str isEqualToString:@"YES"]) {
     [self.navigationController pushViewController:[ChangePhoneViewController new] animated:YES];
     }else if([str isEqualToString:@"NO"]){
     [self.navigationController pushViewController:[ChangeEmailViewController new] animated:YES];
     }
     }
     break;
     case 1:
     [self.navigationController pushViewController:[ChangePassViewController new] animated:YES];
     
     break;
     
     default:
     break;
     }
     */
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
