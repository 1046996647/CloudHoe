//
//  MessageCenterViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/30.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MessageCenterViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "GiFHUD.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
#import "ReadWebViewController.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MessageCenterViewController
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UIView *_empView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
//    _dataArray = [NSArray new];
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createView];
    [self getDataFromUrl];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick beginLogPageView:@"MessageCenter"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MessageCenter"];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"消息中心" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getDataFromUrl{
    [GiFHUD showWithOverlay:self.view];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
    [manager GET:[NSString stringWithFormat:@"http://console.openapi.hekr.me/external/vc/getByPid?pid=%@",[Hekr sharedInstance].pid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[消息中心]：%@",responseObject);
        [GiFHUD disMiss];
        if (responseObject[@"result"]) {
            _dataArray = responseObject[@"result"];
        }
//        _dataArray = @[@"1",@"1",@"1",@"1"];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD disMiss];

        [self.view.window makeToast:NSLocalizedString(@"信息拉取失败", nil) duration:1.0 position:@"center"];
    }];
}


- (void)createView{
    
    _empView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Hrange(168)+20)];
    _empView.center = CGPointMake(self.view.center.x, self.view.center.y-32);
    _empView.backgroundColor = [UIColor clearColor];
    _empView.hidden = YES;
    [self.view addSubview:_empView];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Hrange(160), Hrange(108))];
    img.center = CGPointMake(Width/2, Hrange(84)+10);
    img.image = [UIImage imageNamed:@"default"];
    [_empView addSubview:img];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+Hrange(60), Width, 20)];
    label.text = NSLocalizedString(@"暂无消息", nil);
    label.font = getNavTitleFont();
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = getDescriptiveTextColor();
    [_empView addSubview:label];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CoverViewRectMake];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![_dataArray isKindOfClass:[NSNull class]]) {
        if (_dataArray.count == 0) {
            _empView.hidden = NO;
        }else{
            _empView.hidden = YES;
        }
        return _dataArray.count;
    }else{
        _empView.hidden = NO;
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = getCellBackgroundColor();
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(Hrange(20), Vrange(30), Hrange(90), Hrange(90))];
//    img.backgroundColor = [UIColor orangeColor];
    img.image = [UIImage imageNamed:@"wisen_icon"];
    [cell.contentView addSubview:img];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+Hrange(24), Vrange(30), ScreenWidth-Hrange(154), 15)];
    title.textColor = rgb(80, 80, 82);
    title.font = [UIFont systemFontOfSize:15];
//    title.backgroundColor = [UIColor redColor];
    title.text = _dataArray[indexPath.row][@"title"];
    [cell.contentView addSubview:title];
    
    UILabel *time = [[UILabel   alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+Hrange(24), Hrange(90)+Vrange(30)-12, ScreenWidth-Hrange(154), 12)];
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = rgb(80, 80, 82);
    time.text = [self getDateFromString:_dataArray[indexPath.row][@"updateTime"]];
//    time.backgroundColor = [UIColor brownColor];
    [cell.contentView addSubview:time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_dataArray[indexPath.row][@"infoContent"]]];
    ReadWebViewController *readWebVC = [[ReadWebViewController alloc] initWithTitle:NSLocalizedString(@"消息内容", nil) url:_dataArray[indexPath.row][@"infoContent"]];
    [self.navigationController pushViewController:readWebVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Hrange(90)+Vrange(60);
}

//-(NSString *)time:(long)time{
//    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    return [dateFormatter stringFromDate:d];
//}


- (NSString *)getDateFromString:(NSString *)string {
    
    double publishLong = [string doubleValue];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong/1000];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    publishDate = [publishDate  dateByAddingTimeInterval:interval];
    
    NSString *time = [formatter stringFromDate:publishDate];
    
    return time;
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
