//
//  AuthorizeCell.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/11.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface AuthorizeCell : UITableViewCell

@property(nonatomic,strong) UIImageView *imgView1;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong) UIButton *stateBtn;
@property(nonatomic,strong) UserModel *model;

@end
