//
//  ConfigUnderView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/4.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HekrAPI.h>

@protocol ConfigUnderViewDelegate <NSObject>

@required

-(void)configFinish;
-(void)configRestart;
-(void)configSoftAP;

@end

@interface ConfigUnderView : UIView

@property (nonatomic, weak) id <ConfigUnderViewDelegate>delegate;

-(void)configUnderButtonReset;
-(void)configUnderButtonSuccess:(BOOL)success;
-(void)configUnderButtonFail;

@end
