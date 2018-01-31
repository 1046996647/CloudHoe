//
//  SectorImageView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/11.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectorImageView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame step:(NSInteger)step;

-(void)setStrokeStep:(NSInteger)step;
-(void)setSectorStep:(NSInteger)step;

@end
