//
//  BotanyCollectionViewCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "BotanyCollectionViewCell.h"

@implementation BotanyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 80, 80)];
        //        _imgView.image = [UIImage imageNamed:@"food"];
        //        _imgView.backgroundColor = [UIColor redColor];
        _imgView.layer.cornerRadius = 2;
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img"]];
        
        //        _imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_imgView.width-16, _imgView.height-16, 16, 16)];
        //        //        _imgView.image = [UIImage imageNamed:@"food"];
        //        _imgView1.backgroundColor = [UIColor redColor];
        //        [_imgView addSubview:_imgView1];
        
        _label = [UILabel labelWithframe:CGRectMake(0, _imgView.bottom+11, _imgView.width, 17) text:@"多肉花盆1" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter textColor:@"#313131"];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
