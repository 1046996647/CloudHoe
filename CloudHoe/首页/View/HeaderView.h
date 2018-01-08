//
//  HeaderView.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "UserCell.h"


@interface HeaderView : UIView<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

//-----------轮播-----------
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView2;

// 浇水
@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;

// 推荐用户
@property(nonatomic,strong) UICollectionView *collectionView;


@end
