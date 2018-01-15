//
//  MyDeviceVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/10.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "MyDeviceVC.h"
#import "UILabel+WLAttributedString.h"
#import "SetDeviceVC.h"
#import "ScanVC.h"

@interface MyDeviceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation MyDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 10, kScreenWidth, kScreenHeight-kTopHeight-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"添加" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [viewBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction
{
    ScanVC *vc = [[ScanVC alloc] init];
    vc.title = @"绑定设备";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.dataArr count];
    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 46;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];

        UIButton *setBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-60, 0, 60, 46) text:@"设置" font:[UIFont systemFontOfSize:14] textColor:@"#4A90E2" backgroundColor:@"" normal:@"" selected:nil];
//        setBtn.tag = 100;
        [cell.contentView addSubview:setBtn];
        [setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"设备"];

    cell.textLabel.textColor = [UIColor colorWithHexString:@"#313131"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = @"设备号：12346 (在线)";
    
    [cell.textLabel wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(在线)"];

    return cell;
}

- (void)setAction
{
    SetDeviceVC *vc = [[SetDeviceVC alloc] init];
    vc.title = @"设备号：12346";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
