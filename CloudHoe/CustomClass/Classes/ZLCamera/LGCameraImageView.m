//
//  XGCameraImageView.m
//  XinGe
//
//  Created by ligang on 15/11/5.
//  Copyright © 2015年 Tomy. All rights reserved.
//

#import "LGCameraImageView.h"
#import "UIImage+UIImageExt.h"


@interface LGCameraImageView()

@property (nonatomic, strong) UIImageView *photoDisplayView;

@end
@implementation LGCameraImageView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
//        self.backgroundColor = [UIColor blackColor];
        [self setupBottomView];
    }
    return self;
}

- (void)setupBottomView {

    
    // 显示照片的view   在imageToDisplay的set方法中设置frame和image
    UIImageView *photoDisplayView = [[UIImageView alloc] init];
    [self addSubview:photoDisplayView];
    _photoDisplayView = photoDisplayView;
//    photoDisplayView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *cancelBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 55, 55) text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"" normal:@"Back " selected:nil];
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraBtn = [UIButton buttonWithframe:CGRectMake((kScreenWidth-80)/2, kScreenHeight-32-80, 80, 80) text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"" normal:@"paizhao1" selected:nil];
    [self addSubview:cameraBtn];
    [cameraBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
}

//setter
- (void)setImageToDisplay:(UIImage *)imageToDisplay {
    _imageToDisplay = imageToDisplay;
    
    if (imageToDisplay == nil) {
        return;
    }
    
//    imageToDisplay = [UIImage imageCompressFitSizeScale:imageToDisplay targetSize:CGSizeMake(kScreenWidth, kScreenHeight)];
    imageToDisplay = [UIImage imageSizeWithScreenImage:imageToDisplay];
    
//    CGSize size;
//    size.width = [UIScreen mainScreen].bounds.size.width;
//    size.height = ([UIScreen mainScreen].bounds.size.width / imageToDisplay.size.width) * imageToDisplay.size.height;
//    NSLog(@"%@",NSStringFromCGSize(size));
    _photoDisplayView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [_photoDisplayView setImage:imageToDisplay];
}

- (void)cancel1 {
    if ([_delegate respondsToSelector:@selector(xgCameraImageViewCancleBtnTouched)]) {
        [_delegate xgCameraImageViewCancleBtnTouched];
    }
    [self removeFromSuperview];
}

- (void)doneAction {
    if ([_delegate respondsToSelector:@selector(xgCameraImageViewSendBtnTouched)]) {
        [_delegate xgCameraImageViewSendBtnTouched];
    }
}

@end
