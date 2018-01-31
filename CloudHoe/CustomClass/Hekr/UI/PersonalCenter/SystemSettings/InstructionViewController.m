//
//  InstructionViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "InstructionViewController.h"
#import "InstrucDetailViewController.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface InstructionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation InstructionViewController
{
    UITableView *_tableView;
    NSArray *_array;
    UIFont *_font;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    _array = @[NSLocalizedString(@"Q1.氦氪超级APP有哪些主要功能？", nil),NSLocalizedString(@"Q2.怎么下载到氦氪超级APP？", nil),NSLocalizedString(@"Q3.如何使用Wi-Fi配置设备？", nil),NSLocalizedString(@"Q4.无法定位获取天气等数据怎么办？", nil),NSLocalizedString(@"Q5.配置设备失败可能有哪些原因？", nil),NSLocalizedString(@"Q6.如何使用移动数据网络远程控制设备？", nil),NSLocalizedString(@"Q7.如何授权他人共享设备控制权限？", nil)];
    if (ScreenHeight >= 736) {
        _font = [UIFont systemFontOfSize:16];
    }else if (ScreenHeight >= 667){
        _font = [UIFont systemFontOfSize:15];
    }else if (ScreenHeight >= 568){
        _font = [UIFont systemFontOfSize:14];
    }else if (ScreenHeight >= 480){
        _font = [UIFont systemFontOfSize:13];
    }
    [self initNavView];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Instruction"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Instruction"];
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
//    titLabel.text = NSLocalizedString(@"操作说明", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"操作说明" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, Vrange(100)*_array.count)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instructionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"instructionCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _array[indexPath.row];
    cell.textLabel.font = _font;
    cell.textLabel.textColor = getTitledTextColor();
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Vrange(100)-0.5, ScreenWidth, 0.5)];
    downLabel.backgroundColor = getCellLineColor();
    [cell.contentView addSubview:downLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr;
    if ([lang() isEqualToString:@"en-US"]) {
        arr = [_array[indexPath.row] componentsSeparatedByString:@":"];
    }else{
        arr = [_array[indexPath.row] componentsSeparatedByString:@"."];
    }
    
    NSString *str;
    if ([arr[1] length]>10) {
        str = [NSString stringWithFormat:@"%@...",[arr[1] substringToIndex:10]];
    }else{
        str = arr[1];
    }
    InstrucDetailViewController *detailView = [[InstrucDetailViewController alloc]initWithTitle:str Number:indexPath.row];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(100);
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
