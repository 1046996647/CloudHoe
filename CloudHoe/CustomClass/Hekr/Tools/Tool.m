//
//  Tool.m
//  HekrSDKAPP
//
//  Created by 马滕亚 on 15/11/20.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <HekrAPI.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation Tool
+ (id) getJsonDataFromFile:(NSString *)fileName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        return nil;
    }
    id jsonDicOrArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonDicOrArray;
}
+ (NSData *)jsonToData:(id)json{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return nil;
    return result;
}

+ (id)dataToJson:(NSData *)data{
    if (!data) {
        return nil;
    }
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) return nil;
    return result;
}

+(NSDictionary *)getProfileJsonData{
    NSDictionary *profile = [Tool getJsonDataFromFile:@"profile.json"];
    
    BOOL social = [[profile objectForKey:@"Social"] boolValue];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (!social) {
        return data;
    }
    
    NSString *weibo = [profile objectForKey:@"Weibo"];
    NSString *qq = [profile objectForKey:@"QQ"];
    NSString *weixin = [profile objectForKey:@"Weixin"];
    NSString *facebook = [profile objectForKey:@"Facebook"];
    NSString *google = [profile objectForKey:@"Google"];
    NSString *twitter = [profile objectForKey:@"Twitter"];
    
    BOOL showScoial = NO;
    
    if (weibo&&weibo.length>0) {
        showScoial = YES;
        [data setObject:[NSNumber numberWithBool:YES] forKey:KeyOfSocialWeibo];
    }else{
        [data setObject:[NSNumber numberWithBool:NO] forKey:KeyOfSocialWeibo];
    }
    if (qq&&qq.length>0) {
        showScoial = YES;
        [data setObject:[NSNumber numberWithBool:YES] forKey:KeyOfSocialQQ];
    }else{
        [data setObject:[NSNumber numberWithBool:NO] forKey:KeyOfSocialQQ];
    }
    if (weixin&&weixin.length>0) {
        showScoial = YES;
        [data setObject:[NSNumber numberWithBool:YES] forKey:KeyOfSocialWeixin];
    }else{
        [data setObject:[NSNumber numberWithBool:NO] forKey:KeyOfSocialWeixin];
    }
    if (google&&google.length>0) {
        showScoial = YES;
        [data setObject:[NSNumber numberWithBool:YES] forKey:KeyOfSocialGoogle];
    }else{
        [data setObject:[NSNumber numberWithBool:NO] forKey:KeyOfSocialGoogle];
    }
    if (facebook&&facebook.length>0) {
        showScoial = YES;
        [data setObject:[NSNumber numberWithBool:YES] forKey:KeyOfSocialFacebook];
    }else{
        [data setObject:[NSNumber numberWithBool:NO] forKey:KeyOfSocialFacebook];
    }
    if (twitter&&twitter.length>0) {
        showScoial = YES;
        [data setObject:[NSNumber numberWithBool:YES] forKey:KeyOfSocialTwitter];
    }else{
        [data setObject:[NSNumber numberWithBool:NO] forKey:KeyOfSocialTwitter];
    }
    [data setObject:[NSNumber numberWithBool:showScoial] forKey:@"Social"];
    
    return data;
}

@end

NSString* lang(){
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language hasPrefix:@"zh-Hans"]) {
        return @"zh-CN";
    }
    return @"en-US";
}

BOOL isEN(){
    if ([lang() isEqualToString:@"en-US"]) {
        return YES;
    }else{
        return NO;
    }
}

NSString* md5(NSString* str){
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

BOOL IsEnableWIFI() {
    return [[[Hekr sharedInstance] reachability] isReachableViaWiFi];
//    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

//// 是否3G
BOOL IsEnable3G() {
    return [[[Hekr sharedInstance] reachability] isReachableViaWWAN];
//    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


NSString * errorStringForCode(NSUInteger code){
    switch(code){
        case 1200000:
            return NSLocalizedString(@"Success",nil);
//        case 1400001:
//            return NSLocalizedString(@"Json parse error",nil);
//        case 1400002:
//            return NSLocalizedString(@"JWT parse error",nil);
//        case 1400003:
//            return NSLocalizedString(@"Protocol field high",nil);
//        case 1400004:
//            return NSLocalizedString(@"Protocol field low",nil);
//        case 1400005:
//            return NSLocalizedString(@"Protocol field not enumeration",nil);
//        case 1400006:
//            return NSLocalizedString(@"Field {0} not exist!!",nil);
//        case 1400008:
//            return NSLocalizedString(@"Device not match",nil);
        case 1400009:
            return NSLocalizedString(@"重复登录",nil);
        case 1400010:
            return NSLocalizedString(@"用户不存在",nil);
//        case 1400011:
//            return NSLocalizedString(@"Device no have instruction",nil);
//        case 1400012:
//            return NSLocalizedString(@"Device not belong to user",nil);
        case 1400013:
            return NSLocalizedString(@"设备重复登录",nil);
//        case 1400014:
//            return NSLocalizedString(@"Device frame type error",nil);
        case 1400015:
            return NSLocalizedString(@"操作超时，请重新刷新",nil);
//        case 1400016:
//            return NSLocalizedString(@"Action not support",nil);
//        case 1400017:
//            return NSLocalizedString(@"Device token can't verification",nil);
        case 1400018:
            return NSLocalizedString(@"当前设备处于离线状态",nil);
//        case 1400023:
//            return NSLocalizedString(@"AppTid not match",nil);
//        case 1400024:
//            return NSLocalizedString(@"You report info not match your connect server",nil);
//        case 1400025:
//            return NSLocalizedString(@"RAW not valid, Please check your protocol template",nil);
//        case 1400028:
//            return NSLocalizedString(@"PinCode or SSID not available", nil);
        case 1400029:
            return NSLocalizedString(@"绑定超时",nil);
        case 1400030:
            return NSLocalizedString(@"不支持绑定",nil);
        case 1400031:
            return NSLocalizedString(@"不能强制绑定",nil);
//        case 2200000:
//            return NSLocalizedString(@"Success",nil);
//        case 2400000:
//            return NSLocalizedString(@"Error",nil);
//        case 2400001:
//            return NSLocalizedString(@"Template id not exist",nil);
//        case 2400002:
//            return NSLocalizedString(@"Email send error",nil);
//        case 2500000:
//            return NSLocalizedString(@"Internal error",nil);
        case 400016:
            return NSLocalizedString(@"操作太频繁，请稍后重试",nil);
        case 400017:
            return NSLocalizedString(@"今日次数已达上限",nil);
        case 3400001:
            return NSLocalizedString(@"手机号无效，请更换手机号",nil);
        case 3400002:
            return NSLocalizedString(@"填写的验证码有误",nil);
        case 3400003:
            return NSLocalizedString(@"填写的验证码过期",nil);
//        case 3400004:
//            return NSLocalizedString(@"限制一秒操作一次",nil);
        case 3400005:
            return NSLocalizedString(@"发送验证码次数过多，请稍后再试",nil);
//        case 3400006:
//            return NSLocalizedString(@"Invalid Request type",nil);
        case 3400007:
            return NSLocalizedString(@"旧密码错误",nil);
        case 3400008:
            return NSLocalizedString(@"用户已注册",nil);
        case 3400009:
            return NSLocalizedString(@"账户尚未验证",nil);
        case 3400010:
            return NSLocalizedString(@"用户名或密码错误，请稍后再试",nil);
        case 3400011:
            return NSLocalizedString(@"用户不存在",nil);
        case 3400012:
            return NSLocalizedString(@"邮件已过期，请重新请求",nil);
        case 3400013:
            return NSLocalizedString(@"账户已认证",nil);
        case 3400014:
            return NSLocalizedString(@"您已经绑定了三方账号",nil);
        case 3400016:
            return NSLocalizedString(@"该账户不支持升级",nil);
        case 3400017:
            return NSLocalizedString(@"验证码错误，请重试",nil);
        case 3400018:
            return NSLocalizedString(@"您输入的答案有误，请重新输入",nil);
        case 5200000:
            return NSLocalizedString(@"Success",nil);
//        case 5400001:
//            return NSLocalizedString(@"Internal error",nil);
        case 5400002:
            return NSLocalizedString(@"该账户已登录，不能重复登录",nil);
//        case 5400003:
//            return NSLocalizedString(@"App Tid Can't Empty",nil);
        case 5400004:
            return NSLocalizedString(@"授权关系已存在",nil);
        case 5400005:
            return NSLocalizedString(@"授权关系不存在",nil);
        case 5400006:
            return NSLocalizedString(@"因网络原因绑定失败",nil);
        case 5400007:
            return NSLocalizedString(@"因超时原因绑定失败",nil);
        case 5400008:
            return NSLocalizedString(@"不支持该设备绑定",nil);
        case 5400009:
            return NSLocalizedString(@"修改用户档案失败",nil);
        case 5400010:
            return NSLocalizedString(@"验证码错误，请重试",nil);
        case 5400011:
            return NSLocalizedString(@"设备授权次数达到上限，无法再次授权",nil);
//        case 5400012:
//            return NSLocalizedString(@"Bind Failed Due to Internal Error",nil);
        case 5400013:
            return NSLocalizedString(@"因重复绑定，绑定失败",nil);
        case 5400014:
            return NSLocalizedString(@"设备不再属于该用户",nil);
//        case 5400015:
//            return NSLocalizedString(@"No Such Instruction Error",nil);
        case 5400016:
            return NSLocalizedString(@"设备无法重复登录",nil);
//        case 5400017:
//            return NSLocalizedString(@"Device Tid Can't Empty",nil);
        case 5400018:
            return NSLocalizedString(@"创建定时预约次数达到上限",nil);
        case 5400019:
            return NSLocalizedString(@"授权的指令已过期",nil);
//        case 5400020:
//            return NSLocalizedString(@"Instruction Not Support",nil);
        case 5400021:
            return NSLocalizedString(@"无效的邮件验证信息",nil);
        case 5400022:
            return NSLocalizedString(@"无效的旧密码",nil);
        case 5400023:
            return NSLocalizedString(@"无效的短信校验码",nil);
//        case 5400024:
//            return NSLocalizedString(@"Not Owner Any Device",nil);
//        case 5400025:
//            return NSLocalizedString(@"No Such Manufacture",nil);
        case 5400026:
            return NSLocalizedString(@"没有对该指令的权限",nil);
        case 5400027:
            return NSLocalizedString(@"不支持，请联系厂商",nil);
//        case 5400028:
//            return NSLocalizedString(@"Not Owner",nil);
//        case 5400029:
//            return NSLocalizedString(@"Phone Number Has Registerd",nil);
//        case 5400030:
//            return NSLocalizedString(@"Phone Number Not Support",nil);
//        case 5400031:
//            return NSLocalizedString(@"Phone Number Not Registerd",nil);
//        case 5400032:
//            return NSLocalizedString(@"Push Channel Not Registerd",nil);
//        case 5400033:
//            return NSLocalizedString(@"Send Frequency Too Fast",nil);
//        case 5400034:
//            return NSLocalizedString(@"Send Times Reach Today Limit",nil);
        case 5400035:
            return NSLocalizedString(@"指定任务不存在",nil);
        case 5400036:
            return NSLocalizedString(@"无法创建重复模板",nil);
//        case 5400037:
//            return NSLocalizedString(@"DevTid Not Match",nil);
//        case 5400038:
//            return NSLocalizedString(@"User Already Exists",nil);
        case 5400039:
            return NSLocalizedString(@"用户不存在",nil);
//        case 5400040:
//            return NSLocalizedString(@"Verify Code Expired",nil);
//        case 5400041:
//            return NSLocalizedString(@"Verify Code Send Error",nil);
//        case 5400042:
//            return NSLocalizedString(@"Verify Code Type Invalid",nil);
        case 5400043:
            return NSLocalizedString(@"不支持强制绑定",nil);
        case 6200000:
            return NSLocalizedString(@"Success",nil);
//        case 6400001:
//            return NSLocalizedString(@"Define Reverse Authorization Not Found",nil);
        case 6400002:
            return NSLocalizedString(@"不合法的授权请求",nil);
        case 6400003:
            return NSLocalizedString(@"只有属主可以授权设备给其他人",nil);
        case 6400004:
            return NSLocalizedString(@"操作的设备不存在",nil);
        case 6400005:
            return NSLocalizedString(@"不能在文件夹中添加设备了",nil);
        case 6400006:
            return NSLocalizedString(@"无法创建同名文件夹",nil);
        case 6400007:
            return NSLocalizedString(@"操作的文件夹不存在",nil);
        case 6400008:
            return NSLocalizedString(@"达到创建文件夹数量上限",nil);
        case 6400009:
            return NSLocalizedString(@"无法删除根目录",nil);
        case 6400010:
            return NSLocalizedString(@"无法给根目录改名",nil);
//        case 6400011:
//            return NSLocalizedString(@"Define Event Rule Not Found",nil);
        case 6400012:
            return NSLocalizedString(@"不支持操作",nil);
        case 6400013:
            return NSLocalizedString(@"无法创建相同的任务",nil);
        case 6400014:
            return NSLocalizedString(@"无法创建相同的任务",nil);
//        case 6400015:
//            return NSLocalizedString(@"Invalid ProdPubKey",nil);
        case 6400016:
            return NSLocalizedString(@"操作没有权限",nil);
//        case 6400017:
//            return NSLocalizedString(@"{0}",nil);
//        case 6400018:
//            return NSLocalizedString(@"Define Cloud Storage File Not Found",nil);
//        case 6400019:
//            return NSLocalizedString(@"Invalid ProdPubKey",nil);
        case 6400021:
            return NSLocalizedString(@"红外服务请求出错",nil);
        case 6400023:
            return NSLocalizedString(@"参数不支持",nil);
        case 6400025:
            return NSLocalizedString(@"不支持定时预约",nil);
        case 6400029:
            return NSLocalizedString(@"不能重复扫描二维码",nil);
//        case 6500001:
//            return NSLocalizedString(@"Delete Cloud Storage File Failed",nil);
//        case 6500002:
//            return NSLocalizedString(@"Upload Cloud Storage File Failed",nil);
//        case 6500003:
//            return NSLocalizedString(@"Server use HttpClient Invoke Failed",nil);
        case 8200000:
            return NSLocalizedString(@"Success",nil);
        case 8400000:
            return NSLocalizedString(@"产品不存在",nil);
        case 8400001:
            return NSLocalizedString(@"协议模板不存在",nil);
        case 8400002:
            return NSLocalizedString(@"非法参数",nil);
//        case 8400003:
//            return NSLocalizedString(@"参数错误",nil);
        case 8400004:
            return NSLocalizedString(@"不支持设备",nil);
        case 8400005:
            return NSLocalizedString(@"页面不存在",nil);
//        case 9200000:
//            return NSLocalizedString(@"Success",nil);
//        case 9400000:
//            return NSLocalizedString(@"Error",nil);
//        case 9400001:
//            return NSLocalizedString(@"Bad param",nil);
//        case 9400002:
//            return NSLocalizedString(@"Action not exist",nil);
//        case 9400003:
//            return NSLocalizedString(@"Product not exist",nil);
//        case 9400004:
//            return NSLocalizedString(@"Time out",nil);
//        case 9400005:
//            return NSLocalizedString(@"Method not support",nil);
//        case 9500000:
//            return NSLocalizedString(@"Server error",nil);
//        case 9500001:
//            return NSLocalizedString(@"Server response error",nil);
        default:
            break;
    }
    if ((IsEnableWIFI())||(IsEnable3G())) {
        return @"0";
    }else{
        return NSLocalizedString(@"请检查网络",nil);
    }
    
}




NSString * APIError(NSError* error){
    NSData * data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    id json = nil;
    if (data && (json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil])) {
        NSUInteger code = [[json objectForKey:@"code"] integerValue];
        return errorStringForCode(code);
    }
    if ((IsEnableWIFI())||(IsEnable3G())) {
        return @"0";
    }else{
        return NSLocalizedString(@"请检查网络",nil);
    }
}

NSUInteger APIErrorCode(NSError* error){

    NSData * data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    id json = nil;
    if (data && (json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil])) {
        NSUInteger code = [[json objectForKey:@"code"] integerValue];
        return code;
    }
    return 0;

}
/*验证手机号格式*/
BOOL validateMobile(NSString *mobile)
{
    //手机号以13， 15，18，17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/*验证邮件格式 */
BOOL validateEmail(NSString *email)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
/*限制密码 */
BOOL validatePassWord(NSString *passWord){
    NSString *passReg1 = @"^(.*?)\\d+(.*?)$";
    NSPredicate *passTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passReg1];
    
    NSString *passReg2 = @"[^\\s]{6,30}";
    NSPredicate *passTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passReg2];
    
    return [passTest1 evaluateWithObject:passWord]&&[passTest2 evaluateWithObject:passWord];
}

BOOL isNightTheme(){
    return NO;
//    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
//    if (string) {
//        if ([string isEqualToString:@"Night"]) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }else{
//        return NO;
//    }
}

UIColor * getNavBackgroundColor(){
//    return rgb(249, 249, 249);
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return UIColorFromHex(0x00CB81);
        }else if ([string isEqualToString:@"Cream"]){
            return UIColorFromHex(0xFF9300);
        }else if ([string isEqualToString:@"Night"]){
            return UIColorFromHex(0x333333);
        }else{
            return UIColorFromHex(0x0096FB);
        }
    }else{
        return UIColorFromHex(0x0096FB);
    }
}

NSString * getNavPopBtnImg(){
//    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
//    if (![string isEqualToString:@"Cream"]) {
        return @"ic_userBack";
//    }else{
//        return @"ic_back";
//    }
}

UIColor * getNavTitleColor(){
//    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
//    if (![string isEqualToString:@"Cream"]) {
        return [UIColor whiteColor];
//    }else{
//        return [UIColor blackColor];
//    }
}

UIColor * getViewBackgroundColor(){
    if (isNightTheme()){
        return UIColorFromHex(0x1e1e1f);
    }else{
        return UIColorFromHex(0xf5f5f5);
    }
}

UIColor * getButtonBackgroundColor(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return UIColorFromHex(0x00CB81);
        }else if ([string isEqualToString:@"Cream"]){
            return UIColorFromHex(0xFF9300);
        }else if ([string isEqualToString:@"Night"]){
            return UIColorFromHex(0x333333);
        }else{
            return UIColorFromHex(0x0096FB);
        }
    }else{
        return UIColorFromHex(0x0096FB);
    }
}

UIColor * getDevOnlineColor(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return [UIColor colorWithRed:13/255.0 green:201/255.0 blue:215/255.0 alpha:0.6];
        }else if ([string isEqualToString:@"Cream"]){
            return [UIColor colorWithRed:236/255.0 green:212/255.0 blue:193/255.0 alpha:0.6];
        }else if ([string isEqualToString:@"Night"]){
            return [UIColor clearColor];
        }else{
            return [UIColor colorWithRed:6/255.0 green:164/255.0 blue:240/255.0 alpha:0.6];
        }
    }else{
        return [UIColor colorWithRed:6/255.0 green:164/255.0 blue:240/255.0 alpha:0.6];
    }
    
}

UIColor * getDevOfflineColor(){
    
    if (isNightTheme()){
        return [UIColor clearColor];
    }else{
        return [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:0.6];
    }
}

UIColor * getCellBackgroundColor(){
    if (isNightTheme()){
        return UIColorFromHex(0x232226);
    }else{
        return [UIColor whiteColor];
    }
}

UIColor * getCellLineColor(){
    if (isNightTheme()){
        return [UIColor colorWithRed:66/255.0 green:65/255.0 blue:69/255.0 alpha:0.2];
    }else{
        return rgb(225, 226, 226);
    }
}

UIColor * getTitledTextColor(){
    return isNightTheme() ? UIColorFromHex(0x898989) : UIColorFromHex(0x4a4a4a);
}

UIColor * getDescriptiveTextColor(){
    return isNightTheme() ? UIColorFromHex(0x7B7B7B) : rgb(153, 153, 153);
}

UIColor * getPlaceholderTextColor(){
    return isNightTheme() ? UIColorFromHex(0x7B7B7B) : rgb(204, 204, 204);
}

UIColor * getInputTextColor(){
    return isNightTheme() ? [UIColor whiteColor] : UIColorFromHex(0x4a4a4a);
}

UIColor * getTempColor(){
    return isNightTheme() ? UIColorFromHex(0x898989) : rgb(52, 52, 52);
}

UIColor * getCityColor(){
    return isNightTheme() ? UIColorFromHex(0x898989) : rgb(52, 52, 52);
}

UIColor * getHumColor(){
    return isNightTheme() ? UIColorFromHex(0x898989) : rgb(120, 120, 120);
}
UIColor * getSuggestColor(){
    return isNightTheme() ? UIColorFromHex(0x898989) : rgb(120, 120, 120);
}

UIFont *getNavTitleFont(){
    return [UIFont systemFontOfSize:18];
}

UIFont *getButtonTitleFont(){
    return [UIFont systemFontOfSize:16];
}

UIFont *getListTitleFont(){
    return [UIFont systemFontOfSize:15];
}

UIFont *getDescTitleFont(){
    return [UIFont systemFontOfSize:14];
}

NSString *getDeviseViewBgImg(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return @"ic_devbg_green";
        }else if ([string isEqualToString:@"Cream"]){
            return @"ic_devbg_cream";
        }else if ([string isEqualToString:@"Night"]){
            return @"ic_devbg_night";
        }else{
            return @"ic_devbg_blue";
        }
    }else{
        return @"ic_devbg_blue";
    }
    
}

NSString *getDeviseTopBgImg(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return @"ic_devTop_green";
        }else if ([string isEqualToString:@"Cream"]){
            return @"ic_devTop_cream";
        }else if ([string isEqualToString:@"Night"]){
            return @"ic_devTop_night";
        }else{
            return @"ic_devTop_bg_blue";
        }
    }else{
        return @"ic_devTop_bg_blue";
    }
}

NSString *getUserTopBgImg(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return @"ic_user_top_green";
        }else if ([string isEqualToString:@"Cream"]){
            return @"ic_user_top_cream";
        }else if ([string isEqualToString:@"Night"]){
            return @"ic_user_top_night";
        }else{
            return @"ic_user_top_blue";
        }
    }else{
        return @"ic_user_top_blue";
    }
    
}

NSString *getSideBgImg(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return @"ic_sideBgImg_green";
        }else if ([string isEqualToString:@"Cream"]){
            return @"ic_sideBgImg_cream";
        }else if ([string isEqualToString:@"Night"]){
            return @"ic_sideBgImg_night";
        }else{
            return @"ic_sideBgImg_blue";
        }
    }else{
        return @"ic_sideBgImg_blue";
    }
}

NSString *getConfigGuideBgImg(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return @"config_guide_green";
        }else if ([string isEqualToString:@"Cream"]){
            return @"config_guide_cream";
        }else if ([string isEqualToString:@"Night"]){
            return @"config_guide_night";
        }else{
            return @"config_guide_blue";
        }
    }else{
        return @"config_guide_blue";
    }
}
NSString *getOnLineImg(){
//    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
//    if (string) {
//        if ([string isEqualToString:@"Green"]) {
//            return @"ic_online_green";
//        }else if ([string isEqualToString:@"Cream"]){
//            return @"ic_online_cream";
//        }else if ([string isEqualToString:@"Night"]){
//            return @"ic_online_night";
//        }else{
//            return @"ic_online_blue";
//        }
//    }else{
        return @"ic_online_original";
//    }
}

NSArray *getDeviseIcon(BOOL isShow){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            if (isShow == YES) {
                return @[@"icon_varieties_green",@"icon_scanning_green",@"icon_share-information_green",@"ic_devinfo_green",@"Mac-adress_green"];
            }else{
                return @[@"icon_varieties_green",@"icon_share-information_green",@"ic_devinfo_green",@"Mac-adress_green"];
            }
        }else if ([string isEqualToString:@"Cream"]){
            if (isShow == YES) {
                return @[@"icon_varieties_cream",@"icon_scanning_cream",@"icon_share-information_cream",@"ic_devinfo_cream",@"Mac-adress_cream"];
            }else{
                return @[@"icon_varieties_cream",@"icon_share-information_cream",@"ic_devinfo_cream",@"Mac-adress_cream"];
            }
        }else if ([string isEqualToString:@"Night"]){
            if (isShow == YES) {
                return @[@"icon_varieties_night",@"icon_scanning_night",@"icon_share-information_night",@"ic_devinfo_night",@"Mac-adress_night"];
            }else{
                return @[@"icon_varieties_night",@"icon_share-information_night",@"ic_devinfo_night",@"Mac-adress_night"];
            }
        }else{
            if (isShow == YES) {
                return @[@"icon_varieties_blue",@"icon_scanning_blue",@"icon_share-information_blue",@"ic_devinfo_blue",@"Mac-adress_blue"];
            }else{
                return @[@"icon_varieties_blue",@"icon_share-information_blue",@"ic_devinfo_blue",@"Mac-adress_blue"];
            }
        }
    }else{
        if (isShow == YES) {
            return @[@"icon_varieties_blue",@"icon_scanning_blue",@"icon_share-information_blue",@"ic_devinfo_blue",@"Mac-adress_blue"];
        }else{
            return @[@"icon_varieties_blue",@"icon_share-information_blue",@"ic_devinfo_blue",@"Mac-adress_blue"];
        }
    }
}

NSString *getThemeName(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    return string ? string : @"Blue";
}

//  0--夜间主题
//  1--蓝色主题
//  2--米黄色主题
//  3--绿色主题
//  4--黑色主题
NSUInteger getThemeCode(){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrTheme"]];
    if (string) {
        if ([string isEqualToString:@"Green"]) {
            return 3;
        }else if ([string isEqualToString:@"Cream"]){
            return 2;
        }else if ([string isEqualToString:@"Night"]){
            return 0;
        }else if ([string isEqualToString:@"Black"]){
            return 4;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}


#pragma mark - 获取WIFI名
NSString *getWifiName(){
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
        
    }
    CFRelease(wifiInterfaces);
    
    return wifiName;
}
