//
//  HomeDeviceCells.h
//  HekrSDKAPP
//
//  Created by Mike on 16/2/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@protocol CellData <NSObject>
-(void) update:(id) data isHekrGroup:(BOOL)isHekrgroup GroupName:(NSString *)groupName;
@end

@interface DeviceCell : UICollectionViewCell<CellData>
@property (nonatomic,weak) IBOutlet UIImageView * image;
@property (nonatomic,weak) IBOutlet UILabel * name;
@property (nonatomic,weak) IBOutlet UIImageView * power;
@property (nonatomic,weak) IBOutlet UILabel * powerText;
@property (nonatomic,weak) IBOutlet UIImageView * timer;
@property (nonatomic,weak) IBOutlet UIImageView * share;
@property (nonatomic,weak) IBOutlet UIImageView * update;
@property (nonatomic,weak) IBOutlet UIButton * moveout;
@property (weak, nonatomic) IBOutlet UIButton *deleteDev;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet UILabel *offLine;

@property (weak, nonatomic) IBOutlet UIView *hekrGroupView;
@property (weak, nonatomic) IBOutlet UILabel *hekrGroupCount;



@property (weak, nonatomic) IBOutlet FXBlurView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *deletedev;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint * fix;
@end



@interface GroupCell : UICollectionViewCell<CellData>
@property (nonatomic,weak) IBOutlet UIView * border;
@property (nonatomic,weak) IBOutlet UIView * countBorder;
@property (nonatomic,weak) IBOutlet UILabel * count;
@property (nonatomic,weak) IBOutlet UILabel * name;
@end

@interface DeviceStatisticsView : UICollectionReusableView
@property (nonatomic,assign) NSUInteger n_count;
@property (nonatomic,assign) NSUInteger n_online;
@property (nonatomic,assign) NSUInteger n_authorized;
@property (nonatomic,assign) NSUInteger n_beAuthorized;
@property (weak, nonatomic) IBOutlet UILabel *devStaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *devStaBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *onLineImg;


@end

@interface HDeviceLineView : UICollectionReusableView

@end
@interface VDeviceLineView : UICollectionReusableView

@end

@interface NameEditView : UICollectionReusableView
@property (nonatomic,weak) IBOutlet UITextField * textfield;
@end
