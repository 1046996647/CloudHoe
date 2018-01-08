//
//  RelateBotanyCell1.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GardenModel.h"

@interface RelateBotanyCell1 : UITableViewCell

@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UILabel *deviceLab;
@property(nonatomic,strong) UIView *line;

@property(nonatomic,strong) GardenModel *model;


@end
