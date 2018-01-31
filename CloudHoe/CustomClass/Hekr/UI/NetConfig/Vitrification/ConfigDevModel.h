//
//  ConfigDevModel.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/31.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HekrAPI.h>

@interface ConfigDevModel : NSObject

@property (nonatomic ,copy) NSString *tid;
@property (nonatomic ,assign) ConfigDeviceStep step;
@property (nonatomic ,assign) BOOL state;
@property (nonatomic ,assign) BOOL show;
@property (nonatomic ,strong) NSDictionary *data;

- (instancetype)initWithConfigDevModel:(NSDictionary *)data;

-(void)setConfigDevModel:(NSDictionary *)data;

+(BOOL)devContentState:(NSDictionary *)info;
+(NSString *)devFailReason:(NSDictionary *)info comeType:(BOOL)comeType;
+(NSString *)devFailResult:(NSDictionary *)info;

-(BOOL)changeCurrentState;

@end
