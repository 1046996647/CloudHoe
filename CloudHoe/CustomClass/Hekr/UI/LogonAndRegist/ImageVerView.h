//
//  ImageVerView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/8/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageVerViewDelegate <NSObject>

- (void)getSMS:(NSString *)captchaToken;

@end

@interface ImageVerView : UIView
@property (nonatomic, weak)id<ImageVerViewDelegate>delegate;
@end
