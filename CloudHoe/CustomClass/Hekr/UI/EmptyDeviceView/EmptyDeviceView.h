//
//  EmptyDeviceView.h
//  HekrSDKAPP
//
//  Created by Info on 16/2/26.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceTypeAirClear = 124,
    DeviceTypeLamp = 125,
    DeviceTypeCurtain = 126
};

@protocol EmptyDeviceDelegate <NSObject>

@optional
-(void)addEmptyDevice:(NSString *)h5Url;
@end

@interface EmptyDeviceView : UIView

@property(nonatomic, assign) id <EmptyDeviceDelegate> delegate;

- (void)viewLoad;


@end
