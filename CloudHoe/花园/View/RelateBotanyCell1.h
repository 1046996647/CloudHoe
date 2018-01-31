//
//  RelateBotanyCell1.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BotanyModel.h"

typedef void(^RelateBotanyCell1Block)(BotanyModel *model);

@interface RelateBotanyCell1 : UITableViewCell

@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UILabel *deviceLab;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIButton *deviceBtn;

@property(nonatomic,strong) BotanyModel *model;
@property(nonatomic,copy) RelateBotanyCell1Block block;


@end
