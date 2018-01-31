//
//  HekrCacheManager.m
//  HekrSDKAPP
//
//  Created by 阎辉 on 2017/4/5.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "HekrCacheManager.h"
#import <HekrAPI.h>

static NSTimeInterval cacheTime =  (double)86400;//缓存有效期 1 天（60*60*24）

@implementation HekrCacheManager

+ (void) resetAllCache {
    [[NSFileManager defaultManager] removeItemAtPath:[HekrCacheManager cacheDirectory] error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataCacheSize" object:nil];
}

+ (void) resetCacheForFolderName:(NSString *)folderName{
    [[NSFileManager defaultManager] removeItemAtPath:[self.cacheDirectory stringByAppendingPathComponent:folderName] error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataCacheSize" object:nil];
}

+ (NSString*) cacheDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *pathName = [[Hekr sharedInstance].user.uid stringByAppendingString:@"HekrCaches"];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:pathName];
    return cacheDirectory;
}

+ (id) objectForFolderName:(NSString *)folderName FileName:(NSString*)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self.cacheDirectory stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSData *data = [NSData dataWithContentsOfFile:filename];
        return data;
    }
    return nil;
}

+ (id) objectExpiredForFolderName:(NSString *)folderName FileName:(NSString*)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[self.cacheDirectory stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        NSTimeInterval date = [[NSDate date] timeIntervalSince1970] - [modificationDate timeIntervalSince1970];
        if (date > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            return data;
        }
    }
    return nil;
}

+ (void) setObject:(NSData*)data forFolderName:(NSString *)folderName FileName:(NSString*)fileName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filename = [[self.cacheDirectory stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:fileName];
        
        BOOL isDir = YES;
        if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
            [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if (![fileManager fileExistsAtPath:[self.cacheDirectory stringByAppendingPathComponent:folderName] isDirectory:&isDir]) {
            [fileManager createDirectoryAtPath:[self.cacheDirectory stringByAppendingPathComponent:folderName] withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        NSError *error;
        @try {
            [data writeToFile:filename options:NSDataWritingAtomic error:&error];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataCacheSize" object:nil];
        }
        @catch (NSException * e) {
            //TODO: error handling maybe
        }
    });
}


// 获取缓存大小
+ (CGFloat)fileSize {
    NSString *path = [self cacheDirectory];
    return [self folderSizeAtPath:path];
}
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
