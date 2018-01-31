//
//  ConfigAniProgressView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/1.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfigAniProgressViewDelegate <NSObject>

-(void)aniProgressTimerFunc;
-(void)aniProgressInterFunc;
@required
-(void)aniProgressStopConfig;
-(void)aniProgressEnd;

@end

@interface ConfigAniProgressView : UIView

@property (nonatomic, weak) id <ConfigAniProgressViewDelegate>delegate;
@property (nonatomic, assign) BOOL loading;

-(void)start;
-(void)stop;
-(void)fail:(NSString *)title;
-(void)success;

@end
