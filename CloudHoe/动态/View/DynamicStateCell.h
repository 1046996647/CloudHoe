//
//  DynamicStateCell.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicStateModel.h"

@interface DynamicStateCell : UITableViewCell

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UIImageView *imgView2;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UIButton *stateBtn;
@property(nonatomic,strong) UIButton *evaBtn;
@property(nonatomic,strong) UIButton *likeBtn;
@property (nonatomic, strong) NSMutableArray *zanArr;

@property(nonatomic,strong) DynamicStateModel *model;


@end
