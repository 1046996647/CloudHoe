//
//  ThemeCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

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
        
        _markImg = [UIImageView imgViewWithframe:CGRectZero icon:@"Group 33"];
        _markImg.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:_markImg];
        //        _imgView1.backgroundColor = [UIColor redColor];

        _imgView2 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView2.contentMode = UIViewContentModeScaleAspectFill;
        [_bgView addSubview:_imgView2];
        //        _imgView2.backgroundColor = [UIColor redColor];
        
        
        _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [_bgView addSubview:_nameLab];
//        [_nameLab wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(多肉盆栽1)"];
        
        
        _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [_bgView addSubview:_contentLab];
        _contentLab.numberOfLines = 0;
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
        [_bgView addSubview:_timeLab];
        
        _stateBtn = [UIButton buttonWithframe:CGRectZero text:@"收藏" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:@"" normal:@"" selected:nil];
        [_bgView addSubview:_stateBtn];
//        _stateBtn.backgroundColor = [UIColor redColor];

        //        _xiaDanBtn.tag = 0;
//        [_stateBtn addTarget:self action:@selector(stateAction) forControlEvents:UIControlEventTouchUpInside];

        
        
    }
    return self;
}

- (void)setModel:(ThemeModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(15, 15, 40, 40);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;
    
    _markImg.frame = CGRectMake(_imgView1.centerX-15, _imgView1.bottom-14, 30, 14);


    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, 60, 18);
    
    _stateBtn.frame = CGRectMake(_nameLab.right+10, 25, 44, 23);
    _stateBtn.layer.cornerRadius = _stateBtn.height/2;
    _stateBtn.layer.masksToBounds = YES;
    _stateBtn.layer.borderWidth = .5;
    _stateBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    
    _contentLab.frame = CGRectMake(_imgView1.left, _imgView1.bottom+10, kScreenWidth-_imgView1.left*2, 18);
//    CGSize size = [NSString textHeight:model.logcomment font:_contentLab.font width:_contentLab.width];
//    _contentLab.height = size.height;
    
    _imgView2.frame = CGRectMake(_imgView1.left, _contentLab.bottom+15, kScreenWidth-_imgView1.left*2, 170);
    
    //    if (model.logimg.length > 0) {
    //        _imgView2.hidden = NO;
    //    }
    //    else {
    //        _imgView2.height = 0;
    //        _imgView2.hidden = YES;
    //
    //    }
    
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, _imgView2.bottom+20);
    
    _model.cellHeight = _bgView.bottom+10;
    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    [_imgView2 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img"]];

    
    
}

@end
