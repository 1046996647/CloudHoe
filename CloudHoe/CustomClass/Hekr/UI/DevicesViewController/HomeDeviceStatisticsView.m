//
//  HomeDeviceStatisticsView.m
//  HekrSDKAPP
//
//  Created by Mike on 16/2/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "HomeDeviceStatisticsView.h"
#import "UIColor+YYAdd.h"
#import "Tool.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "Tool.h"
#import <SHAlertViewBlocks.h>

#define TEMP @"WEATHER_TEMP"
#define CITY @"WEATHER_CITY"
#define IMG @"WEATHER_IMG"
#define HUM @"WEATHER_HUM"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface HomeDeviceStatisticsView ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic, strong)NSDictionary *dataDict;
@property(nonatomic,assign)BOOL isUpdata;
@end

@implementation HomeDeviceStatisticsView
{
    CLLocation *_currentLocation;
    UIImageView *_weatherImage;
    UILabel *_tempLabel;
    UILabel *_cityLabel;
    UILabel *_humLabel;
    UILabel *_suggestLabel;
    UIImageView *_bgView;
    UILabel *_centerLabel;
    id _info;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    _bgView.image = isNightTheme() ? [UIImage imageNamed:@"ic_dev_bar_dark"] : [UIImage imageNamed:@"ic_dev_bar"];
//    _bgView.backgroundColor = [UIColor redColor];
//    self.layer.borderColor = [[UIColor redColor] CGColor];
//    self.layer.borderWidth = 2;
    [self addSubview:_bgView];
    
    
    
    _tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-Hrange(180)/2, Vrange(150), Hrange(180), Vrange(66))];
    _tempLabel.textColor = getTempColor();
    _tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:Vrange(66)+5];
    [self addSubview:_tempLabel];
    
    _weatherImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_tempLabel.frame)-Hrange(140), _tempLabel.center.y-Hrange(50), Hrange(100), Hrange(100))];
    [self addSubview:_weatherImage];
    
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_tempLabel.frame)-16-Vrange(40), ScreenWidth, 18)];
    _cityLabel.textColor = getCityColor();
    _cityLabel.font = [UIFont systemFontOfSize:15];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_cityLabel];

    _humLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tempLabel.frame)+10, CGRectGetMaxY(_tempLabel.frame)-12, ScreenWidth-(CGRectGetMaxX(_tempLabel.frame))-20, 12)];
    _humLabel.textColor = getHumColor();
    _humLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_humLabel];
    
    _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hrange(200), CGRectGetMaxY(_humLabel.frame)+Vrange(24), ScreenWidth-Hrange(200), 1)];
    _centerLabel.backgroundColor = isNightTheme() ? UIColorFromHex(0x898989) : rgb(235, 235, 235);
//    [self addSubview:_centerLabel];
    
    _suggestLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_centerLabel.frame)+Vrange(24), ScreenWidth-40, 30)];
    _suggestLabel.numberOfLines = 0;
    _suggestLabel.textColor = getSuggestColor();
    _suggestLabel.textAlignment = NSTextAlignmentCenter;
    _suggestLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_suggestLabel];
    
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:TEMP];
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:CITY];
    NSString *hum = [[NSUserDefaults standardUserDefaults] objectForKey:HUM];
    NSData *img = [[NSUserDefaults standardUserDefaults] objectForKey:IMG];
    
    temp.length > 0 ? (_tempLabel.text = temp) : (_tempLabel.text = NSLocalizedString(@"30℃", nil));
    city.length > 0 ? (_cityLabel.text = city) : (_cityLabel.text = NSLocalizedString(@"北京", nil));
    hum.length > 0 ? (_humLabel.text = hum) : (_humLabel.text = NSLocalizedString(@"湿度 52%", nil));
    img == nil ? (_weatherImage.image = [UIImage imageNamed:@"overcast"]) : (_weatherImage.image = [NSKeyedUnarchiver unarchiveObjectWithData: img]);
}

- (void)updateDeviceData{
    if ([Hekr sharedInstance].user) {
        [self locate];
    }
}

- (void)refreshTheme{
    _bgView.image = isNightTheme() ? [UIImage imageNamed:@"ic_dev_bar_dark"] : [UIImage imageNamed:@"ic_dev_bar"];
    _tempLabel.textColor = getTempColor();
    _cityLabel.textColor = getCityColor();
    _humLabel.textColor = getHumColor();
    _suggestLabel.textColor = getSuggestColor();
    _centerLabel.backgroundColor = isNightTheme() ? UIColorFromHex(0x898989) : rgb(235, 235, 235);
}

//天气动画
- (void)refreshAction{

    if (([_dataDict[@"city"] isEqualToString:_info[@"results"][0][@"location"][@"name"]])&&([_dataDict[@"temp"] isEqualToString:_info[@"results"][0][@"now"][@"temperature"]])&&([_dataDict[@"hum"] isEqualToString:_info[@"results"][0][@"now"][@"humidity"]])&&([_dataDict[@"code"] isEqualToString:_info[@"results"][0][@"now"][@"code"]])) {
        return;
    }

    _cityLabel.alpha = 0.0;
    _tempLabel.alpha = 0.0;
    _weatherImage.alpha = 0.0;
    _humLabel.alpha = 0.0;
    _suggestLabel.alpha = 0.0;
    [self performSelector:@selector(weatherAnimate) withObject:nil afterDelay:0.15];
    [UIView animateWithDuration:0.3 animations:^{
        _cityLabel.alpha = 1.0;
        _tempLabel.alpha = 1.0;
        _cityLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _tempLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
           _cityLabel.transform = CGAffineTransformIdentity;
           _tempLabel.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            _humLabel.alpha = 1.0;
            _humLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _humLabel.transform = CGAffineTransformIdentity;
            }];
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            _suggestLabel.alpha = 1.0;
        }];
    }];
}

- (void)weatherAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        _weatherImage.alpha = 1.0;
        _weatherImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _weatherImage.transform = CGAffineTransformIdentity;
        }];
    }];
}


- (void)locate{
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    _isUpdata = YES;
//    [_locationManager requestWhenInUseAuthorization];
//    [_locationManager requestAlwaysAuthorization];//添加这句
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)getWeather{
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    long long ts = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * sign = [NSString stringWithFormat:@"%lldHekrNetwork1607%lld",ts,ts];
    
    NSArray *arr = [lang() componentsSeparatedByString:@"-"];
    if ([arr[0] isEqualToString:@"en"]) {
        [manager GET:[NSString stringWithFormat:@"http://user.openapi.hekr.me/weather/now?location=%f:%f&sign=%@&timestamp=%lld&language=en",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude,md5(sign),ts] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[拉取天气（英文）]：%@",responseObject);
            _info = responseObject;
            [self setData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            _suggestLabel.text = NSLocalizedString(@"天气信息获取失败，请检查网络", nil);
        }];
    }else{
        [manager GET:[NSString stringWithFormat:@"http://user.openapi.hekr.me/weather/now?location=%f:%f&sign=%@&timestamp=%lld",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude,md5(sign),ts] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[拉取天气（中文）]：%@",responseObject);
            _info = responseObject;
            [self setData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            _suggestLabel.text = NSLocalizedString(@"天气信息获取失败，请检查网络", nil);
        }];
    }
    
}

- (void)setData{
    [self refreshAction];
    _cityLabel.text = _info[@"results"][0][@"location"][@"name"];
    _tempLabel.text = [NSString stringWithFormat:@"%@℃",_info[@"results"][0][@"now"][@"temperature"]];
    NSString *hum = [_info[@"results"][0][@"now"][@"humidity"] stringByAppendingString:@"%"];
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"湿度 %@",nil),hum];
    _humLabel.text = str;
    NSInteger code = [_info[@"results"][0][@"now"][@"code"] integerValue];
    switch (code) {
        case 0:
        case 2:
            _weatherImage.image = [UIImage imageNamed:@"sunny"];
            break;
        case 1:
        case 3:
            _weatherImage.image = [UIImage imageNamed:@"clear"];
            break;
        case 4:
        case 5:
        case 7:
            _weatherImage.image = [UIImage imageNamed:@"overcast"];
            break;
        case 6:
        case 8:
            _weatherImage.image = [UIImage imageNamed:@"clearovercast"];
            break;
        case 9:
            _weatherImage.image = [UIImage imageNamed:@"cloudy"];
            break;
            
        case 11:
            _weatherImage.image = [UIImage imageNamed:@"thunderstorms"];
            break;
        case 12:
            _weatherImage.image = [UIImage imageNamed:@"thundersnow"];
            break;
        case 10:
        case 13:
            _weatherImage.image = [UIImage imageNamed:@"lightrain"];
            break;
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
            _weatherImage.image = [UIImage imageNamed:@"showers"];
            break;
        case 19:
        case 20:
            _weatherImage.image = [UIImage imageNamed:@"snowshowers"];
            break;
        case 21:
        case 22:
            _weatherImage.image = [UIImage imageNamed:@"snow"];
            break;
        case 23:
        case 24:
        case 25:
            _weatherImage.image = [UIImage imageNamed:@"heavysnow"];
            break;
        case 26:
        case 27:
        case 28:
        case 29:
            _weatherImage.image = [UIImage imageNamed:@"storm"];
            break;
        case 30:
        case 31:
            _weatherImage.image = [UIImage imageNamed:@"fog"];
            break;
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
            _weatherImage.image = [UIImage imageNamed:@"wind"];
            break;
        case 37:
            _weatherImage.image = [UIImage imageNamed:@"heavysnow"];
            break;
        case 38:
            _weatherImage.image = [UIImage imageNamed:@"sunny"];
            break;
        case 99:
            _weatherImage.image = [UIImage imageNamed:@"N-A"];
            break;
            
        default:
            break;
    }
    
    
    NSString *tem = _info[@"results"][0][@"now"][@"temperature"];
    NSString *humi = _info[@"results"][0][@"now"][@"humidity"];
    if (code == 30) {
        _suggestLabel.text = NSLocalizedString(@"大雾天气，出门注意安全", nil);
    }else if (code == 28 || code == 29){
        _suggestLabel.text = NSLocalizedString(@"沙尘天气，建议打开净化器", nil);
    }else if ((code == 20 || code == 21 ||  code == 22 ||  code == 23 ||  code == 24 ||  code == 25) && ([tem integerValue] >= -5 && [tem integerValue] <= 9)){
        _suggestLabel.text = NSLocalizedString(@"雨雪天气，建议打开空调、取暖器取暖", nil);
    }else if ((code == 20 || code == 21 ||  code == 22 ||  code == 23 ||  code == 24 ||  code == 25) && ([tem integerValue] <= -5)){
        _suggestLabel.text = NSLocalizedString(@"天气寒冷，建议打开取暖设备并注意保暖", nil);
    }else if (code == 20 || code == 21 ||  code == 22 ||  code == 23 ||  code == 24 ||  code == 25){
        _suggestLabel.text = NSLocalizedString(@"雨雪天气，建议打开空调、取暖器取暖", nil);
    }else if (([tem integerValue] >= 25 && [tem integerValue] <= 33)&&([humi integerValue] <= 35)){
        _suggestLabel.text = NSLocalizedString(@"天气干燥，建议打开加湿器、空调加湿", nil);
    }else if (([tem integerValue] >= 33)&&([humi integerValue] <= 35)){
        _suggestLabel.text = NSLocalizedString(@"天气炎热，建议打开加湿器、空调降温", nil);
    }else if (([tem integerValue] >= 33)&&([humi integerValue] >= 75)){
        _suggestLabel.text = NSLocalizedString(@"天气闷热，建议打开除湿机、空调降温", nil);
    } else if (([tem integerValue] >= 25 && [tem integerValue] <= 33)&&([humi integerValue] >= 75)){
        _suggestLabel.text = NSLocalizedString(@"天气闷热，建议打开除湿机、空调降温", nil);
    }else if ([tem integerValue] >= -5 && [tem integerValue] <= 9){
        _suggestLabel.text = NSLocalizedString(@"气温较低，建议打开空调、取暖器取暖", nil);
    }else if ([tem integerValue] <= -5){
        _suggestLabel.text = NSLocalizedString(@"天气寒冷，建议打开取暖设备并注意保暖", nil);
    }else if ([tem integerValue] >= 25 && [tem integerValue] <= 33){
        _suggestLabel.text = NSLocalizedString(@"气温偏高，建议打开冷风扇、空调纳凉", nil);
    }else if ([tem integerValue] >= 33){
        _suggestLabel.text = NSLocalizedString(@"天气炎热，建议打开空调降温", nil);
    }else if ([humi integerValue] <= 35){
        _suggestLabel.text = NSLocalizedString(@"天气干燥，建议打开加湿器加湿", nil);
    }else if ([humi integerValue] >= 75){
        _suggestLabel.text = NSLocalizedString(@"天气潮湿，建议打开除湿机除湿", nil);
    }else{
        _suggestLabel.text = @"";
    }
    
    _dataDict = @{@"city":_info[@"results"][0][@"location"][@"name"],
                  @"temp":_info[@"results"][0][@"now"][@"temperature"],
                  @"hum":_info[@"results"][0][@"now"][@"humidity"],
                  @"code":_info[@"results"][0][@"now"][@"code"]};
    [[NSUserDefaults standardUserDefaults] setObject:_tempLabel.text forKey:TEMP];
    [[NSUserDefaults standardUserDefaults] setObject:_cityLabel.text forKey:CITY];
    [[NSUserDefaults standardUserDefaults] setObject:_humLabel.text forKey:HUM];
    NSData *imgData = [NSKeyedArchiver archivedDataWithRootObject:_weatherImage.image];
    [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:IMG];

}

#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if ((status == kCLAuthorizationStatusAuthorizedWhenInUse)||(status == kCLAuthorizationStatusAuthorizedAlways)) {
         [_locationManager startUpdatingLocation];
    }else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
        _suggestLabel.text = NSLocalizedString(@"无法获取当前位置，请打开定位服务", nil);
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
//    DDLogVerbose(@"**********%@",locations);
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    _currentLocation = [locations lastObject];
    
    if (_isUpdata == YES) {
        [self getWeather];
        _isUpdata = NO;
    }
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        NSLog(@"%@",error);
    }
    
}
 
@end
