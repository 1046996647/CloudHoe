//
//  PlayerView.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/5/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView
{
    AVPlayer *player;
    BOOL isStateEnd;
}
@property(nonatomic ,retain)AVPlayer *player;

-(instancetype) initWithFrame:(CGRect)frame pathForResource:(NSString *)resource ofType:(NSString *)type;
-(void)PlayerOfPlay;
-(void)PlayerOfPause;
-(BOOL)PlayerOfstate;

@end
