//
//  GroupView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/5/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesModel.h"

@protocol GroupViewDelegate <NSObject>

- (void)groupMainOut:(UITapGestureRecognizer *)tgr;
- (void)groupDelets:(UIButton *)sender;
- (void)groupStaViewMove;
- (void)groupJumpTo:(NSURL *)url devData:(NSDictionary *)data;
- (void)groupAlertView;
- (void)groupdidSelectDeleteAction:(NSIndexPath *)idx;
- (void)groupRenameFail;
@end

@interface GroupView : UIView

@property (nonatomic, weak)id <GroupViewDelegate>delegate;

@property (nonatomic,strong) GroupModel *groupmodel;

@property (nonatomic, strong)UICollectionView *groupcollection;

@property (nonatomic, assign)BOOL isReload;

@property (nonatomic, assign)BOOL isCellAnimate;

@property (nonatomic, strong)UITextField *groupname;

- (instancetype)initWithFrame:(CGRect)frame Data:(HekrFold *)data GroupModel:(GroupModel *)groupmodel lanDevices:(NSArray *)lanDevices;

@end
