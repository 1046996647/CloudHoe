//
//  ThemeCell.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThemeModel.h"
#import "NSStringExt.h"


@interface ThemeCell : UITableViewCell

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UIImageView *markImg;
@property(nonatomic,strong) UIImageView *imgView2;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UIButton *stateBtn;
@property(nonatomic,strong) UIButton *evaBtn;
@property(nonatomic,strong) UIButton *likeBtn;
@property (nonatomic, strong) NSMutableArray *zanArr;

@property(nonatomic,strong) ThemeModel *model;

@end
