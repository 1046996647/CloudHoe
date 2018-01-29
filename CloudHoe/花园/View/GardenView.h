//
//  GardenView.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BotanyModel.h"

#import "BotanyCollectionViewCell.h"

@interface GardenView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *plantsArr;

@end
