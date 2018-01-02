//
//  NSString+ArabicToChinese.m
//  Gas
//
//  Created by 张伟良 on 17/5/24.
//  Copyright © 2017年 HongHu. All rights reserved.
//

#import "NSStringExt.h"

// IP地址
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation NSString (ArabicToChinese)

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

// 根据日期计算是星期几
+ (NSString *)dateToWeek:(NSString *)dateStr
{
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[dateArr[2] integerValue]];
    [_comps setMonth:[dateArr[1] integerValue]];
    [_comps setYear:[dateArr[0] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = [weekdayComponents weekday];
    NSLog(@"_weekday::%d",_weekday);
    switch (_weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  是否为同一月
 */
+ (NSString *)isSameMonth:(NSString*)dateStr
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [inputFormatter dateFromString:dateStr];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy年MM月"];
    NSString *string = [outputFormatter stringFromDate:date];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:[NSDate date]];
//    BOOL isTure = [comp1 month] == [comp2 month] &&
//    [comp1 year]  == [comp2 year];
    if ([comp1 month] == [comp2 month] &&
        [comp1 year]  == [comp2 year]) {
        return @"本月";
    }
    else if ([comp1 year]  == [comp2 year]) {// 只返回月
        string = [string substringFromIndex:5];
        if ([string hasPrefix:@"0"]) {
            string = [string substringFromIndex:1];
        }
        return string;

    }
    else {// 全返回
        return string;

    }
    
    
    return nil;
}

// 公里计算
+ (NSString *)meterToKilometer:(NSString *)meterStr
{
    if (meterStr.integerValue >= 1000) {
        return [NSString stringWithFormat:@"%.2fkm",meterStr.integerValue/1000.0];
    }
    else {
        return [NSString stringWithFormat:@"%ldm",meterStr.integerValue];

    }
    
}

// 文本宽度
+ (CGSize)textLength:(NSString *)content font:(UIFont *)font
{
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:font}];
    return size;
    
}

// 文本高度
+ (CGSize)textHeight:(NSString *)content font:(UIFont *)font width:(NSInteger)width
{
     CGSize titleSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize;
}

// 富文本
+ (NSMutableAttributedString *)text:(NSString *)text  fullText:(NSString *)fullText location:(NSInteger)location color:(UIColor *)color font:(UIFont *)font
{

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange range = {location,[text length]};
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    if (font) {
        [attStr addAttribute:NSFontAttributeName
         
                       value:font
         
                       range:range];
    }
    
    return attStr;
    
}

//在开发中我们经常需要判断一个时期是今天还是昨天，或者是之前的日子。代码如下：
+ (NSString *)getUTCFormateDate:(NSDate *)newsDate

{

    NSString *dateContent;
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today=[[NSDate alloc] init];
    
    NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    
    NSDate *qianToday =  [[NSDate alloc] initWithTimeIntervalSinceNow:-2*secondsPerDay];
    
    //假设这是你要比较的date：NSDate *yourDate = ……
    
    //日历
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
     unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:newsDate];
    
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yearsterDay];
    
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:qianToday];
    
    NSDateComponents* comp4 = [calendar components:unitFlags fromDate:today];
    
    if ( comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
        
        dateContent = @"昨天";
        
    }
    
    else if (comp1.year == comp3.year && comp1.month == comp3.month && comp1.day == comp3.day)
        
    {
        
        dateContent = @"前天";
        
    }
    
    else if (comp1.year == comp4.year && comp1.month == comp4.month && comp1.day == comp4.day)
        
    {
        
        dateContent = @"今天";
        
    }
    
    else
        
    {
        
        //返回0说明该日期不是今天、昨天、前天
        
        dateContent = @"0";
        
    }
    
    return dateContent;
    
}



// nsdate 转 nsstring(如:@"yyyy-MM-dd HH:mm:ss"];)
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];

    return dateStr;
}

// 字典或数组转json格式字符串：
+ (NSString*)JSONString:(id)obj
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

//必须在有网的情况下才能获取手机的IP地址
#pragma mark---------getipadress

+ (NSString *)getIPAddress:(BOOL)preferIPv4

{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;

    NSDictionary *addresses = [self getIPAddresses];
    
    NSLog(@"addresses: %@", addresses);

    __block NSString *address;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     
     {
         address = addresses[key];
         
         if(address) *stop = YES;
         
     } ];
    
    return address ? address : @"0.0.0.0";
    
}

+ (NSDictionary *)getIPAddresses

{
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    
    struct ifaddrs *interfaces;
    
    if(!getifaddrs(&interfaces)) {
        
        // Loop through linked list of interfaces
        
        struct ifaddrs *interface;
        
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                
                continue; // deeply nested code harder to read
                
            }
            
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                
                NSString *type;
                
                if(addr->sin_family == AF_INET) {
                    
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        
                        type = IP_ADDR_IPv4;
                        
                    }
                    
                } else {
                    
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        
                        type = IP_ADDR_IPv6;
                        
                    }
                    
                }
                
//                if(type) {// 获取ipv6
//
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//
//                }
                if(type&&[type isEqualToString:IP_ADDR_IPv4]) {// 获取ipv4
                    
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    
                }
                
            }
            
        }
        
        // Free memory
        
        freeifaddrs(interfaces);
        
    }
    
    return [addresses count] ? addresses : nil;
    
}

@end
