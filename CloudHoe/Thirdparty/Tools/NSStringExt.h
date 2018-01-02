//
//  NSString+ArabicToChinese.h
//  Gas
//
//  Created by 张伟良 on 17/5/24.
//  Copyright © 2017年 HongHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ArabicToChinese)

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;

// 根据日期计算是星期几
+ (NSString *)dateToWeek:(NSString *)dateStr;

/**
 *  是否为同一月
 */
+ (NSString *)isSameMonth:(NSString*)dateStr;

// 公里计算
+ (NSString *)meterToKilometer:(NSString *)meterStr;

// 文本宽度
+ (CGSize)textLength:(NSString *)content font:(UIFont *)font;

// 文本高度
+ (CGSize)textHeight:(NSString *)content font:(UIFont *)font width:(NSInteger)width;


// 富文本
+ (NSMutableAttributedString *)text:(NSString *)text  fullText:(NSString *)fullText location:(NSInteger)location color:(UIColor *)color font:(UIFont *)font;

//在开发中我们经常需要判断一个时期是今天还是昨天，或者是之前的日子。代码如下：
+ (NSString *)getUTCFormateDate:(NSDate *)newsDate;

// nsdate 转 nsstring(如:@"yyyy-MM-dd HH:mm:ss"];)
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

// 字典或数组转json格式字符串：
+ (NSString*)JSONString:(id)obj;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end
