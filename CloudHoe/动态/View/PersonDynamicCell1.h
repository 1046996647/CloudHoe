//
//  PersonDynamicCell1.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/5.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicStateModel.h"

@interface PersonDynamicCell1 : UITableViewCell

@property(nonatomic,strong) UIView *baseView;
@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *timeLab;

@property(nonatomic,strong) DynamicStateModel *model;


@end
