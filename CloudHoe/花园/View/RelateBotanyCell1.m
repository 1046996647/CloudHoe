//
//  RelateBotanyCell1.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "RelateBotanyCell1.h"

@implementation RelateBotanyCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView1];
        _imgView1.backgroundColor = [UIColor redColor];
        
        
        _nameLab = [UILabel labelWithframe:CGRectZero text:@"多肉盆栽1" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [self.contentView addSubview:_nameLab];
        
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"2017 12-29" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [self.contentView addSubview:_timeLab];
        
        
        _deviceLab = [UILabel labelWithframe:CGRectZero text:@"未绑定设备" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft textColor:@"#999999"];
        [self.contentView addSubview:_deviceLab];

        _line = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        
        _deviceBtn = [UIButton buttonWithframe:CGRectZero text:@"绑定设备" font:[UIFont systemFontOfSize:14] textColor:@"#4A90E2" backgroundColor:@"" normal:@"" selected:nil];
        [self.contentView addSubview:_deviceBtn];
        _deviceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //        _xiaDanBtn.tag = 0;
        [_deviceBtn addTarget:self action:@selector(deviceAction) forControlEvents:UIControlEventTouchUpInside];
//        _deviceBtn.hidden = YES;
        
    }
    return self;
}

- (void)deviceAction
{
    if (self.block) {
        self.block(_model);
    }
}


- (void)setModel:(BotanyModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(15, 10, 60, 60);
    _imgView1.layer.cornerRadius = 2;
    _imgView1.layer.masksToBounds = YES;
    
    _timeLab.frame = CGRectMake(kScreenWidth-15-79, 22, 79, 15);
    
    _nameLab.frame = CGRectMake(_imgView1.right+10, _timeLab.centerY-9, _timeLab.left-(_imgView1.right+10)-10, 18);
    
    _deviceLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+14, kScreenWidth-_nameLab.left-10, 18);
    
    _deviceBtn.frame = CGRectMake(kScreenWidth-15-60, _deviceLab.centerY-7, 60, 15);
    
    _line.frame = CGRectMake(15, 81-0.5, kScreenWidth-15, 0.5);

    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:model.plantimg] placeholderImage:[UIImage imageNamed:@"img"]];
    _nameLab.text = model.plantname;
    _timeLab.text = model.time;

}

@end
