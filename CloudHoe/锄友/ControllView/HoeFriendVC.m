//
//  HoeFriendVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "HoeFriendVC.h"
#import "UserCell1.h"

@interface HoeFriendVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITextField *phone;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;



@end

@implementation HoeFriendVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 手机号
    UIImageView *imgView1 = [UIImageView imgViewWithframe:CGRectMake(0, 0, 34, 14) icon:@"sousuo"];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    
    _phone = [UITextField textFieldWithframe:CGRectMake(0, 0, 302*scaleWidth, 30) placeholder:@"搜索" font:[UIFont systemFontOfSize:14] leftView:imgView1 backgroundColor:@"#ffffff"];
    _phone.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [_phone setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_phone setValue:[UIColor colorWithHexString:@"#ffffff"] forKeyPath:@"_placeholderLabel.textColor"];
    _phone.layer.cornerRadius = _phone.height/2;
    _phone.layer.masksToBounds = YES;
//    _phone.alpha = .2;
    _phone.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.2];
    self.navigationItem.titleView = _phone;
    [_phone addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];

    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight-32) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)valueChange:(UITextField *)tf
{
    if (tf.text.length > 0) {
        
    }
    else {
//        NSLog(@"efefefw");
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    //    return 44;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;

    
}

//修改左滑的按钮的字
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexpath {
    
    return @"删除";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self cellctionAction:self.dataArr[indexPath.row]];
    //    [self.dataArr removeObjectAtIndex:indexPath.row];
    //    [_tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    UserCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UserCell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cell_id];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor clearColor];
    }
    
    UserModel *model = [[UserModel alloc] init];
    model.type = 1;
    cell.model = model;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
