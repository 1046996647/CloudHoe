//
//  GardenView.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "GardenView.h"
#import "BotanyDetailVC.h"
#import "PersonBotanyVC.h"

@implementation GardenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#EDEEEF"];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{

    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(80, 138);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 15;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth,138) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //        collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[BotanyCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIButton *moreBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-60-10, 49, 60,60) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group 8" selected:nil];
    [self addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
//    //
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, collectionView.bottom+10, kScreenWidth, 44)];
//    view.backgroundColor = [UIColor whiteColor];
//    [self addSubview:view];
//
//
//    UILabel *label = [UILabel labelWithframe:CGRectZero text:@"最新专题" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
//    label.frame = CGRectMake(15, 16, 70, 17);
//    [view addSubview:label];
//
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-.5, kScreenWidth, .5)];
//    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
//    [view addSubview:line];
    
    self.height = collectionView.bottom+10;
    
}

- (void)moreAction
{
    PersonBotanyVC *vc = [[PersonBotanyVC alloc] init];
    //    vc.model1 = model;
    vc.title = @"我的植物";
//    vc.dataArr = self.plantsArr;
    vc.type = 1;
    vc.mark = 1;
    [self.viewController.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.plantsArr.count;
//    return 10;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BotanyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    BotanyModel *model = self.plantsArr[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.plantimg]];
    cell.label.text = model.plantname;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BotanyModel *model = self.plantsArr[indexPath.item];
    
    BotanyDetailVC *vc = [[BotanyDetailVC alloc] init];
    vc.title = model.plantname;
    //    vc.model1 = model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)setPlantsArr:(NSMutableArray *)plantsArr
{
    _plantsArr = plantsArr;
    [self.collectionView reloadData];
    
}





@end
