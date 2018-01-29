//
//  RelateBotanyCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "RelateBotanyCell.h"

@implementation RelateBotanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _stateBtn = [UIButton buttonWithframe:CGRectZero text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"" normal:@"Rectangle 18" selected:@"bangd "];
        [self.contentView addSubview:_stateBtn];
        //        _xiaDanBtn.tag = 0;
        
        _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@""];
        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView1];
        _imgView1.backgroundColor = [UIColor redColor];
        
        
        _nameLab = [UILabel labelWithframe:CGRectZero text:@"多肉盆栽1" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [self.contentView addSubview:_nameLab];
        
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"2017 12-29" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [self.contentView addSubview:_timeLab];
        
        

    }
    return self;
}



- (void)setModel:(GardenModel *)model
{
    _model = model;
    
    _stateBtn.frame = CGRectMake(0, 0, 45, 86);

    _imgView1.frame = CGRectMake(_stateBtn.right, 16, 60, 60);
    _imgView1.layer.cornerRadius = 2;
    _imgView1.layer.masksToBounds = YES;
    
    _timeLab.frame = CGRectMake(kScreenWidth-15-79, _imgView1.centerY-7, 79, 15);
    
    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, _timeLab.left-(_imgView1.right+10)-10, 18);
    


}

@end
