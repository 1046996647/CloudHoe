//
//  DynamicDetailCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DynamicDetailCell.h"
#import "NSStringExt.h"

@implementation DynamicDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView1];
//        _imgView1.backgroundColor = [UIColor redColor];

        _nameLab = [UILabel labelWithframe:CGRectZero text:@"MHYTFY(多肉盆栽1)" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
        [self.contentView addSubview:_nameLab];
        
        _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [self.contentView addSubview:_contentLab];
        _contentLab.numberOfLines = 0;
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [self.contentView addSubview:_timeLab];
        
        
        
    }
    return self;
}

- (void)setModel:(EvaluateModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(15, 15, 55, 55);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;
    
    _timeLab.frame = CGRectMake(kScreenWidth-100-15, _imgView1.centerY-7, 100, 15);
    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, _timeLab.left-(_imgView1.right+10)-10, 18);
    _contentLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+26, kScreenWidth-_nameLab.left-10, 18);
    CGSize size = [NSString textHeight:model.comment font:_contentLab.font width:_contentLab.width];
    _contentLab.height = size.height;
    
    _model.cellHeight = _contentLab.bottom+10;
    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    _nameLab.text = model.nikename;
    _contentLab.text = model.comment;
    _timeLab.text = model.time;
        
        
}

@end
