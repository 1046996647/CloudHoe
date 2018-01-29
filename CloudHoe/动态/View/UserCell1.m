//
//  UserCell1.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/8.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "UserCell1.h"

@implementation UserCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 45, 45)];
        //        _imgView.image = [UIImage imageNamed:@"food"];
//        _imgView.backgroundColor = [UIColor redColor];
        _imgView.layer.cornerRadius = _imgView.height/2;
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        
        //        _imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_imgView.width-16, _imgView.height-16, 16, 16)];
        //        //        _imgView.image = [UIImage imageNamed:@"food"];
        //        _imgView1.backgroundColor = [UIColor redColor];
        //        [_imgView addSubview:_imgView1];
        
        _label = [UILabel labelWithframe:CGRectMake(_imgView.right+10, _imgView.centerY-6.5, 200, 13) text:@"赵诗怡" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [self.contentView addSubview:_label];
        
        
        _guanZhuBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-55-15, (60-20)/2, 55, 20) text:@"关注" font:[UIFont systemFontOfSize:14] textColor:@"#50DBD1" backgroundColor:nil normal:@"" selected:nil];
        [self.contentView addSubview:_guanZhuBtn];
        _guanZhuBtn.layer.cornerRadius = _guanZhuBtn.height/2;
        _guanZhuBtn.layer.masksToBounds = YES;
        _guanZhuBtn.layer.borderWidth = .5;
        _guanZhuBtn.layer.borderColor = [UIColor colorWithHexString:@"#50DBD1"].CGColor;

        [_guanZhuBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)btnAction
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic setValue:_model.userId forKey:@"friendId"];

    [AFNetworking_RequestData requestMethodPOSTUrl:Addfriend dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        if (self.block) {
            self.block(_model);
        }
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)setModel:(UserModel *)model
{
    _model = model;

    if (model.type == 1) {

        _guanZhuBtn.hidden = NO;
        
        
    }
    else {

        _guanZhuBtn.hidden = YES;

    }
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    _label.text = model.nikename;
}

@end
