//
//  InfoCache.h
//  Gas
//
//  Created by 张伟良 on 17/5/23.
//  Copyright © 2017年 HongHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoCache : NSObject

//------------------NSUserDefaults--------------------
+ (void)saveValue:(id)value forKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key;


//------------------archive/unarchive--------------------
// 归档
+ (void)archiveObject:(id) obj toFile:(NSString *)path;

// 解档
+ (id)unarchiveObjectWithFile:(NSString *)path;

@end
