//
//  HomeDevicesLayout.h
//  HekrSDKAPP
//
//  Created by Mike on 16/2/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MergeAbleDataSource <UICollectionViewDataSource>
-(void) didMergeItem:(NSIndexPath*) index withItem:(NSIndexPath*) toIndex block:(void(^)(NSDictionary* ))block;
-(BOOL) canMergeItem:(NSIndexPath*) index withItem:(NSIndexPath*) toIndex;
-(BOOL) canMergeItem:(NSIndexPath*) index;
-(UIView*) contentView;
-(BOOL) isGroup;
-(BOOL) isReload;
- (void)didSelectDeleteAction:(NSIndexPath*)idx;
- (void)vibrationAction;
- (void)LongPressGestureAnimate;
@end

@interface SplitLineLayout : UICollectionViewFlowLayout

@end

@interface HomeDevicesLayout : SplitLineLayout
@property (nonatomic,assign) BOOL hideHeader;
@end
