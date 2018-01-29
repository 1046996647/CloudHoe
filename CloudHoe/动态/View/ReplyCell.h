//
//  ReplyCell.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/25.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EvaluateModel.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"

@interface ReplyCell : UITableViewCell

@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) EvaluateModel *model;

@property(nonatomic,strong) UIImageView *commentView;
@property (nonatomic, strong) YYLabel *commentLabel;

@end
