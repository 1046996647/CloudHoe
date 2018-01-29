//
//  ReplyCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/25.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ReplyCell.h"
#import "NSStringExt.h"
#import "YYLabel+MessageHeight.h"

@implementation ReplyCell

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
        
//        _contentLab = [UILabel labelWithframe:CGRectZero text:@"今天天气好好，拍一张彩虹花盆，美美哒！" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
//        [self.contentView addSubview:_contentLab];
//        _contentLab.numberOfLines = 0;
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"3个小时前" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [self.contentView addSubview:_timeLab];
        
//        _commentView = [UIImageView imgViewWithframe:CGRectZero icon:@""];
//        //        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
//        _commentView.userInteractionEnabled = YES;
//        _commentView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
//        [self.contentView addSubview:_commentView];
        
        [self.contentView addSubview:self.commentLabel];
        
        
    }
    return self;
}

- (YYLabel *)commentLabel{
    
    if (!_commentLabel) {
        _commentLabel = [YYLabel new];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#6F6F6F"];
        _commentLabel.numberOfLines = 0;
        _commentLabel.preferredMaxLayoutWidth = kScreenWidth-70-10; //设置最大的宽度
        _commentLabel.displaysAsynchronously = YES; /// enable async display
        YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
        //        parser.emoticonMapper  = [NSString retunRichTextDic];// 自定义表情
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 20;// _commentLabel的高度减去8
        _commentLabel.textParser = parser;
        _commentLabel.linePositionModifier = mod;
        //        _commentLabel.backgroundColor = [UIColor redColor];
    }
    return _commentLabel;
}

- (void)setModel:(EvaluateModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(15, 15, 55, 55);
    _imgView1.layer.cornerRadius = _imgView1.height/2;
    _imgView1.layer.masksToBounds = YES;
    
    _timeLab.frame = CGRectMake(kScreenWidth-100-15, _imgView1.centerY-7, 100, 15);
    _nameLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, _timeLab.left-(_imgView1.right+10)-10, 18);
    
//    _contentLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+26, kScreenWidth-_nameLab.left-10, 18);
//    CGSize size = [NSString textHeight:model.comment font:_contentLab.font width:_contentLab.width];
//    _contentLab.height = size.height;
    
    _commentLabel.frame = CGRectMake(_nameLab.left, _nameLab.bottom+26, kScreenWidth-_nameLab.left-10, 18);

    
    
    if (model.type.integerValue == 1) {
        
        CGFloat height = [YYLabel getMessageHeight:[[NSString stringWithFormat:@"%@",_model.comment] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  MaxWidth:_commentLabel.width FontNub:14];
        _commentLabel.height = height;
        _commentLabel.text = model.comment;

    }
    else {


        
        NSString *comment = [NSString stringWithFormat:@"回复%@:%@",_model.btoname,_model.comment];
        
        CGFloat height = [YYLabel getMessageHeight:[comment stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  MaxWidth:_commentLabel.width FontNub:14];
        _commentLabel.height = height;
        
//        NSRange range = NSMakeRange(0, [@"回复" length]);
        
        NSRange toRange = NSMakeRange([@"回复" length],[_model.btoname length]);
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[comment stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#6F6F6F"]}];
        text.yy_font = [UIFont systemFontOfSize:14];
//        [text yy_setTextHighlightRange:range
//                                 color:[UIColor colorWithHexString:@"#5583f0"]
//                       backgroundColor:[UIColor clearColor]
//                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//                                 
//                                 NSLog(@"%@",text);
//                                 
//                             }];
        [text yy_setTextHighlightRange:toRange
                                 color:[UIColor colorWithHexString:@"#5583f0"]
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 
                                 NSLog(@"%@",text);
                                 
                             }];
        text.yy_lineSpacing = 0;
        text.yy_alignment = NSTextAlignmentJustified;
        self.commentLabel.attributedText = text;
    }
    
    _model.cellHeight = _commentLabel.bottom+10;

    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    _nameLab.text = model.nikename;
    _timeLab.text = model.time;
    
    
    
}

@end
