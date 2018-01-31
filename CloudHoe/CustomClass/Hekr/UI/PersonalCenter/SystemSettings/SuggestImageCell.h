//
//  SuggestImageCell.h
//  HekrSDKAPP
//
//  Created by hekr on 16/7/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuggestImageCellDelegate <NSObject>

- (void)addImg;
- (void)imgPreview:(NSInteger)count;
@end

@interface SuggestImageCell : UITableViewCell
@property (nonatomic, weak)id<SuggestImageCellDelegate> delegata;
- (void)setImageArray:(NSMutableArray *)array;

@end
