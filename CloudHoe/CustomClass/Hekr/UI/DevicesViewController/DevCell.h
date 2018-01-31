//
//  DevCell.h
//  HekrSDKAPP
//
//  Created by hekr on 16/5/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesModel.h"

@protocol DevDelete <NSObject>

- (void)deleteDev:(UIButton *)sender;

@end

@interface DevCell : UICollectionViewCell

-(void) update:(HekrDevice*)data isHekrGroup:(BOOL)isHekrgroup GroupName:(NSString *)groupName lanDevices:(NSArray *)lanDevices;
@property (nonatomic, weak)id<DevDelete>delegate;
@property (nonatomic, strong)UIView *imgBgView;
@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *online;
@property (nonatomic, strong)UIButton *devDelete;
@property (nonatomic, strong)UIImageView *hekrGroup;
@property (nonatomic, strong)UILabel *hekrGroupNum;


@end
