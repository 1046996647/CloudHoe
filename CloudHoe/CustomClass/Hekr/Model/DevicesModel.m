 //
//  DevicesModel.m
//  HekrSDKAPP
//
//  Created by Mike on 16/2/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DevicesModel.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
#import "LoadWebViewObj.h"

@implementation HekrFold{
    NSMutableDictionary * devs;
}
//目录model
//返回目录
+(instancetype) foldWith:(NSDictionary*) dict{
    HekrFold * fold = [HekrFold new];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        fold.fid = [[dict objectForKey:@"folderId"] description];
        fold.name = [[dict objectForKey:@"folderName"] description];
    }
    return fold.fid.length > 0 ? fold : nil;
}

//返回装载目录的数组
+(NSArray*) foldsWith:(NSArray*) dicts{
    NSMutableArray * arr = [NSMutableArray array];
    for (id info in dicts) {
        HekrFold * fold = [self foldWith:info];
        if (fold) {
            [arr addObject:fold];
        }
    }
    return arr;
}
-(instancetype) init{
    self = [super init];
    if (self) {
        devs = [NSMutableDictionary dictionary];
    }
    return self;
}
-(NSArray*) devices{
    return [devs allValues];
}
-(NSUInteger) count{
    return devs.count;
}
-(void) addDevice:(HekrDevice*) dev{
    [devs setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
}
-(BOOL) removeDevice:(HekrDevice*) dev atIndex:(NSUInteger) index{
    NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
    if ([devs objectForKey:key]) {
        [devs removeObjectForKey:key];
        return YES;
    }
    return NO;
}
@end

@implementation HekrGroup{
    NSArray * tids;
    NSArray * devs;
}
+(instancetype) groupWith:(NSDictionary*) dict{
    HekrGroup * group = [HekrGroup new];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        group.gid = [[dict objectForKey:@"groupId"] description];
        group.name = [[dict objectForKey:@"groupName"] description];
        group->tids = [dict objectForKey:@"deviceList"];
    }
    return group.gid.length > 0 ? group : nil;
}

//返回装载目录的数组
+(NSArray*) groupsWith:(NSArray*) dicts{
    NSMutableArray * arr = [NSMutableArray array];
    for (id info in dicts) {
        HekrFold * group = [self groupWith:info];
        if (group) {
            [arr addObject:group];
        }
    }
    return arr;
}
-(NSUInteger) count{
    return tids.count;
}
-(NSArray*) devices{
    return devs;
}
-(void) matchDevices:(NSArray*) devices{
    NSMutableSet * set = [NSMutableSet set];
    for (id dev in tids) {
        [set addObject:[dev objectForKey:@"devTid"]];
    }
    devs = [devices filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HekrDevice* evaluatedObject, NSDictionary<NSString *,id> * bindings) {
        return [set containsObject:[evaluatedObject tid]];
    }]];
}
@end

@implementation HekrDevice
//独立设备和网关设备，操作是一样的就区分一下就好
+(instancetype) deviceWith:(NSDictionary*) dict devType:(HekrDeviceType )devType{
    HekrDevice * dev = [HekrDevice new];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        dev.tid = [dict objectForKey:@"devTid"];
        dev.ctrlKey = [dict objectForKey:@"ctrlKey"];
        dev.bindKey = [dict objectForKey:@"bindKey"];
        dev.online = [[dict objectForKey:@"online"] boolValue];
        dev.indTid = [dict objectForKey:@"devTid"];
        dev.devType = devType;
        if (devType==HekrDeviceTypeSolo) {
            dev.markKey = [NSString stringWithFormat:@"a-%@",[dict objectForKey:@"devTid"]];
        }
        else{
            dev.markKey = [NSString stringWithFormat:@"b-%@-",[dict objectForKey:@"devTid"]];
        }
        //确保deviceName字段不为空
        NSString *devName = dict[@"name"];
        NSMutableDictionary *d1= [NSMutableDictionary dictionaryWithDictionary:dict];
        if ([devName isKindOfClass:[NSNull class]] || [devName length]==0) {
            
            NSString *str = isEN() == YES ? dict[@"productName"][@"en_US"] : dict[@"productName"][@"zh_CN"];
            if (str.length <= 0) {
                str = isEN() == YES ? [[dict[@"categoryName"][@"en_US"] componentsSeparatedByString:@"/"] lastObject] : [[dict[@"categoryName"][@"zh_CN"] componentsSeparatedByString:@"/"] lastObject];
            }
            [d1 setObject:str forKey:@"name"];
        }
        [d1 removeObjectForKey:@"subDevices"];//网关删除子设备列表字段
        [d1 removeObjectForKey:@"timerMap"];//删除没用字段
        dev.props = d1;
    }
    return dev.tid ? dev : nil;
}

//子设备
+(instancetype) deviceSonWith:(NSDictionary*) dict gateInfo:(NSDictionary *)gateInfo{
    HekrDevice * dev = [HekrDevice new];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        dev.tid = [dict objectForKey:@"devTid"];
        dev.ctrlKey = [dict objectForKey:@"parentCtrlKey"];//取网关ctrlKey信息
        dev.bindKey = [dict objectForKey:@"bindKey"];
        dev.online = gateInfo == nil?[[dict objectForKey:@"online"] boolValue]:[[gateInfo objectForKey:@"online"] boolValue]?[[dict objectForKey:@"online"] boolValue]:[[gateInfo objectForKey:@"online"] boolValue];
        dev.indTid = [dict objectForKey:@"parentDevTid"];//取网关devTid信息
        
        dev.devType = HekrDeviceTypeAnnex;
        dev.markKey = [NSString stringWithFormat:@"b-%@-%@",[dict objectForKey:@"parentDevTid"],[dict objectForKey:@"devTid"]];
        
        //确保deviceName字段不为空
        NSString *devName = dict[@"name"];
        NSMutableDictionary *dInfo = [NSMutableDictionary dictionaryWithDictionary:gateInfo];
        [dInfo removeObjectForKey:@"folderId"];
        [dInfo addEntriesFromDictionary:dict];
        [dInfo setObject:@"SUB" forKey:@"devType"];
        if ([devName isKindOfClass:[NSNull class]] || [devName length]==0) {
            NSString *str = isEN() == YES ? dInfo[@"productName"][@"en_US"] : dInfo[@"productName"][@"zh_CN"];
            if (str.length <= 0) {
                str = isEN() == YES ? [[dInfo[@"categoryName"][@"en_US"] componentsSeparatedByString:@"/"] lastObject] : [[dInfo[@"categoryName"][@"zh_CN"] componentsSeparatedByString:@"/"] lastObject];
            }
            [dInfo setObject:!str?@"子设备":str forKey:@"name"];
        }
        else{
            [dInfo setObject:devName forKey:@"name"];
        }
        [dInfo removeObjectForKey:@"subDevices"];//网关删除子设备列表字段
        dev.props = dInfo;
    }
    return dev.tid ? dev : nil;
}

//返回装载目录的数组
+(NSArray*) devicesWith:(NSArray*) dicts DevicesModel:(DevicesModel *)model{
    NSMutableArray * arr = [NSMutableArray array];
    NSMutableDictionary *indDevs = [NSMutableDictionary dictionary];
    for (id info in dicts) {
        if ([[info objectForKey:@"devType"]isEqualToString:@"GATEWAY"]) {
            HekrDevice * dev = [self deviceWith:info devType:HekrDeviceTypeGateway];
            if (dev) {
                [arr addObject:dev];
            }
            if (!model) {
                NSArray *subDevList=[info objectForKey:@"subDevices"];
                NSMutableDictionary *dInfo = [NSMutableDictionary dictionaryWithDictionary:[info copy]];
                [dInfo removeObjectForKey:@"subDevices"];//网关删除子设备列表字段
                [dInfo removeObjectForKey:@"timerMap"];//删除没用字段
                for (id sub in subDevList) {
                    HekrDevice * dev = [self deviceSonWith:sub gateInfo:dInfo];
                    if (dev) {
                        [arr addObject:dev];
                    }
                }
            }
        }
        else if ([[info objectForKey:@"devType"]isEqualToString:@"SUB"]) {
            if (model) {
                HekrDevice *indDev = [indDevs objectForKey:[info objectForKey:@"parentDevTid"]];
                if (!indDev) {
                    indDev = [model findDeviceOfTid:[info objectForKey:@"parentDevTid"]];
                    [indDevs setObject:indDev forKey:[info objectForKey:@"parentDevTid"]];
                }
                HekrDevice * dev = [HekrDevice deviceSonWith:info gateInfo:indDev.props];
                if (dev) {
                    [arr addObject:dev];
                }
            }
            else{
                HekrDevice * dev = [self deviceSonWith:info gateInfo:nil];
                if (dev) {
                    [arr addObject:dev];
                }
            }
        }
        else{
            HekrDevice * dev = [self deviceWith:info devType:HekrDeviceTypeSolo];
            if (dev) {
                [arr addObject:dev];
            }
        }
    }
    return arr;
}
//返回装载字典目录
+(NSDictionary *) devicesCacheWith:(NSArray*) dicts{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    for (id info in dicts) {
//        [info setObject:@"0" forKey:@"online"];
        if ([[info objectForKey:@"devType"]isEqualToString:@"GATEWAY"]) {
            HekrDevice * dev = [self deviceWith:info devType:HekrDeviceTypeGateway];
            if (dev) {
                [dict setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
            }
            NSArray *subDevList=[info objectForKey:@"subDevices"];
            for (id sub in subDevList) {
                HekrDevice * dev = [self deviceSonWith:sub gateInfo:info];
                if (dev) {
                    [dict setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
                }
            }
        }
        else if ([[info objectForKey:@"devType"]isEqualToString:@"SUB"]) {
            HekrDevice * dev = [self deviceSonWith:info gateInfo:nil];
            if (dev) {
                [dict setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
            }
        }
        else{
            HekrDevice * dev = [self deviceWith:info devType:HekrDeviceTypeSolo];
            if (dev) {
                [dict setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
            }
        }
    }
    return dict;
}
@end


NSUInteger needPlacehode(NSUInteger count){
    return  (count % 3) == 0 ? 0 : (3 - (count % 3));
}
@implementation HekrPlacehode
+(NSArray*) placehodes:(NSUInteger) count{
    NSMutableArray * arr = [NSMutableArray array];
    for (NSUInteger i = 0; i< count; i++) {
        [arr addObject:[self new]];
    }
    return arr;
}
@end

#define DevicePageSize 20
@interface DevicesModel ()
- (void) groupRaiseDevices:(NSArray*) devs;
- (void) groupReduceDevices:(NSArray*) devs from:(HekrFold *)fold;
@end

@interface DevicesModel ()
@property (nonatomic,strong) NSMutableDictionary * tree;
@property (nonatomic,strong) NSArray * groupsCache;
-(void) moveOutDevice:(HekrDevice *)dev atIndex:(NSUInteger)index from:(HekrFold *)fold block:(void(^)(BOOL))block;
-(void) removeDevice:(HekrDevice *)dev atIndex:(NSUInteger)index from:(HekrFold *)fold block:(void(^)(BOOL))block;
@end

@implementation DevicesModel
//设备model
-(instancetype) init{
    self = [super init];
    if (self) {
        _tree = [NSMutableDictionary dictionary];
        _page = 0;
        _hasMore = YES;
        [self loadCache];
        [self reload];
    }
    return self;
}
-(instancetype) initTool{
    self = [super init];
    if (self) {
        _tree = [NSMutableDictionary dictionary];
        _page = 0;
        _hasMore = YES;
    }
    return self;
}
-(NSURL*) cacheURL{
    NSString* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSURL * url = [NSURL fileURLWithPath:path];
    return [url URLByAppendingPathComponent:@"devicesCache.dat"];
}
-(void) loadCache{
    NSDictionary *dictCache=[NSDictionary dictionaryWithContentsOfURL:[self cacheURL]];
    NSArray *arrAll=[dictCache objectForKey:@"allCache"];
    NSArray *arrType=[dictCache objectForKey:@"typeCache"];
    if (arrAll.count>0) {
        NSDictionary * devices = [HekrDevice devicesCacheWith:arrAll];
//        _count=devices.allValues.count;
        for (HekrDevice *dev in devices.allValues) {
            _count++;
            if (dev.online) {
                _online++;
            }
        }
        for (NSDictionary * item in arrType) {
            if ([[item objectForKey:@"HekrType"] isEqualToString:@"HekrDevice"]) {
                NSString * devKey=[item objectForKey:@"devKey"];
                HekrDevice *dev=[devices objectForKey:devKey];
                if (dev) {
                    [_tree setObject:dev forKey:item];
                }
            }
            else if ([[item objectForKey:@"HekrType"] isEqualToString:@"HekrFold"]){
                NSString * foldKey=[item objectForKey:@"foldKey"];
                NSArray *arr=[item objectForKey:@"devs"];
                for (id devKey in arr) {
                    if ([devKey isKindOfClass:[NSString class]]) {
                        HekrDevice *dev=[devices objectForKey:devKey];
                        if (dev) {
                            HekrFold* fold = [_tree objectForKey:foldKey];
                            if (!fold) {
                                fold = [HekrFold foldWith:item];
                                [_tree setObject:fold forKey:foldKey];
                            }
                            [fold addDevice:dev];
                        }
                    }
                }
            }
            else if ([[item objectForKey:@"HekrType"] isEqualToString:@"HekrGroup"]){
                NSArray *groups=[item objectForKey:@"groups"];
                _groupsCache=groups;
                NSArray * gps = [HekrGroup groupsWith:groups];
                NSArray * devs = [NSMutableArray arrayWithArray:devices.allValues];
                for (HekrGroup* g in gps) {
                    [g matchDevices:devs];
                    if (g.devices.count > 0) {
                        [_tree setObject:g forKey:[NSString stringWithFormat:@"grp--%@",[g gid]]];
                    }
                }
            }
        }
    }
    [[Hekr sharedInstance] onInsertDevices:arrAll];
    [self.delegate onLoad];
}
-(void) saveCache{
    NSMutableArray * arr = [NSMutableArray array];
    for (HekrDevice * dev in self.allDatas) {
        [arr addObject:dev.props];
    }
    NSMutableDictionary *dictCache=[NSMutableDictionary dictionary];
    [dictCache setObject:arr forKey:@"allCache"];
    
    BOOL ret = NO;
    
    NSMutableArray * arr1 = [NSMutableArray array];
    for (id key in _tree.allKeys) {
        id item = [_tree objectForKey:key];
        if ([item isKindOfClass:[HekrDevice class]]) {
            NSMutableDictionary * temp = [NSMutableDictionary dictionary];
            [temp setObject:@"HekrDevice" forKey:@"HekrType"];
            [temp setObject:[NSString stringWithFormat:@"dev--%@",[item tid]] forKey:@"devKey"];
            [arr1 addObject:temp];
        }else if ([item isKindOfClass:[HekrFold class]]){
            NSMutableDictionary * temp = [NSMutableDictionary dictionary];
            NSMutableArray *arrdevs=[NSMutableArray array];
            if ([item count]>0) {
                for (id dev in [item devices]) {
                    [arrdevs addObject:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
                }
                [temp setObject:@"HekrFold" forKey:@"HekrType"];
                [temp setObject:key forKey:@"foldKey"];
                [temp setObject:arrdevs forKey:@"devs"];
                [temp setObject:[item fid] forKey:@"folderId"];
                [temp setObject:[item name]?:@"" forKey:@"folderName"];
                [arr1 addObject:temp];
            }
        }
        else if ([item isKindOfClass:[HekrGroup class]]){
            ret = YES;
        }
    }
    if (ret) {
        NSMutableDictionary * temp = [NSMutableDictionary dictionary];
        [temp setObject:@"HekrGroup" forKey:@"HekrType"];
        [temp setObject:_groupsCache forKey:@"groups"];
        [arr1 addObject:temp];
    }
    [dictCache setObject:arr1 forKey:@"typeCache"];
    if ([dictCache writeToURL:[self cacheURL] atomically:YES]) {
        DDLogVerbose(@"file written");
    } else {
        DDLogVerbose(@"file NOT written");
    }
}

-(void) removeCache{
    [[NSFileManager defaultManager] removeItemAtURL:[self cacheURL] error:nil];
}
- (void)clearDevCache{
    _count = 0;
    _online = 0;
    [_tree removeAllObjects];
    [self removeCache];
    [self.delegate onLoad];
}
-(void) addDevices:(NSArray*) devs{
    for (HekrDevice * dev in devs) {
        NSString* foldId = [dev.props objectForKey:@"folderId"];
        if([foldId isKindOfClass:[NSNull class]]) foldId = nil;
        NSString * foldKey = ([foldId integerValue] > 0 || foldId.length > 1) ? [NSString stringWithFormat:@"fold--%@",foldId] : nil;
        if (!foldKey) {
            NSString *deviceKey = [NSString stringWithFormat:@"dev--%@",[dev tid]];
            [_tree setObject:dev forKey:deviceKey];

        }else{
            HekrFold* fold = [_tree objectForKey:foldKey];
            if (!fold) {
                fold = [HekrFold foldWith:dev.props];
                [_tree setObject:fold forKey:foldKey];
            }
            [fold addDevice:dev];
        }
    }
}

-(void) load:(NSUInteger) page{
    if (_loading) {
        return;
    }
    _loading = YES;
    
    
    __block NSArray * devices = nil;
    __block NSError * errorDevices = nil;
    NSInteger curPage = page;
    __block NSArray * groups = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user.openapi.hekr.me/device?" parameters:@{@"page":@(page),@"size":@(DevicePageSize)} progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            devices = responseObject;
//            DDLogVerbose(@"getDevice of success to count : %lu",(unsigned long)devices.count);
        }
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        DDLogVerbose(@"getDevice of error : %@",error);
        errorDevices = error;
        [self.delegate erroronLoad:error];
        dispatch_group_leave(group);
    }];
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user.openapi.hekr.me/group" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
//        DDLogVerbose(@"getGroup of success : %@",responseObject);
        if([responseObject isKindOfClass:[NSArray class]]){
            groups = responseObject;
        }
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DDLogVerbose(@"getGroup of error : %@",error);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (devices) {
            if (curPage == 0) {
                _count = 0;
                _online = 0;
                [self clearFolds:0 folds:@[]];
                [_tree removeAllObjects];
            }
            [[Hekr sharedInstance] onInsertDevices:devices page:curPage];
            NSArray * devs = [HekrDevice devicesWith:devices DevicesModel:nil];
            [self addDevices:devs];
            for (HekrDevice *dev in devs) {
                _count++;
//                NSAssert(!dev.online, @"asdasd");
                if (dev.online) {
                    _online++;
                }
            }
            _page =  curPage + 1;
            _hasMore = [devices count] >= DevicePageSize;
            [LoadWebViewObj loadRequsetWebView:devices];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadRequsetWebView" object:nil userInfo:@{@"devices":devices}];

        }
        else{
            if (errorDevices.code == NSURLErrorNotConnectedToInternet||errorDevices.code == NSURLErrorTimedOut) {
                NSArray *devs=[self allDatas];
                for (HekrDevice *dev in devs) {
                    dev.online=NO;
                }
                _online=0;
            }
        }
        _groupsCache = [NSArray arrayWithArray:groups];
        if(groups){
            NSArray * gps = [HekrGroup groupsWith:groups];
            NSArray * devs = [self allDatas];
            for (HekrGroup* g in gps) {
                [g matchDevices:devs];
                if (g.devices.count > 0) {
                    [_tree setObject:g forKey:[NSString stringWithFormat:@"grp--%@",[g gid]]];
                }
            }
        }
        _loading = NO;
        if (devices) {
            [self saveCache];
        }
        [self.delegate onLoad];
    });
}
-(NSArray*) aligin:(NSArray*) arr{
    return  [arr arrayByAddingObjectsFromArray:[HekrPlacehode placehodes:needPlacehode(arr.count)]];
}
-(void) clearFolds:(NSUInteger) page folds:(NSArray*) arr{
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user.openapi.hekr.me/folder" parameters:@{@"page":@(page),@"size":@(20)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] >= 20) {
            [self clearFolds:page + 1 folds:[arr arrayByAddingObjectsFromArray:responseObject]];
        }else{
            for (id fold in [arr arrayByAddingObjectsFromArray:responseObject]) {
                NSString * fid = [fold objectForKey:@"folderId"];
                NSArray * devs = [fold objectForKey:@"devTidList"];
                if (fid && [fid length] > 1 && devs && devs.count == 0) {
                    DDLogVerbose(@"clean fold:%@",fid);
                    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:[NSString stringWithFormat:@"http://user.openapi.hekr.me/folder/%@",fid] parameters:nil success:nil failure:nil];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void) reload{
//    _online = 0;
//    _count = 0;如果没有网络或者没有加载出数据情况下显示会出错
    [self load:0];
}
-(void) loadMore{
    if(_hasMore)
        [self load:_page];
}
-(NSArray*) datas{
    NSArray *arr=[[_tree allValues] copy];
//    arr = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        HekrDevice *dev=(HekrDevice *)evaluatedObject;
//        if ([dev isKindOfClass:[HekrDevice class]]) {
//            if (dev.devType==HekrDeviceTypeGateway) {
//                return NO;
//            }
//        }
//        return YES;
//    }]];
    
    return [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSString * key1 = [obj1 isKindOfClass:[HekrDevice class]] ? [NSString stringWithFormat:@"b-%@",[obj1 tid]] : [NSString stringWithFormat:@"a-%@",[obj1 fid]];
        
        NSString * key1 = [obj1 isKindOfClass:[HekrDevice class]] ? [NSString stringWithFormat:@"c-%@",[obj1 tid]] : [obj1 isKindOfClass:[HekrFold class]] ? [NSString stringWithFormat:@"a-%@",[obj1 fid]] : [NSString stringWithFormat:@"b-%@",[obj1 gid]];
        
        
//        NSString * key2 = [obj2 isKindOfClass:[HekrDevice class]] ? [NSString stringWithFormat:@"b-%@",[obj2 tid]] : [NSString stringWithFormat:@"a-%@",[obj2 fid]];
        NSString * key2 = [obj2 isKindOfClass:[HekrDevice class]] ? [NSString stringWithFormat:@"c-%@",[obj2 tid]] : [obj2 isKindOfClass:[HekrFold class]] ? [NSString stringWithFormat:@"a-%@",[obj2 fid]] : [NSString stringWithFormat:@"b-%@",[obj2 gid]];
        
        return [key1 compare:key2];
    }];
}
-(NSArray*) allDatas{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (id item in _tree.allValues) {
        if ([item isKindOfClass:[HekrDevice class]]) {
            [dict setObject:item forKey:[item tid]];
        }else if ([item isKindOfClass:[HekrFold class]]){
            for (id dev in [item devices]) {
                [dict setObject:dev forKey:[dev tid]];
            }
        }
    }
    return [[dict allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 markKey] compare:[obj2 markKey]];
    }];
}

- (HekrDevice *)configAddDevices:(id)info{
    HekrDevice * dev = nil;
    if ([[info objectForKey:@"devType"] isEqualToString:@"GATEWAY"]) {
        dev = [HekrDevice deviceWith:info devType:HekrDeviceTypeGateway];
        NSString *deviceKey = [NSString stringWithFormat:@"dev--%@",dev.tid];
        [_tree setObject:dev forKey:deviceKey];
        NSArray *subDevList=[info objectForKey:@"subDevices"];
        for (id sub in subDevList) {
            HekrDevice * dev = [HekrDevice deviceSonWith:sub gateInfo:info];
            NSString *deviceKey = [NSString stringWithFormat:@"dev--%@",dev.tid];
            [_tree setObject:dev forKey:deviceKey];
            _count++;
            if (dev.online) {
                _online++;
            }
        }
        _count++;
        if (dev.online) {
            _online++;
        }
    }
    else{
        dev = [HekrDevice deviceWith:info devType:HekrDeviceTypeSolo];
        NSString *deviceKey = [NSString stringWithFormat:@"dev--%@",dev.tid];
        [_tree setObject:dev forKey:deviceKey];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [[Hekr sharedInstance] onInsertDevices:@[info]];
        });
        _count++;
        if (dev.online) {
            _online++;
        }
    }
    return dev;
}

- (HekrDevice *)findDeviceOfTid:(NSString *)tid{
    HekrDevice *dev = [_tree objectForKey:[NSString stringWithFormat:@"dev--%@",tid]];
    if (dev) {return dev;}
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (id item in _tree.allValues) {
        if ([item isKindOfClass:[HekrFold class]]){
            for (id dev in [item devices]) {
                [dict setObject:dev forKey:[dev tid]];
                if ((HekrDevice *)[dict objectForKey:tid]) {
                    return (HekrDevice *)[dict objectForKey:tid];
                }
            }
        }
    }
    return nil;
}

//删除设备
- (void) removeDevice:(HekrDevice*) dev block:(void(^)(BOOL))block{
    NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
    if (dev.devType==HekrDeviceTypeSolo||dev.devType==HekrDeviceTypeGateway) {
        id url=nil;
        id parameters=nil;
        if ([dev.props[@"ownerUid"] isEqualToString:[Hekr sharedInstance].user.uid]) {
            url=[NSString stringWithFormat:@"http://user.openapi.hekr.me/device/%@",dev.tid];
            parameters=@{@"bindKey":dev.bindKey};
        }
        else{
            url=[NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization?grantor=%@&ctrlKey=%@&grantee=%@&devTid=%@",dev.props[@"ownerUid"],dev.ctrlKey,[Hekr sharedInstance].user.uid,dev.tid];
        }
        [self delDev:dev url:url parameters:parameters key:key block:block];
    }
    else{
        if (![dev.props[@"ownerUid"] isEqualToString:[Hekr sharedInstance].user.uid]) {
            //这个是不支持删除授权的子设备
            UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", nil) withMessage:NSLocalizedString(@"被授权的网关子设备不能删除", nil)];
            [alert SH_addButtonCancelWithTitle:NSLocalizedString(@"知道了",nil) withBlock:nil];
            [alert show];
            
            
            
            return;
        }
        id json = @{@"action":@"devDelete",
                    @"msgId":@"0",
                    @"params":@{@"devTid":dev.indTid,
                                @"ctrlKey":dev.ctrlKey,
                                @"appTid":@"",
                                @"subDevTid":dev.tid}};
        
        [self sendRemoveNet:dev json:json devTid:dev.tid key:key isLoop:YES block:block];
    }
}

- (void) removeDeviceFinish:(HekrDevice *)dev response:(id)response key:(NSString *)key{
    DDLogDebug(@"%@ 成功：%@",[self findForDeviceType:dev.devType],response);
    
//    [self countReduceDevices:dev];
//    [_tree removeObjectForKey:key];
//    [self saveCacheAndOnLoad];
    if (dev.devType == HekrDeviceTypeGateway&&![dev.props[@"ownerUid"] isEqualToString:[Hekr sharedInstance].user.uid]) {
        double delayInSeconds = 0.5;
        __weak typeof(self) wself = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [wself reload];
        });
    }
//    else if (dev.devType == HekrDeviceTypeAnnex){
//        double delayInSeconds = 1.0;
//        __weak typeof(self) wself = self;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [wself reload];
//            [wself countReduceDevices:dev];
//            [wself.tree removeObjectForKey:key];
//            [wself saveCacheAndOnLoad];
//        });
//    }
    else{
        [self countReduceDevices:dev];
        [_tree removeObjectForKey:key];
        [self saveCacheAndOnLoad];
    }
    [[Hekr sharedInstance] onDelDevices:dev.props];
}

-(NSString *) findForDeviceType:(HekrDeviceType) type {
    switch (type) {
        case HekrDeviceTypeSolo:
            return @"独立设备";
        case HekrDeviceTypeGateway:
            return @"网关设备";
        case HekrDeviceTypeAnnex:
            return @"子设备";
        default:
            break;
    }
    return nil;
}
-(void)sendRemoveNet:(HekrDevice*) dev json:(id)json devTid:(id)devTid key:(NSString *)key isLoop:(BOOL )isLoop block:(void(^)(BOOL))block{
    if (!json) {
        return;
    }
    __weak typeof(self) wself = self;
    [[Hekr sharedInstance] sendNet:json to:devTid  timeout:20 callback:^(id responseObject, NSError *error) {
        typeof(self) sself = wself;
        if (responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]==200) {
                [sself removeDeviceFinish:dev response:responseObject key:key];
                block==NULL?:block(YES);
            }
            else{
                block==NULL?:block(NO);
            }
        }
        else{
            if (isLoop) {
                [sself checkDevExist:dev json:json devTid:dev.tid key:key block:block];
            }
            else{
               block==NULL?:block(NO);
            }
        }
    }];
}

-(void)checkDevExist:(HekrDevice*) dev json:(id)json devTid:(id)devTid key:(NSString *)key block:(void(^)(BOOL))block{
    __weak typeof(self) wself = self;
    __weak typeof(dev) wdev = dev;
    NSString *url = [NSString stringWithFormat:@"http://user.openapi.hekr.me/device?devTid=%@",[dev indTid]];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        typeof(self) sself = wself;
        typeof(dev) sdev = wdev;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject;
            DDLogDebug(@"[get dev] responseObject is NSArray : %@  count : %ld",arr,[arr count]);
            if ([responseObject count]>0) {
                NSDictionary *d1=arr.firstObject;
                if ([[d1 objectForKey:@"devTid"] isEqualToString:[sdev indTid]]) {
                    NSArray *subDevices = [d1 objectForKey:@"subDevices"];
                    subDevices = [subDevices filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                        typeof(dev) ssdev = sdev;
                        NSDictionary *d2=(NSDictionary *)evaluatedObject;
                        if ([[d2 objectForKey:@"devTid"] isEqualToString:ssdev.tid]) {
                            return YES;
                        }
                        return NO;
                    }]];
                    if ([subDevices count]>0) {
                        [sself sendRemoveNet:dev json:json devTid:dev.tid key:key isLoop:NO block:block];
                    }
                    else{
                        [sself removeDeviceFinish:dev response:responseObject key:key];
                        block==NULL?:block(YES);
                    }
                }
            }
            else{
                block==NULL?:block(NO);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block==NULL?:block(NO);
        DDLogDebug(@"[get error] : %@",APIError(error));
    }];
}

-(void)delDev:(HekrDevice*) dev url:(NSString *)url parameters:(id)parameters key:(NSString *)key block:(void(^)(BOOL))block{
    __weak typeof(self) wself = self;
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        typeof(self) sself = wself;
        [sself removeDeviceFinish:dev response:responseObject key:key];
        block==NULL?:block(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogError(@"%@",APIError(error));
        [wself.delegate erroronLoad:error];
        block==NULL?:block(NO);
    }];
    
}
-(void) moveOutDevice:(HekrDevice *)dev atIndex:(NSUInteger)index from:(HekrFold *)fold block:(void(^)(BOOL))block{
    NSString *url = nil;
    NSDictionary *para = nil;
    if (dev.devType == HekrDeviceTypeAnnex) {
        url = [NSString stringWithFormat:@"http://user.openapi.hekr.me/folder/%@/%@",fold.fid,dev.indTid];
        para = @{@"ctrlKey":dev.ctrlKey,@"subDevTid":dev.tid};
    }
    else{
        url = [NSString stringWithFormat:@"http://user.openapi.hekr.me/folder/%@/%@",fold.fid,dev.tid];
        para = @{@"ctrlKey":dev.ctrlKey};
    }
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:url parameters:para success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
        [_tree setObject:dev forKey:key];
        [fold removeDevice:dev atIndex:index];
        
        block(YES);
        
        DDLogDebug(@"[设备移出组建]：%@",responseObject);
        if (fold.count <= 0) {
            [self.delegate groupViewDismiss];
        }
        [self.delegate onLoad];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO);
    }];

}

-(void) removeDevice:(HekrDevice *)dev atIndex:(NSUInteger)index from:(HekrFold *)fold block:(void(^)(BOOL))block{
    __weak HekrFold *sfold=fold;
    [self removeDevice:dev block:^(BOOL isDel) {
        HekrFold *ffold=sfold;
        if (isDel) {
            [ffold removeDevice:dev atIndex:index];
            block(YES);
        }
        else{
            block(NO);
        }
    }];
}
- (void)deleteDevceAt:(NSInteger)idx onDone:(void(^)())onDone{
    HekrDevice * dev = [self.datas objectAtIndex:idx];
    if (dev.devType == HekrDeviceTypeAnnex && ![dev.props[@"ownerUid"] isEqualToString:[Hekr sharedInstance].user.uid]) {
        //由网关设备授权来的子设备，无法删除。
        onDone();
        return;
    }
    [self removeDevice:dev block:nil];
}
- (void)deleteDev:(HekrDevice *)dev{
//    NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
//    [_tree removeObjectForKey:key];
    [self removeDevice:dev block:nil];
}
//两个设备合并成组建
-(void) moveDevice:(HekrDevice*) dev toFold:(HekrFold*) fold{
    if (fold && dev) {
        [fold addDevice:dev];
        NSDictionary *para = nil;
        if (dev.devType == HekrDeviceTypeAnnex) {
            para = @{@"devTid":dev.indTid,@"ctrlKey":dev.ctrlKey,@"subDevTid":dev.tid};
        }
        else{
            para = @{@"devTid":dev.tid,@"ctrlKey":dev.ctrlKey};
        }
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"http://user.openapi.hekr.me/folder/%@",fold.fid] parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}
//设备移动 放入目录
-(void) moveDevice:(HekrDevice*) dev toFold:(HekrFold*) fold block:(void(^)(BOOL))block{
    if (fold && dev) {
        NSDictionary *para = nil;
        if (dev.devType == HekrDeviceTypeAnnex) {
            para = @{@"devTid":dev.indTid,@"ctrlKey":dev.ctrlKey,@"subDevTid":dev.tid};
        }
        else{
            para = @{@"devTid":dev.tid,@"ctrlKey":dev.ctrlKey};
        }
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"http://user.openapi.hekr.me/folder/%@",fold.fid] parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [fold addDevice:dev];
            block(YES);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(NO);
        }];
    }
}
//设备移动 放入目录
//-(NSDictionary*) meargeDeviceAt:(NSUInteger)dev1 withGroupAt:(NSUInteger)group{
//    HekrDevice* dev = [self.datas objectAtIndex:dev1];
//    HekrFold* fold = [self.datas objectAtIndex:group];
//    NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
//    if (dev && fold && [_tree objectForKey:key]) {
//        [_tree removeObjectForKey:key];
//        [self moveDevice:dev toFold:fold];
//        return @{@(NSKeyValueChangeRemoval):@[[NSIndexPath indexPathForItem:dev1 inSection:0]],
//                 @(NSKeyValueChangeReplacement):@[[NSIndexPath indexPathForItem:group inSection:0]]};
//    }
//    return nil;
//}
-(void) meargeDeviceAtGroup:(NSUInteger)device withGroupAt:(NSUInteger)group block:(void(^)(NSDictionary* ))block{
    HekrDevice* dev = [self.datas objectAtIndex:device];
    HekrFold* fold = [self.datas objectAtIndex:group];
    NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
    __weak typeof(self) wself = self;
    if (dev && fold && [_tree objectForKey:key]) {
        [self moveDevice:dev toFold:fold block:^(BOOL ret) {
            typeof(self) sself = wself;
            if (ret) {
                if ([sself.tree objectForKey:key]) {
                    [sself.tree removeObjectForKey:key];
                    block(@{@(NSKeyValueChangeRemoval):@[[NSIndexPath indexPathForItem:device inSection:0]],
                            @(NSKeyValueChangeReplacement):@[[NSIndexPath indexPathForItem:group inSection:0]]});
                    [sself saveCache];
                }
            }
            else
                block(nil);
        }];
    }
}

//两个设备组成新的目录 （新建目录）
-(void(^)(id,void(^block)(BOOL))) meargeDeviceAt:(NSUInteger) dev1 withDeviceAt:(NSUInteger) dev2{
    HekrDevice* obj1 = [self.datas objectAtIndex:dev1];
    HekrDevice* obj2 = [self.datas objectAtIndex:dev2];
    if (!(obj1 && obj2)) {
        return nil;
    }
    
    return ^(id name,void(^block)(BOOL)){
        if (name == nil) {
            return;
        }
        NSString *str = name;
        if (str.length >16) {
            block(NO);
            return;
        }
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://user.openapi.hekr.me/folder" parameters:@{@"folderName":name} progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
            HekrFold * fold = [HekrFold foldWith:responseObject];
            if (fold) {
                NSString * key1 = [NSString stringWithFormat:@"dev--%@",[obj1 tid]];
                NSString * key2 = [NSString stringWithFormat:@"dev--%@",[obj2 tid]];
                NSString * key = [NSString stringWithFormat:@"fold--%@",fold.fid];
                if ([_tree objectForKey:key1] && [_tree objectForKey:key2]) {
                    [self moveDevice:obj1 toFold:fold];
                    [_tree removeObjectForKey:key1];
                    
                    [self moveDevice:obj2 toFold:fold];
                    [_tree removeObjectForKey:key2];
                    
                    [_tree setObject:fold forKey:key];
                    [self saveCacheAndOnLoad];
                }
                block(YES);
            }else{
                block(NO);
            }
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            block(NO);
        }];
    };
}

- (void) groupRaiseDevices:(NSArray *) devs{
    for (HekrDevice * dev in devs) {
        _count++;
        if (dev.online) {
            _online++;
        }
        NSString* foldId = [dev.props objectForKey:@"folderId"];
        if([foldId isKindOfClass:[NSNull class]]) foldId = nil;
        NSString * foldKey = ([foldId integerValue] > 0 || foldId.length > 1) ? [NSString stringWithFormat:@"fold--%@",foldId] : nil;
        if (!foldKey) {
            NSString *deviceKey = [NSString stringWithFormat:@"dev--%@",[dev tid]];
            [_tree setObject:dev forKey:deviceKey];
            
        }else{
            HekrFold* fold = [_tree objectForKey:foldKey];
            if (!fold) {
                fold = [HekrFold foldWith:dev.props];
                [_tree setObject:fold forKey:foldKey];
            }
            [fold addDevice:dev];
        }
    }
    [self saveCacheAndOnLoad];
}
- (void) groupReduceDevices:(NSArray*) devs from:(HekrFold *)fold{
    for (HekrDevice * dev in devs) {
        [self countReduceDevices:dev];
        [fold removeDevice:dev atIndex:0];
    }
    [self saveCacheAndOnLoad];
}
- (void) countReduceDevices:(HekrDevice *) dev{
    _count--;
    if (dev.online) {
        _online--;
    }
}

-(void)saveCacheAndOnLoad{
    [self saveCache];
    [self.delegate onLoad];
}



@end

@interface GroupModel ()
@property (nonnull,strong) DevicesModel * base;
@property (nonnull,strong) NSMutableDictionary * tree;
@end
@implementation GroupModel
-(NSArray*) datas{
    return [[_tree allValues] sortedArrayUsingComparator:^NSComparisonResult(HekrDevice* obj1, HekrDevice* obj2) {
        return [obj1.tid compare:obj2.tid];
    }];
}
//目录

-(instancetype) initWithGroup:(HekrFold *)fold baseModel:(DevicesModel *)base{
    self = [super init];
    _base = base;
    if (self) {
        _page = 0;
        _hasMore = YES;
        _loading = NO;
        _group = fold;
        _tree = [NSMutableDictionary dictionary];
        for (HekrDevice * dev in fold.devices) {
            [_tree setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
        }
        [self loadData:fold.fid];
    }
    return self;
}

-(void) loadData:(NSString*) gid{
    if (_loading) return;
    _loading = YES;
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://user.openapi.hekr.me/device/%@",gid] parameters:@{@"folderId":gid,@"page":@(_page),@"size":@(DevicePageSize)} progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        
        NSArray * devs = [HekrDevice devicesWith:responseObject DevicesModel:_base];
//        [devs enumerateObjectsUsingBlock:^(HekrDevice *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            NSString *deviceKey = [NSString stringWithFormat:@"dev--%@",[obj tid]];
//            if(obj.online){
//                [_tree setObject:obj forKey:deviceKey];
//            }else{
//                if(![_tree.allKeys containsObject:deviceKey]){
//                    [_tree setObject:obj forKey:deviceKey];
//                }
//            }
//        }];
        
        NSMutableDictionary *dictsDevs=[NSMutableDictionary dictionary];
        for (HekrDevice * dev in devs) {
            [dictsDevs setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
        }
        NSArray *arr1=[[_tree allKeys] copy];
        NSArray *arr2=[[dictsDevs allKeys] copy];
        
        //判断组建内新旧数据，新数据是否有新设备
        NSPredicate * raisePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
        NSArray * filter1 = [arr2 filteredArrayUsingPredicate:raisePredicate];
        NSMutableArray *arrDevs=[NSMutableArray array];
        for (NSString *key in filter1) {
            [arrDevs addObject:[dictsDevs objectForKey:key]];
        }
        [_base groupRaiseDevices:arrDevs];
        
        //判断组建内新旧数据，旧设备是否有删除的设备
        NSPredicate * reducePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr2];
        NSArray * filter2 = [arr1 filteredArrayUsingPredicate:reducePredicate];
        arrDevs=[NSMutableArray array];
        for (NSString *key in filter2) {
            [arrDevs addObject:[_tree objectForKey:key]];
        }
        [_base groupReduceDevices:arrDevs from:_group];
        
        if (_page == 0) {
            [_tree removeAllObjects];
        }
        for (HekrDevice * dev in devs) {
            [_tree setObject:dev forKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
        }
        
        _page += 1;
        _hasMore = [responseObject count] >= DevicePageSize;
        _loading = NO;
        [self.delegate onLoad];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        _loading = NO;
        [self.delegate onLoad];
    }];
}

-(NSArray*) aligin:(NSArray*) arr{
    return  [arr arrayByAddingObjectsFromArray:[HekrPlacehode placehodes:needPlacehode(arr.count)]];
}
//移出目录
-(void) moveOutDevceAt:(NSUInteger)idx block:(void(^)(NSDictionary* ))block{
    __weak typeof(self) wself = self;
    HekrDevice * dev = [self.datas objectAtIndex:idx];
    NSString * key = [NSString stringWithFormat:@"dev--%@",[dev tid]];
    if (dev && [_tree objectForKey:key]) {
        [_base moveOutDevice:dev atIndex:idx from:self.group block:^(BOOL ret) {
            typeof(self) sself = wself;
            if (ret) {
                NSUInteger item=[sself.datas indexOfObject:[sself.tree objectForKey:key]];
                DDLogVerbose(@"%@在%@\n在数组中的位置:%lu",[sself.tree objectForKey:key],sself.datas,(unsigned long)item);
                if ([sself.tree objectForKey:key]) {
                    [sself.tree removeObjectForKey:key];
                    block(@{@(NSKeyValueChangeRemoval):@[[NSIndexPath indexPathForItem:item inSection:0]]});
                    [sself.base saveCache];
                }
            }
            else{
                block(nil);
            }
        }];
    }
}

//从目录中删除
- (void)deleteDevceAt:(NSInteger)idx onDone:(void(^)())onDone{
    HekrDevice * dev = [self.datas objectAtIndex:idx];
    if (dev.devType == HekrDeviceTypeAnnex && ![dev.props[@"ownerUid"] isEqualToString:[Hekr sharedInstance].user.uid]) {
        //由网关设备授权来的子设备，无法删除。
        onDone();
        return;
    }
    __weak typeof(self) wself = self;
    [_base removeDevice:dev atIndex:idx from:self.group block:^(BOOL isDel) {
        __strong typeof(self) sself = wself;
        if (isDel) {
            [sself.tree removeObjectForKey:[NSString stringWithFormat:@"dev--%@",[dev tid]]];
            if (dev.devType == HekrDeviceTypeGateway) {
                for (HekrDevice *sdev in [sself.tree allValues]) {
                    if ([sdev.indTid isEqualToString:dev.tid]) {
                        [sself.tree removeObjectForKey:[NSString stringWithFormat:@"dev--%@",[sdev tid]]];
                    }
                }
            }
            [sself.delegate onLoad];
        }
    }];
}
//修改目录名字
-(void) rename:(NSString *)name blok:(void (^)(BOOL))block{
    if (name.length > 0 && ![name isEqualToString:_group.name]) {
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"http://user.openapi.hekr.me/folder/%@",_group.fid] parameters:@{@"newFolderName":name} success:^(NSURLSessionDataTask * task, id responseObject) {
            _group.name = name;
            block(YES);
            [self.delegate onLoad];
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            block(NO);
            [self.delegate onLoad];
        }];
        
    }
}
@end

//NSString* controlPushURLForDevice(HekrDevice* sdev, NSString *type){
//    if (type) {
//        return [NSString stringWithFormat:@"%@?devTid=%@&ctrlKey=%@&ppk=%@&lang=%@&openType=push&pushnotify=1&notifydata=%@",[[sdev props] objectForKey:@"iosH5Page"],[sdev tid],[sdev ctrlKey],[sdev.props objectForKey:@"productPublicKey"],lang(),type];
//    }else{
//        return [NSString stringWithFormat:@"%@?devTid=%@&ctrlKey=%@&ppk=%@&lang=%@&openType=push&pushnotify=1",[[sdev props] objectForKey:@"iosH5Page"],[sdev tid],[sdev ctrlKey],[sdev.props objectForKey:@"productPublicKey"],lang()];
//    }
//}

NSString* controlURLForDevice(HekrDevice* sdev){
    if (sdev.devType == HekrDeviceTypeAnnex) {
        return [NSString stringWithFormat:@"%@?devTid=%@&ctrlKey=%@&ppk=%@&subDevTid=%@&lang=%@&openType=push",[[sdev props] objectForKey:@"iosH5Page"],[sdev indTid],[sdev ctrlKey],[sdev.props objectForKey:@"productPublicKey"],[sdev tid],lang()];
    }
    return [NSString stringWithFormat:@"%@?devTid=%@&ctrlKey=%@&ppk=%@&lang=%@&openType=push",[[sdev props] objectForKey:@"iosH5Page"],[sdev tid],[sdev ctrlKey],[sdev.props objectForKey:@"productPublicKey"],lang()];
}

NSString* controlPushURLForDevice(HekrDevice* sdev, NSString *type){
    if (type) {
        return [NSString stringWithFormat:@"%@&pushnotify=1&notifydata=%@",controlURLForDevice(sdev),type];
    }else{
        return controlURLForDevice(sdev);
    }
    
}
