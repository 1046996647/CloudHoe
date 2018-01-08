//
//  PersonDynamicCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PersonDynamicCell.h"
#import "UILabel+WLAttributedString.h"

@implementation PersonDynamicCell

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
        _imgView1.backgroundColor = [UIColor redColor];
        
        _imgView2 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView2.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:_imgView2];
        _imgView2.backgroundColor = [UIColor redColor];
        
        
//        _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
//        [_bgView addSubview:_nameLab];
        
        _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter textColor:@"#313131"];
        [_bgView addSubview:_contentLab];
        _contentLab.numberOfLines = 0;
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [_bgView addSubview:_timeLab];
        
        _stateBtn = [UIButton buttonWithframe:CGRectZero text:@"多肉盆栽1号" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"" normal:@"" selected:nil];
        [_bgView addSubview:_stateBtn];
        _stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //        _xiaDanBtn.tag = 0;
        //        [_stateBtn addTarget:self action:@selector(xiaDanAction) forControlEvents:UIControlEventTouchUpInside];
        

        _evaBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:12] textColor:@"#999999" backgroundColor:nil normal:@"评论" selected:nil];
        [_bgView addSubview:_evaBtn];
        _evaBtn.tag = 0;
        [_evaBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _evaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _evaBtn.userInteractionEnabled = NO;
        
        _likeBtn = [UIButton buttonWithframe:CGRectZero text:@"138" font:[UIFont systemFontOfSize:12] textColor:@"#999999" backgroundColor:nil normal:@"赞" selected:nil];
        [_bgView addSubview:_likeBtn];
        _likeBtn.tag = 1;
        [_likeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    }
    return self;
}

- (void)setModel:(DynamicStateModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(9, 9, 20, 20);
    _imgView2.frame = CGRectMake(_imgView1.right+10, _imgView1.top, 70, 70);
    _timeLab.frame = CGRectMake(kScreenWidth-70-15, 15, 70, 15);
    _contentLab.frame = CGRectMake(_imgView2.left, _imgView2.bottom+10, kScreenWidth-_imgView2.left-10, 18);
    
    _evaBtn.frame = CGRectMake(_contentLab.left+5, _contentLab.bottom+23, 50, 20);
    _likeBtn.frame = CGRectMake(_evaBtn.right+21, _evaBtn.top, 50, 20);


    _stateBtn.frame = CGRectMake(kScreenWidth-100-15, _likeBtn.centerY-11, 100, 23);
    
//    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, kScreenWidth-(_imgView1.right+10)-10, 18);

    
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, _likeBtn.bottom+20);
    _line.frame = CGRectMake(0, _bgView.bottom, kScreenWidth, 5);

    _model.cellHeight = _line.bottom;
}

- (void)xiaDanAction
{
    
}

- (void)btnAction:(UIButton *)btn
{
    
    if (btn.tag == 0) {
        
    }
    else {
        
    }
    
}


@end
