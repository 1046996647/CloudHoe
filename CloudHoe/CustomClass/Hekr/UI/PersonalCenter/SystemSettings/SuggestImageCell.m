//
//  SuggestImageCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SuggestImageCell.h"
#import "Tool.h"

@interface SuggestImageCell ()
@property (nonatomic, strong)NSMutableArray *imgArray;
@property (nonatomic, strong)UIButton *addButton;
@end

@implementation SuggestImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        _addButton.backgroundColor = getCellBackgroundColor();
        if (isNightTheme()) {
            [_addButton setBackgroundImage:[UIImage imageNamed:@"ic_addpic_night"] forState:UIControlStateNormal];
        }else{
            [_addButton setBackgroundImage:[UIImage imageNamed:@"ic_addpic"] forState:UIControlStateNormal];
        }
        
        //[_addButton setBackgroundImage:[UIImage imageNamed:@"ic_addpicselect"] forState:UIControlStateSelected];
        [_addButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat gap = 10;
    CGFloat width = (ScreenWidth - 5 * gap) / 4;
    CGRect imgRect;
    CGRect btnRect;
    if (_imgArray.count == 9) {
        _addButton.hidden = YES ;
    }else{
        _addButton.hidden = NO;
        
    }
    if (_imgArray.count == 0) {
        _addButton.frame = CGRectMake(gap, gap, width, width);
    }else{
        for (int i = 0; i < _imgArray.count; i++) {
            UIImageView *imageView = [UIImageView new];
            if (i < 4) {
                imgRect = CGRectMake(gap + i * (width + gap), gap, width, width);
            }else if (i < 8){
                imgRect = CGRectMake(gap + (i - 4) * (width + gap), gap * 2 + width, width, width);
            }else{
                imgRect = CGRectMake(gap + (i - 8) * (width + gap), (gap * 3) + (width * 2), width, width);
            }
            imageView.frame = imgRect;
            imageView.image = _imgArray[i];
//            imageView.backgroundColor = [UIColor orangeColor];
            imageView.tag = 1005 + i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction:)];
            [imageView addGestureRecognizer:tgr];
            [self.contentView addSubview:imageView];
            
            if (i == _imgArray.count - 1) {
                if (_imgArray.count == 9) {
                    return;
                }
                if (i == 3) {
                    btnRect = CGRectMake(gap, gap * 2 + width, width, width);
                }else if (i == 7){
                    btnRect = CGRectMake(gap, (gap * 3) + (width * 2), width, width);
                }else{
                    btnRect = CGRectMake(imgRect.origin.x + gap + width, imgRect.origin.y, width, width);
                }
                _addButton.frame = btnRect;
            }
            
        }
    }
    NSLog(@"btnRect:%@",NSStringFromCGRect(_addButton.frame));
}

- (void)imgAction:(UITapGestureRecognizer *)tgr{
    UIImageView *img = (UIImageView *)tgr.view;
    [self.delegata imgPreview:img.tag - 1005];
}

- (void)addImage{
    [self.delegata addImg];
}

- (void)setImageArray:(NSMutableArray *)array{
    _imgArray = array;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
