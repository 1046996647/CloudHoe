//
//  DynamicDetailCell.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateModel.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"

typedef void(^DynamicDetailCellBlock)(EvaluateModel *model);

@interface DynamicDetailCell : UITableViewCell

@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) EvaluateModel *model;
@property(nonatomic,copy) DynamicDetailCellBlock block;

@property(nonatomic,strong) UIImageView *commentView;
@property (nonatomic, strong) YYLabel *commentLabel;


@end
