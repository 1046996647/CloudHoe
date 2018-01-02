//
//  InfoCache.m
//  Gas
//
//  Created by 张伟良 on 17/5/23.
//  Copyright © 2017年 HongHu. All rights reserved.
//

#import "InfoCache.h"

@implementation InfoCache

//------------------NSUserDefaults--------------------
+ (void)saveValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:value forKey:key];
    [userDefaultes synchronize];
}

+ (id)getValueForKey:(NSString *)key
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    id value = [userDefaultes objectForKey:key];
    return value;
}

//------------------archive/unarchive--------------------
+ (void)archiveObject:(id)obj toFile:(NSString *)path
{
    // 不要用NSHomeDirectory，不然失败
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    path = [stringPath stringByAppendingPathComponent:path];//添加储存的文件名
   BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:path];
    if (success) {
        NSLog(@"归档成功");
    }
    
}

+ (id)unarchiveObjectWithFile:(NSString *)path
{
    // 不要用NSHomeDirectory，不然失败
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    path = [stringPath stringByAppendingPathComponent:path];//添加储存的文件名
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
