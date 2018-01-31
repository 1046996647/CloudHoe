//
//  ImagePreviewViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/7/14.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImagePreviewDelegate <NSObject>
- (void)deleteImage;
@end
@interface ImagePreviewViewController : UIViewController
@property (nonatomic, weak)id<ImagePreviewDelegate> delegata;
- (instancetype)initWithImage:(NSMutableArray *)imageArray selectCount:(NSInteger)count;
@end
