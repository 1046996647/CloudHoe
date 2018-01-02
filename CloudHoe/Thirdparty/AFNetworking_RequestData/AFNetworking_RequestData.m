//
//  AFNetworking_RequestData.m
//  AFNetworking_RequestData
//
//  Created by 余晋龙 on 2016/10/31.
//  Copyright © 2016年 余晋龙. All rights reserved.
//


#import "AFNetworking_RequestData.h"
#import "LoginVC.h"
#import "NavigationController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AFNetworking_RequestData


//默认网络请求时间
static const NSUInteger kDefaultTimeoutInterval = 20;

#pragma GET请求--------------
+(void)requestMethodGetUrl:(NSString*)url
                       dic:(NSMutableDictionary*)dic
                   showHUD:(BOOL)hud
                  response:(BOOL)response
                    Succed:(Success)succed
                   failure:(Failure)failure{
    //1.数据请求接口 2.请求方法 3.参数
    //请求成功   返回数据
    //请求失败   返回错误
    
    // 编码以防崩溃
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [AFNetworking_RequestData Manager:url Method:@"GET"  dic:dic showHUD:(BOOL)hud response:(BOOL)response requestSucced:^(id responseObject) {
        
        succed(responseObject);
        
    } requestfailure:^(NSError *error) {
        
        failure(error);

    }];
}
#pragma POST请求--------------
// 参数response：为表视图的加载更多数据提供回调
+(void)requestMethodPOSTUrl:(NSString*)url
                  dic:(NSMutableDictionary*)dic
              showHUD:(BOOL)hud
              response:(BOOL)response
               Succed:(Success)succed
              failure:(Failure)failure{
    
    // 编码以防崩溃
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [AFNetworking_RequestData Manager:url Method:@"POST"  dic:dic showHUD:hud response:(BOOL)response requestSucced:^(id responseObject) {
        
        succed(responseObject);
        
    } requestfailure:^(NSError *error) {
        
        failure(error);
    }];
}

//=====================
+(void)Manager:(NSString*)url Method:(NSString*)Method dic:(NSMutableDictionary*)dic showHUD:(BOOL)hud response:(BOOL)response requestSucced:(Success)Succed requestfailure:(Failure)failure
{
    
    if (hud) {
        [SVProgressHUD show];
    }
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kDefaultTimeoutInterval; //默认网络请求时间
     manager.responseSerializer = [AFJSONResponseSerializer serializer]; //申明返回的结果是json类型
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 用户信息不包含token
    PersonModel *person = [InfoCache unarchiveObjectWithFile:Person];
//    NSString *token = [InfoCache unarchiveObjectWithFile:@"token"];
//    NSString *userid = [InfoCache unarchiveObjectWithFile:@"userid"];
//    NSString *siteId = [InfoCache unarchiveObjectWithFile:@"siteId"];

    //======POST=====
    if ([Method isEqualToString:@"POST"]) {

        if (person) {
            [dic  setValue:person.Token forKey:@"Token"];
            [dic  setValue:person.userId forKey:@"userId"];
            
        }

//        if (token) {
//            [dic  setValue:token forKey:@"token"];
//            [dic  setValue:userid forKey:@"userid"];
//            [dic  setValue:siteId forKey:@"siteId"];
//
//        }
        
        NSLog(@"paramDic:%@",dic);


        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@",responseObject);

//            if (hud) {
//                [SVProgressHUD dismiss];
//            }
            
            
            [SVProgressHUD dismiss];

            NSNumber *code = [responseObject objectForKey:@"httpcode"];
            if (500 == [code integerValue] || 400 == [code integerValue]) {
                
                if (400 == [code integerValue]) {
                    
                    [InfoCache archiveObject:nil toFile:Person];
                    
                    [[UIApplication sharedApplication].keyWindow makeToast:@"账号异常，请重新登陆!"];
                    
                    AppDelegate *delegate = [AppDelegate share];
                    ViewController *vc = (ViewController *)delegate.window.rootViewController;
                    
                    NavigationController *navVC = (NavigationController *)vc.mainNav;

                    LoginVC *loginVC = [[LoginVC alloc] init];
                    [navVC pushViewController:loginVC animated:YES];

                    
                    return ;
                }
                else {
                    
                    NSString *message = [responseObject objectForKey:@"message"];
                    
                    if (message.length > 0) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:message];
                        
                    }
                }

                
                if (response) {
                    Succed(responseObject);
                    
                }
            }
            else {
                Succed(responseObject);

            }
            


            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (hud) {
                [SVProgressHUD dismiss];
            }
            
            if (![UIApplication sharedApplication].keyWindow.rootViewController.view.isShowing) {
                
                [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:@"网络异常!"];

            }
            NSLog(@"%@",error);

            failure(error);
            

        }];
        
        
    //=========GET======
    }else{
        
        [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (hud) {
                [SVProgressHUD dismiss];
            }
            
            Succed(responseObject);
            NSLog(@"%@",responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (hud) {
                [SVProgressHUD dismiss];
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:@"网络似乎已断开!"];

            failure(error);
            NSLog(@"%@",error);

        }];
    }
    
}

#pragma 上传图片

+(void)uploadImageUrl:(NSString*)url
                  dic:(NSMutableDictionary*)dic
                 data:(NSData *)data
               Succed:(Success)succed
              failure:(Failure)failure
{
    [AFNetworking_RequestData Manager:url dic:dic data:data requestSucced:^(id responseObject) {
        succed(responseObject);

    } requestfailure:^(NSError *error) {
        failure(error);
    }];

}

+(void)Manager:(NSString*)url  dic:(NSMutableDictionary*)dic data:(NSData *)data  requestSucced:(Success)Succed requestfailure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html", nil];
    
    //    PersonModel *person = [InfoCache unarchiveObjectWithFile:Person];
    NSString *token = [InfoCache unarchiveObjectWithFile:@"token"];
    NSString *userid = [InfoCache unarchiveObjectWithFile:@"userid"];
    
    [dic  setValue:userid forKey:@"userid"];
    [dic  setValue:token forKey:@"token"];
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
        
        NSLog(@"------%@",formData);
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@", responseObject);
        
        Succed(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败 %@", error);
    }];
    
}

@end
