//
//  PlayerView.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/5/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView
@synthesize player;

-(instancetype) initWithFrame:(CGRect)frame pathForResource:(NSString *)resource ofType:(NSString *)type{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self PlayerViewpathForResource:resource ofType:type];
    }
    return self;
}

-(void)PlayerViewpathForResource:(NSString *)resource ofType:(NSString *)type
{
    self.backgroundColor=[UIColor whiteColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.layer addSublayer:playerLayer];
    
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    isStateEnd=NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            

//            self.stateButton.enabled = YES;
//            CMTime duration = self.playerItem.duration;// 获取视频总长度
//            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
//
//            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));

        } else if ([playerItem status] == AVPlayerStatusFailed) {
            
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
    }
}

-(void)moviePlayDidEnd:(NSNotification *)sender
{
    isStateEnd=YES;
    [player pause];
    NSLog(@"moviePlayDidEnd");
}

-(void)PlayerOfPlay
{
    [player play];
}

-(void)PlayerOfPause
{
    
}

-(BOOL)PlayerOfstate
{
    return isStateEnd;
}

@end
