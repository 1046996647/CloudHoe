//
//  HekrCacheManager.h
//  HekrSDKAPP
//
//  Created by 阎辉 on 2017/4/5.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HekrCacheManager : NSObject

+ (NSString*) cacheDirectory ;

+ (void) resetAllCache;

+ (void) resetCacheForFolderName:(NSString *)folderName;

+ (void) setObject:(NSData*)data forFolderName:(NSString *)folderName FileName:(NSString*)fileName;

+ (id) objectForFolderName:(NSString *)folderName FileName:(NSString*)fileName;

+ (id) objectExpiredForFolderName:(NSString *)folderName FileName:(NSString*)fileName;

+ (CGFloat)fileSize;

@end
