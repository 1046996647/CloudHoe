//
//  DynamicStateVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DynamicStateVC.h"
#import "FSScrollContentView.h"
#import "HeaderView.h"
#import "ReleaseDynamicVC.h"
#import "ConcernDynamicVC.h"
#import "HotDynamicVC.h"
#import "NearbyDynamicVC.h"

@interface DynamicStateVC ()<FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView5;
@property (nonatomic, strong) UITableView *tableView;
//@property(nonatomic,strong) HeaderView *headView;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation DynamicStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = nil;

    FSSegmentTitleView *titleView5 = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, 170, 44) titles:@[@"关注",@"热门",@"附近"] delegate:self indicatorType:2];
    //    titleView5.titleSelectFont = [UIFont systemFontOfSize:20];
    titleView5.indicatorColor = [UIColor clearColor];
    titleView5.titleFont = SystemFont(16);
    titleView5.titleSelectFont = [UIFont boldSystemFontOfSize:16];
    titleView5.titleNormalColor = [UIColor colorWithHexString:@"#efefef"];
    titleView5.titleSelectColor = [UIColor colorWithHexString:@"#ffffff"];
//    titleView5.selectIndex = 1;
    self.navigationItem.titleView = titleView5;
    self.titleView5 = titleView5;
    
    ConcernDynamicVC *vc2 = [[ConcernDynamicVC alloc]init];
    HotDynamicVC *vc3 = [[HotDynamicVC alloc]init];
    NearbyDynamicVC *vc4 = [[NearbyDynamicVC alloc]init];

    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    [childVCs addObject:vc2];
    [childVCs addObject:vc3];
    [childVCs addObject:vc4];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight) childVCs:childVCs parentVC:self delegate:self];
//    self.pageContentView.contentViewCurrentIndex = 1;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];

    
    UIButton *viewBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 32, 32) text:@"发布" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [viewBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
}



- (void)releaseAction
{
    ReleaseDynamicVC *vc = [[ReleaseDynamicVC alloc] init];
    vc.title = @"发布动态";
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;

}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView5.selectIndex = endIndex;

}

@end
