//
//  PersonDynamicCell2.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/5.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PersonDynamicCell2.h"
#import "NSStringExt.h"

@implementation PersonDynamicCell2

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
        
        
        //        _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        //        [_bgView addSubview:_nameLab];
        
        _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [_bgView addSubview:_contentLab];
        _contentLab.numberOfLines = 0;
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"22 : 14" font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [_bgView addSubview:_timeLab];
    
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        [_bgView addSubview:_line];
        _line.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8 "];
        
        _stateBtn = [UIButton buttonWithframe:CGRectZero text:@"多肉盆栽1号" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"" normal:@"" selected:nil];
        [_line addSubview:_stateBtn];
        _stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //        _xiaDanBtn.tag = 0;
        //        [_stateBtn addTarget:self action:@selector(xiaDanAction) forControlEvents:UIControlEventTouchUpInside];
        
        _evaBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:12] textColor:@"#999999" backgroundColor:nil normal:@"评论" selected:nil];
        [_line addSubview:_evaBtn];
        _evaBtn.tag = 0;
        [_evaBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _evaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _evaBtn.userInteractionEnabled = NO;
        
        _likeBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:12] textColor:@"#999999" backgroundColor:nil normal:@"赞" selected:@"Group 6"];
        [_line addSubview:_likeBtn];
        _likeBtn.tag = 1;
        [_likeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        

    }
    return self;
}

- (void)setModel:(DynamicStateModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(9, 9, 20, 20);
    _imgView2.frame = CGRectMake(_imgView1.right+10, _imgView1.top, 70, 70);

    if (model.logimg.length > 0) {
        _imgView1.image = [UIImage imageNamed:@"pz"];
        _imgView2.hidden = NO;
    }
    else {
        _imgView2.bottom = 29;
        _imgView1.image = [UIImage imageNamed:@"jil "];
        _imgView2.hidden = YES;

    }
    _timeLab.frame = CGRectMake(kScreenWidth-30-70-15, 15, 70, 15);
    _contentLab.frame = CGRectMake(_imgView2.left, _imgView2.bottom+10, kScreenWidth-30-_imgView2.left-10, 18);
    CGSize size = [NSString textHeight:model.logcomment font:_contentLab.font width:_contentLab.width];
    _contentLab.height = size.height;
    
    _line.frame = CGRectMake(0, _contentLab.bottom+23, kScreenWidth-30, 40);

    _evaBtn.frame = CGRectMake(_contentLab.left+5, 13, 50, 20);
    _likeBtn.frame = CGRectMake(_evaBtn.right+21, _evaBtn.top, 50, 20);
    
    
    _stateBtn.frame = CGRectMake(kScreenWidth-30-100-15, _likeBtn.centerY-11, 100, 23);
    
    //    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, kScreenWidth-(_imgView1.right+10)-10, 18);
    
    
    _bgView.frame = CGRectMake(15, 0, kScreenWidth-30, _line.bottom);
    _bgView.layer.shadowColor = [UIColor colorWithHexString:@"#D3D5D7"].CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _bgView.layer.shadowOpacity = 1;//阴影透明度，默认0
    //    self.xiaDanBtn.layer.shadowRadius = 2;//阴影半径，默认3
    
    _model.cellHeight = _bgView.bottom+15;
    
    [_imgView2 sd_setImageWithURL:[NSURL URLWithString:model.logimg] placeholderImage:[UIImage imageNamed:@"img"]];
    _nameLab.text = model.nikename;
    _contentLab.text = model.logcomment;
    _timeLab.text = model.lastTime;
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
