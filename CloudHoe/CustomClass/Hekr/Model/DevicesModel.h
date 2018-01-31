//399915355
//  DevicesModel.h
//  HekrSDKAPP
//288585
//  Created by Mike on 16/2/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HekrSDK.h>
#import <HekrAPI.h>

@interface HekrFold : NSObject
@property (nonatomic,copy) NSString* fid;    //目录id
@property (nonatomic,readonly) NSUInteger count;  //目录内个数
@property (nonatomic,copy) NSString * name;     //目录名称
@property (nonatomic,readonly) NSArray * devices;
@end

@interface HekrGroup : NSObject
@property (nonatomic,copy) NSString* gid;
@property (nonatomic,readonly) NSUInteger count;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,readonly) NSArray * devices;
@end

typedef NS_ENUM(NSUInteger, HekrDeviceType) {
    HekrDeviceTypeSolo,         //独立设备
    HekrDeviceTypeGateway,      //网关设备
    HekrDeviceTypeAnnex,        //子设备
};
//独立设备,网关设备,子设备都归类为HekrDevice，增加HekrDeviceType进行区分

@interface HekrDevice : NSObject
@property (nonatomic,copy) NSString* tid;    //目录id
@property (nonatomic,copy) NSString* ctrlKey;  //目录内个数
@property (nonatomic,copy) NSString * bindKey;     //目录名称
@property (nonatomic,copy) NSString * markKey;     //判断顺序标志
@property (nonatomic,copy) NSString * indTid;     //独立设备Tid，即网关设备和独立设备
@property (nonatomic,assign) BOOL accredit;     //子设备专用，该子设备是否是子设备授权而来
@property (nonatomic,assign) BOOL online;
@property (nonatomic,strong) id props;
@property (nonatomic,assign) HekrDeviceType devType;

//+(instancetype) deviceWith:(NSDictionary*) dict devType:(HekrDeviceType ) devType;
//+(NSArray*) devicesWith:(NSArray*) dicts;
@end

@interface HekrPlacehode:NSObject

@end

@protocol ModelDelegate <NSObject>
-(void) onLoad;
-(void) erroronLoad:(NSError *)error;
@optional
-(void) groupViewDismiss;
@end

@interface DevicesModel : NSObject
@property (nonatomic,readonly) NSArray * datas;
@property (nonatomic,readonly) NSArray * allDatas;
@property (nonatomic,weak) id<ModelDelegate> delegate;

@property (nonatomic,assign,readonly) BOOL loading;
@property (nonatomic,assign,readonly) BOOL hasMore;

@property (nonatomic,assign,readonly) NSUInteger page;
@property (nonatomic,assign,readonly) NSUInteger count;
@property (nonatomic,assign,readonly) NSUInteger online;
@property (nonatomic,assign,readonly) NSUInteger authorized;
@property (nonatomic,assign,readonly) NSUInteger beAuthorized;

-(void) reload;
-(void) loadMore;
//两个设备组成新的目录 （新建目录）
-(void(^)(id,void(^block)(BOOL))) meargeDeviceAt:(NSUInteger) dev1 withDeviceAt:(NSUInteger) dev2;
//设备移动 放入目录
//-(NSDictionary*) meargeDeviceAt:(NSUInteger)dev1 withGroupAt:(NSUInteger)group;
-(void) meargeDeviceAtGroup:(NSUInteger)device withGroupAt:(NSUInteger)group block:(void(^)(NSDictionary* ))block;
//删除设备
- (void)deleteDevceAt:(NSInteger)idx onDone:(void(^)())onDone;
- (void)deleteDev:(HekrDevice *)dev;
- (void)clearDevCache;
- (HekrDevice *)configAddDevices:(id)info;
- (HekrDevice *)findDeviceOfTid:(NSString *)tid;
-(instancetype) initTool;

@end


@interface GroupModel : NSObject
@property (nonatomic,strong,readonly) NSArray * datas;
@property (nonatomic,strong,readonly) HekrFold* group;
@property (nonatomic,weak) id<ModelDelegate> delegate;
    
@property (nonatomic,assign,readonly) BOOL loading;
@property (nonatomic,assign,readonly) BOOL hasMore;
@property (nonatomic,assign,readonly) NSUInteger page;
@property (nonatomic,assign,readonly) NSUInteger count;

-(instancetype) initWithGroup:(HekrFold*) fold baseModel:(DevicesModel*) base;
//移出目录
-(void) moveOutDevceAt:(NSUInteger)idx block:(void(^)(NSDictionary* ))block;
//从目录中删除
- (void)deleteDevceAt:(NSInteger)idx onDone:(void(^)())onDone;

-(void) rename:(NSString*) name blok:(void(^)(BOOL isSuccess))block;
@end
NSString* controlPushURLForDevice(HekrDevice* sdev, NSString *type);
NSString* controlURLForDevice(HekrDevice* dev);
