 //
//  HomeDevicesLayout.m
//  HekrSDKAPP
//
//  Created by Mike on 16/2/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "HomeDevicesLayout.h"
#import "HomeDeviceCells.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#ifndef CGGEOMETRY_LXSUPPORT_H_
CG_INLINE CGPoint
LXS_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif


@interface CADisplayLink (LX_userInfo)
@property (nonatomic, copy) NSDictionary *userInfo;
@end

@implementation CADisplayLink (LX_userInfo)
- (void) setUserInfo:(NSDictionary *) userInfo {
    objc_setAssociatedObject(self, "LX_userInfo", userInfo, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *) userInfo {
    return objc_getAssociatedObject(self, "LX_userInfo");
}
@end

static NSString * const kLXCollectionViewKeyPath = @"collectionView";

static NSString * const VLineViewKind = @"vline";
static NSString * const HLineViewKind = @"hline";

@implementation SplitLineLayout
- (id)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:kLXCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:kLXCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(void) dealloc{
    [self removeObserver:self forKeyPath:kLXCollectionViewKeyPath];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kLXCollectionViewKeyPath]) {
        if (self.collectionView != nil) {
            [self setupCollectionView];
        }else{
            [self cleanCollectionView];
        };
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void) prepareLayout{
    [super prepareLayout];
    CGSize size = self.collectionView.frame.size;
    CGSize itemSize = size;
    itemSize.width = itemSize.width - self.sectionInset.left - self.sectionInset.right;
    itemSize.width = (itemSize.width - 2) / 3;
    itemSize.height = itemSize.width;
    self.itemSize = itemSize;
    self.minimumInteritemSpacing = .5;
    self.minimumLineSpacing = .5;
    
    [self registerClass:[HDeviceLineView class] forDecorationViewOfKind:HLineViewKind];
    [self registerClass:[VDeviceLineView class] forDecorationViewOfKind:VLineViewKind];
}
- (void)setupCollectionView {
//    [self.collectionView registerClass:[HDeviceLineView class] forSupplementaryViewOfKind:HLineViewKind withReuseIdentifier:HLineViewKind];
//    [self.collectionView registerClass:[VDeviceLineView class] forSupplementaryViewOfKind:VLineViewKind withReuseIdentifier:VLineViewKind];
}
- (void) cleanCollectionView{
    
}
- (NSArray *)lineLayoutAttributesFor:(UICollectionViewLayoutAttributes*)layoutAttributes {
    CGRect itemRect = layoutAttributes.frame;
    
    UICollectionViewLayoutAttributes * hline = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:HLineViewKind withIndexPath:layoutAttributes.indexPath];
    hline.frame = CGRectMake(CGRectGetMinX(itemRect), CGRectGetMaxY(itemRect), CGRectGetWidth(itemRect), 0.5f);
    
    UICollectionViewLayoutAttributes * vline = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:VLineViewKind withIndexPath:layoutAttributes.indexPath];
    vline.frame = CGRectMake(CGRectGetMaxX(itemRect), CGRectGetMinY(itemRect), 0.5f, CGRectGetHeight(itemRect));
    
    return @[hline,vline];
}
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableArray * lines = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *itemAttributes in attributes) {
        if (itemAttributes.representedElementKind==UICollectionElementCategoryCell){
            [lines addObjectsFromArray:[self lineLayoutAttributesFor:itemAttributes]];
        }
    }
    return [attributes arrayByAddingObjectsFromArray:lines];
}
- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    CGRect itemRect = CGRectZero;
    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
       
    }else{
        UICollectionViewLayoutAttributes * layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        itemRect = layoutAttributes.frame;
    }   
    
    if ([elementKind isEqualToString:HLineViewKind]) {
        UICollectionViewLayoutAttributes * hline = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:HLineViewKind withIndexPath:indexPath];
        hline.frame = CGRectMake(CGRectGetMinX(itemRect), CGRectGetMaxY(itemRect), CGRectGetWidth(itemRect), 0.5f);
        return hline;
    }else{
        UICollectionViewLayoutAttributes * vline = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:VLineViewKind withIndexPath:indexPath];
        vline.frame = CGRectMake(CGRectGetMaxX(itemRect), CGRectGetMinY(itemRect), 0.5f, CGRectGetHeight(itemRect));
        return vline;
    }
    return nil;
}

@end


@interface HomeDevicesLayout ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (strong, nonatomic) UILongPressGestureRecognizer* longPressGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property (assign, nonatomic) CGFloat scrollingSpeed;
@property (assign, nonatomic) UIEdgeInsets scrollingTriggerEdgeInsets;
@property (strong, nonatomic) CADisplayLink* displayLink;
@end

static NSString * const kLXScrollingDirectionKey = @"LXScrollingDirection";




typedef NS_ENUM(NSInteger, LXScrollingDirection) {
    LXScrollingDirectionUnknown = 0,
    LXScrollingDirectionUp,
    LXScrollingDirectionDown,
    LXScrollingDirectionLeft,
    LXScrollingDirectionRight
};

@implementation HomeDevicesLayout
- (id)init {
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}
-(void) dealloc{
    [self invalidatesScrollTimer];
    [self tearDownCollectionView];
}
- (void)setDefaults {
    _scrollingSpeed = 300.0f;
    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
}

- (void)setupCollectionView {
    [super setupCollectionView];
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    _longPressGestureRecognizer.delegate = self;
    
    // Links the default long press gesture recognizer to the custom long press gesture recognizer we are creating now
    // by enforcing failure dependency so that they doesn't clash.
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handlePanGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
    
    // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name: UIApplicationWillResignActiveNotification object:nil];
}
-(void) cleanCollectionView{
    [self invalidatesScrollTimer];
    [self tearDownCollectionView];
}
- (void)tearDownCollectionView {
    // Tear down long press gesture
    if (_longPressGestureRecognizer) {
        UIView *view = _longPressGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer.delegate = nil;
        _longPressGestureRecognizer = nil;
    }
    
    // Tear down pan gesture
    if (_panGestureRecognizer) {
        UIView *view = _panGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer.delegate = nil;
        _panGestureRecognizer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)invalidatesScrollTimer {
    if (!self.displayLink.paused) {
        [self.displayLink invalidate];
    }
    self.displayLink = nil;
}

- (void)setupScrollTimerInDirection:(LXScrollingDirection)direction {
    if (!self.displayLink.paused) {
        LXScrollingDirection oldDirection = [self.displayLink.userInfo[kLXScrollingDirectionKey] integerValue];
        
        if (direction == oldDirection) {
            return;
        }
    }
    
    [self invalidatesScrollTimer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
    self.displayLink.userInfo = @{ kLXScrollingDirectionKey : @(direction) };
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)handleScroll:(CADisplayLink *)displayLink {
    LXScrollingDirection direction = (LXScrollingDirection)[displayLink.userInfo[kLXScrollingDirectionKey] integerValue];
    if (direction == LXScrollingDirectionUnknown) {
        return;
    }
    
    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGFloat distance = rint(self.scrollingSpeed * displayLink.duration);
    CGPoint translation = CGPointZero;
    
    switch(direction) {
        case LXScrollingDirectionUp: {
            distance = -distance;
            CGFloat minY = 0.0f - contentInset.top;
            
            if ((contentOffset.y + distance) <= minY) {
                distance = -contentOffset.y - contentInset.top;
            }
            
            translation = CGPointMake(0.0f, distance);
        } break;
        case LXScrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;
            
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            
            translation = CGPointMake(0.0f, distance);
        } break;
        case LXScrollingDirectionLeft: {
            distance = -distance;
            CGFloat minX = 0.0f - contentInset.left;
            
            if ((contentOffset.x + distance) <= minX) {
                distance = -contentOffset.x - contentInset.left;
            }
            
            translation = CGPointMake(distance, 0.0f);
        } break;
        case LXScrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width + contentInset.right;
            
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            
            translation = CGPointMake(distance, 0.0f);
        } break;
        default: {
            // Do nothing...
        } break;
    }
    
    self.currentViewCenter = LXS_CGPointAdd(self.currentViewCenter, translation);
    self.currentView.center = [self.currentView.superview convertPoint:LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView) fromView:self.collectionView];
    self.collectionView.contentOffset = LXS_CGPointAdd(contentOffset, translation);
}

-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
-(void) prepareLayout{
    [super prepareLayout];
}
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *itemAttributes in attributes) {
        if (itemAttributes.representedElementKind==UICollectionElementKindSectionHeader) {
            UICollectionViewLayoutAttributes *headerAttributes = itemAttributes;
            CGPoint contentOffset = self.collectionView.contentOffset;
            if (contentOffset.y > 0) {
                CGPoint originInCollectionView=CGPointMake(headerAttributes.frame.origin.x-contentOffset.x, headerAttributes.frame.origin.y-contentOffset.y);
                originInCollectionView.y-=self.collectionView.contentInset.top;
                
                CGRect frame = headerAttributes.frame;
                if (originInCollectionView.y<0) {
                    frame.origin.y+=(originInCollectionView.y*-1);
                }
                // set header right att
//                CGFloat section1height;
//                if (itemAttributes.indexPath.section == 0) {
//                    section1height = frame.size.height;
//                }else{
//                    contentOffset.y += section1height;
//                }

                headerAttributes.frame = CGRectMake(frame.origin.x, contentOffset.y, frame.size.width, frame.size.height);
//                headerAttributes.alpha = 1.0f;
            }else{
//                    headerAttributes.alpha = MAX(0,(contentOffset.y + headerAttributes.frame.size.height)) / headerAttributes.frame.size.height;
                
//                    headerAttributes.alpha = 1.0f;
            }
            headerAttributes.zIndex = 1024;
            headerAttributes.hidden = self.hideHeader;
        }else if (itemAttributes.representedElementKind==UICollectionElementCategoryCell){
            if ([itemAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
                itemAttributes.hidden = YES;
            }
        }
    }
    return attributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* itemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if ([itemAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
        itemAttributes.hidden = YES;
    }
    return itemAttributes;
}
- (UICollectionViewLayoutAttributes*) layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewLayoutAttributes* itemAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//        if (indexPath.section == 0) {
        
            UICollectionViewLayoutAttributes *headerAttributes = itemAttributes;
            CGPoint contentOffset = self.collectionView.contentOffset;
            if (contentOffset.y > 0) {
                CGPoint originInCollectionView=CGPointMake(headerAttributes.frame.origin.x-contentOffset.x, headerAttributes.frame.origin.y-contentOffset.y);
                originInCollectionView.y-=self.collectionView.contentInset.top;
                
                CGRect frame = headerAttributes.frame;
                if (originInCollectionView.y<0) {
                    frame.origin.y+=(originInCollectionView.y*-1);
                }
                headerAttributes.frame = frame;
//                headerAttributes.alpha = 1.0f;
            }else{
//                headerAttributes.alpha = MAX(0,(contentOffset.y + headerAttributes.frame.size.height)) / headerAttributes.frame.size.height;
            }
            headerAttributes.zIndex = 1024;
            headerAttributes.hidden = self.hideHeader;
//        }
        
    }
    return itemAttributes;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return (self.selectedItemIndexPath != nil);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.longPressGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.panGestureRecognizer isEqual:otherGestureRecognizer];
    }
    
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.longPressGestureRecognizer isEqual:otherGestureRecognizer];
    }
    
    return NO;
}
-(void) handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
            
            if (![(id<MergeAbleDataSource>)self.collectionView.dataSource canMergeItem:currentIndexPath]) {
                return;
            }
            
            
            [(id<MergeAbleDataSource>)self.collectionView.dataSource vibrationAction];
            
            self.selectedItemIndexPath = currentIndexPath;
            
            UIView * contentView = [(id<MergeAbleDataSource>)self.collectionView.dataSource contentView];
            contentView = contentView ? contentView : self.collectionView;
            
            UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];
            
            CGRect rect = [contentView convertRect:collectionViewCell.frame fromView:self.collectionView];
            
            self.currentView = [[UIView alloc] initWithFrame:rect];
            
            collectionViewCell.highlighted = YES;
            UIView *highlightedImageView = [collectionViewCell snapshotViewAfterScreenUpdates:NO];
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            highlightedImageView.alpha = 1.0f;
            
            collectionViewCell.highlighted = NO;
            UIView *imageView = [collectionViewCell snapshotViewAfterScreenUpdates:NO];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.alpha = 0.0f;
            
            [self.currentView addSubview:imageView];
            [self.currentView addSubview:highlightedImageView];
            [contentView addSubview:self.currentView];
            
            self.currentViewCenter = [self.collectionView convertPoint:self.currentView.center fromView:contentView];
            
            __weak typeof(self) weakSelf = self;
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionBeginFromCurrentState
             animations:^{
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     strongSelf.currentView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                     highlightedImageView.alpha = 0.0f;
                     imageView.alpha = 0.9f;
                 }
             }
             completion:^(BOOL finished) {
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     [highlightedImageView removeFromSuperview];
                 }
             }];
            
            [self invalidateLayout];
        } break;
        case UIGestureRecognizerStateCancelled:
            
        case UIGestureRecognizerStateEnded: {
            __weak typeof(self) wself = self;
            
            CGPoint point = [self.currentView.superview convertPoint:self.currentView.center toView:self.collectionView];
            
            NSIndexPath *currentIndexPath = self.selectedItemIndexPath;
            NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            [(id<MergeAbleDataSource>)self.collectionView.dataSource didSelectDeleteAction:currentIndexPath];
            
            if (!CGRectContainsPoint(self.collectionView.bounds, point)) {
                newIndexPath = [NSIndexPath indexPathForItem:-1 inSection:-1];
            }
            
            if (newIndexPath && ![newIndexPath isEqual:currentIndexPath] && [(id<MergeAbleDataSource>)self.collectionView.dataSource canMergeItem:currentIndexPath withItem:newIndexPath]){
                
                
                
                [self.collectionView performBatchUpdates:^{
                    typeof(self) sself = wself;
                     [(id<MergeAbleDataSource>)sself.collectionView.dataSource didMergeItem:currentIndexPath withItem:newIndexPath block:^(NSDictionary *changes) {
                         typeof(self) ssself = wself;
                         if ([changes objectForKey:@(NSKeyValueChangeInsertion)]) {
                             [ssself.collectionView insertItemsAtIndexPaths:[changes objectForKey:@(NSKeyValueChangeInsertion)]];
                         }
                         if ([changes objectForKey:@(NSKeyValueChangeRemoval)]){
                             [ssself.collectionView deleteItemsAtIndexPaths:[changes objectForKey:@(NSKeyValueChangeRemoval)]];
                         }
                         if ([changes objectForKey:@(NSKeyValueChangeReplacement)]){
                             [ssself.collectionView reloadItemsAtIndexPaths:[changes objectForKey:@(NSKeyValueChangeReplacement)]];
                         }
                     }];
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if (currentIndexPath) {
                
                self.selectedItemIndexPath = nil;
                self.currentViewCenter = CGPointZero;
                
                if (newIndexPath.item == -1 && newIndexPath.section == -1) {
                    [self.currentView removeFromSuperview];
                    self.currentView = nil;
                    [self invalidateLayout];
                }else{
                    self.longPressGestureRecognizer.enabled = NO;
                    
                    UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:newIndexPath ? newIndexPath : currentIndexPath];
                    if ([(id<MergeAbleDataSource>)self.collectionView.dataSource isReload]) {
                        self.currentView.alpha = 0;
                    }
                    
                    __weak typeof(self) weakSelf = self;
                    [UIView
                     animateWithDuration:0.3
                     delay:0.0
                     options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         __strong typeof(self) strongSelf = weakSelf;
                         if (strongSelf) {
                             strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                             strongSelf.currentView.center = [self.currentView.superview convertPoint:layoutAttributes.center fromView:self.collectionView];
                         }
                     }
                     completion:^(BOOL finished) {
                         [(id<MergeAbleDataSource>)self.collectionView.dataSource LongPressGestureAnimate];
                         self.longPressGestureRecognizer.enabled = YES;
                         
                         __strong typeof(self) strongSelf = weakSelf;
                         if (strongSelf) {
                             [strongSelf.currentView removeFromSuperview];
                             strongSelf.currentView = nil;
                             [strongSelf invalidateLayout];
                         }
                     }];
                }
            }
        } break;
            
        default: break;
    }
    
}

-(void) handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            self.panTranslationInCollectionView = [gestureRecognizer translationInView:self.collectionView];
            CGPoint viewCenter = LXS_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
            self.currentView.center = [self.currentView.superview convertPoint:viewCenter fromView:self.collectionView];
            
            
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    if (viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
                        [self setupScrollTimerInDirection:LXScrollingDirectionUp];
                    } else {
                        if (viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
                            [self setupScrollTimerInDirection:LXScrollingDirectionDown];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
                case UICollectionViewScrollDirectionHorizontal: {
                    if (viewCenter.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.left)) {
                        [self setupScrollTimerInDirection:LXScrollingDirectionLeft];
                    } else {
                        if (viewCenter.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.right)) {
                            [self setupScrollTimerInDirection:LXScrollingDirectionRight];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
            }
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self invalidatesScrollTimer];
        } break;
        default: {
            // Do nothing...
        } break;
    }
}
-(void) handleApplicationWillResignActive:(id) sender{
    self.panGestureRecognizer.enabled = NO;
    self.panGestureRecognizer.enabled = YES;
    self.longPressGestureRecognizer.enabled = NO;
    self.longPressGestureRecognizer.enabled = YES;
}
@end
