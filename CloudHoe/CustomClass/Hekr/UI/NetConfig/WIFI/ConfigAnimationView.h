//
//  ConfigAnimationView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/7/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfigAnimationDelegate <NSObject>
- (void)animationViewCancel;
- (void)animationViewWillConfig;
- (void)animationViewConfig;
- (void)animationViewsolve;
- (void)animationViewWillPop;
- (void)animationViewPop;
- (void)animationViewPrompt:(NSMutableArray *)array;
- (void)animationViewStop;
@end

@interface ConfigAnimationView : UIView
@property (nonatomic, weak) id <ConfigAnimationDelegate>delegata;
@property (nonatomic, assign) BOOL isHave;
@property (nonatomic, assign) BOOL isBackground;

- (instancetype)initWithFrame:(CGRect)frame isScan:(BOOL)isScan;
- (void)configFail;
- (void)configSuccess;
//- (void)configSearched:(NSMutableArray *)logoArray;
- (void)stopAnamation:(NSMutableArray *)logoArray;
- (void)cancelPreviousPer;
- (void)viewsRemoveFromSuperview;

@end
