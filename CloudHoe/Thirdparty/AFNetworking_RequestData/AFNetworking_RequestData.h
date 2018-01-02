//
//  AFNetworking_RequestData.h
//  AFNetworking_RequestData
//
//  Created by 余晋龙 on 2016/10/31.
//  Copyright © 2016年 余晋龙. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <AFNetworking.h>


typedef void(^Success)(id responseObject);
typedef void(^Failure)(NSError *error);
@interface AFNetworking_RequestData : NSObject
@property(nonatomic , copy) Success requestSuccess; //请求成功
@property(nonatomic , copy) Failure requestFailure; //请求失败

//注: 使用前  先倒入 第三方库“AFNetworking”  引入头文件AFNetworking.h

#pragma GET请求--------------
+(void)requestMethodGetUrl:(NSString*)url
                       dic:(NSMutableDictionary*)dic
                   showHUD:(BOOL)hud
                  response:(BOOL)response // 为了表视图加载更多数据时的回调
                    Succed:(Success)succed
                   failure:(Failure)failure;

#pragma POST请求--------------
+(void)requestMethodPOSTUrl:(NSString*)url
                        dic:(NSMutableDictionary*)dic
                    showHUD:(BOOL)hud
                   response:(BOOL)response
                     Succed:(Success)succed
                    failure:(Failure)failure;

#pragma 上传图片
+(void)uploadImageUrl:(NSString*)url
                  dic:(NSMutableDictionary*)dic
                 data:(NSData*)data
               Succed:(Success)succed
              failure:(Failure)failure;
@end
