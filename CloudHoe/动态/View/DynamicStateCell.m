//
//  DynamicStateCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DynamicStateCell.h"
#import "UILabel+WLAttributedString.h"
#import "NSStringExt.h"

@implementation DynamicStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //244
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_bgView];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:_imgView1];
//        _imgView1.backgroundColor = [UIColor redColor];
        
        _imgView2 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView2.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:_imgView2];
//        _imgView2.backgroundColor = [UIColor redColor];

        
        _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [_bgView addSubview:_nameLab];
        [_nameLab wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(多肉盆栽1)"];

        
        _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [_bgView addSubview:_contentLab];
        _contentLab.numberOfLines = 0;
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
        [_bgView addSubview:_timeLab];

        _stateBtn = [UIButton buttonWithframe:CGRectZero text:@"关注" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"" normal:@"" selected:nil];
        [_bgView addSubview:_stateBtn];
//        _xiaDanBtn.tag = 0;
        [_stateBtn addTarget:self action:@selector(stateAction) forControlEvents:UIControlEventTouchUpInside];

        
        
        _evaBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"评论" selected:nil];
        [_bgView addSubview:_evaBtn];
        _evaBtn.tag = 0;
        [_evaBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _evaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _evaBtn.userInteractionEnabled = NO;
        
        _likeBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"赞" selected:@"Group 6"];
        [_bgView addSubview:_likeBtn];
        _likeBtn.tag = 1;
        [_likeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);

        
    }
    return self;
}

- (void)stateAction
{
    [self addfriend];
}

- (void)addfriend
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:self.model.userId forKey:@"friendId"];
    //    [paramDic  setValue:@"7db9e4b81a16ef15e195599fc4de0eae" forKey:@"Token"];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Addfriend dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        
//        id obj = responseObject[@"data"];

        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setModel:(DynamicStateModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(15, 15, 40, 40);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;
    
    _stateBtn.frame = CGRectMake(kScreenWidth-15-57, 25, 57, 23);
    _stateBtn.layer.cornerRadius = _stateBtn.height/2;
    _stateBtn.layer.masksToBounds = YES;
    _stateBtn.layer.borderWidth = .5;
    _stateBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    
    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, kScreenWidth-(_imgView1.right+10)-10, 18);
    
    _contentLab.frame = CGRectMake(_imgView1.left, _imgView1.bottom+10, kScreenWidth-_imgView1.left*2, 18);
    CGSize size = [NSString textHeight:model.logcomment font:_contentLab.font width:_contentLab.width];
    _contentLab.height = size.height;

    _imgView2.frame = CGRectMake(_imgView1.left, _contentLab.bottom+15, kScreenWidth-_imgView1.left*2, 170);
    
//    if (model.logimg.length > 0) {
//        _imgView2.hidden = NO;
//    }
//    else {
//        _imgView2.height = 0;
//        _imgView2.hidden = YES;
//
//    }
    
    _timeLab.frame = CGRectMake(_imgView1.left, _imgView2.bottom+22, 120, 15);
    _likeBtn.frame = CGRectMake(kScreenWidth-15-50, _imgView2.bottom+20, 50, 20);
    _evaBtn.frame = CGRectMake(_likeBtn.left-10-_likeBtn.width, _likeBtn.top, _likeBtn.width, _likeBtn.height);

    _bgView.frame = CGRectMake(0, 0, kScreenWidth, _likeBtn.bottom+20);
    
    _model.cellHeight = _bgView.bottom+10;
    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    [_imgView2 sd_setImageWithURL:[NSURL URLWithString:model.logimg] placeholderImage:[UIImage imageNamed:@"img"]];
    if (model) {
        
        _nameLab.text = model.nikename;
        _contentLab.text = model.logcomment;
        _timeLab.text = model.logtime;
        [_evaBtn setTitle:model.commentnum forState:UIControlStateNormal];
        [_likeBtn setTitle:model.zannum forState:UIControlStateNormal];
        if (model.zanstas.integerValue == 0) {
            _likeBtn.selected = NO;
        }
        else {
            _likeBtn.selected = YES;
            
        }
        self.zanArr = self.model.zanuser.mutableCopy;
    }


}

- (void)xiaDanAction
{

}

- (void)btnAction:(UIButton *)btn
{
    
    if (btn.tag == 0) {
        
    }
    else {
        [self clike];
    }

}

// 日志点赞
- (void)clike
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:self.model.logid forKey:@"logid"];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Clike dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        if (self.model.zanstas.integerValue == 1) {// 已赞
            
            self.model.zanstas = @"0";
            _likeBtn.selected = NO;
            self.model.zannum = [NSString stringWithFormat:@"%ld",(self.model.zannum.integerValue-1)];
            
            NSString *userid = [InfoCache unarchiveObjectWithFile:@"userId"];
            for (Zanuser *model in self.zanArr) {
                if ([model.userId isEqualToString:userid]) {
                    [self.zanArr removeObject:model];
                }
            }
            
        }
        else {
            self.model.zanstas = @"1";
            _likeBtn.selected = YES;
            self.model.zannum = [NSString stringWithFormat:@"%ld",(self.model.zannum.integerValue+1)];
            Zanuser *model = [Zanuser yy_modelWithJSON:responseObject[@"data"]];
            [self.zanArr addObject:model];
        }
        self.model.zanuser = self.zanArr;
        [_likeBtn setTitle:self.model.zannum forState:UIControlStateNormal];
        
        
        
    } failure:^(NSError *error) {
        
    }];
}









@end
