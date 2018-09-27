//
//  YZHLocationManager.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface YZHLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@end

@implementation YZHLocationManager

+ (instancetype)shareManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self locationManager];
        [self getLocation];
    }
    return self;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)getLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {
        @weakify(self)
        [self getUserLocationWithsuccess:^{
            @strongify(self)
            [self.locationManager startUpdatingLocation];
        } failure:^(CLAuthorizationStatus status) {
        }];
    } else {
    }
}

- (void)getLocationWithSucceed:(callLocationBlock)succeed faildBlock:(callLocationBlock)faildBlock{
    
    if ([CLLocationManager locationServicesEnabled]) {
        @weakify(self)
        [self getUserLocationWithsuccess:^{
            @strongify(self)
            [self.locationManager startUpdatingLocation];
            self.managerSucceedBlock = succeed;
            self.managerfaildBlock = faildBlock;
        } failure:^(CLAuthorizationStatus status) {
            faildBlock ? faildBlock() : NULL;
        }];
    } else {
        faildBlock ? faildBlock() : NULL;
    }
}
#pragma mark - Private Mothed

- (void)getUserLocationWithsuccess:(void (^)(void))success failure:(void (^)(CLAuthorizationStatus status))failure
{
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
        
    } else if ((authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        success ? success() : NULL;
        
    } else {
        
        failure ? failure(authorizationStatus) : NULL;
        
    }
}

#pragma mark - CLLocationManagerDelegate
//当请求认证状态发生改变时
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if ((status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        [self.locationManager startUpdatingLocation];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * newLoaction = locations[0];
    @weakify(self)
        [self.geoCoder reverseGeocodeLocation:newLoaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            @strongify(self)
            if (!error) {
                for (CLPlacemark * place in placemarks) {
                    if (place.country.length) {
                        self.country = place.country;
                    }
                    if (place.administrativeArea.length) {
                        self.province = place.administrativeArea;
                    }
                    if (place.locality) {
                        self.city = place.locality;
                    }
                    if (self.province.length && self.city.length && self.country.length) {
                        // 拼接结果.
                        [self spliceCurrentGeographicLocation];
                        // 获取到省份和城市之后停止 查找地理位置。
                        [self.locationManager stopUpdatingLocation];
                    }
                    self.managerSucceedBlock();
                }
            } else {
                NSLog(@"编码地理位置错误原因%@",error);
                self.managerfaildBlock();
            }
        }];
}
// TODO:获取地理位置错误处理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"获取地理位置错误原因%@",error);
    self.managerfaildBlock();
}

- (void)spliceCurrentGeographicLocation{
    
    self.currentLocation = [NSString stringWithFormat:@"%@·%@·%@",self.country, self.province, self.city];
}

#pragma mark -- Set && Get

- (NSString *)province {
    if (!_province) {
        _province = self.city;
    }
    return _province;
}

- (NSString *)city {
    if (!_city) {
        _city = @"其他";
    }
    return _city;
}

- (NSString *)currentLocation{
    
    if (!_currentLocation) {
        _currentLocation = @"无法获取定位....";
    }
    return _currentLocation;
}

- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}



@end
