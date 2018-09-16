//
//  YZHNetworkService.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHNetworkService.h"

#import "YZHNetworkConfig.h"

//RefreshToken状态
typedef NS_ENUM(NSInteger, YMRefreshTokenStatus) {
    YMRefreshTokenStatusUnknown = 0,
    YMRefreshTokenStatusSuccess = 1,
    YMRefreshTokenStatusfailure = 2,
};
static id instance;
@interface YZHNetworkService ()

@property (nonatomic, strong) NSDate *lastRefreshTokenTime;
@property (nonatomic, assign) YMRefreshTokenStatus lastRefreshTokenStatus;
@property (nonatomic, copy) NSString *encodeVersion; //编码后的App版本号，6位数字，如3.0.1为030001

@end

@implementation YZHNetworkService

#pragma mark -- init

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

+ (instancetype)shareService{
    
    return [[self alloc] init];
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -- Networking

- (void)GETNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id))successCompletion failureCompletion:(void (^)(NSError *))failureCompletion{
#if DEBUG
    
#endif
    //添加公共参数，例如缓存时间、设备信息等
    NSDictionary *finalParams = [self appendingGeneralParams:params path:path];
    
    [YZHNetworkConfig GETNetworkingResource:path params:finalParams successCompletion:^(id responseObject) {
        // 统一处理返回成功逻辑.
        [self processResponse:responseObject path:path success:successCompletion failure:failureCompletion];
    } failureCompletion:^(NSError *error) {
        // 统一处理返回失败逻辑.
        failureCompletion(error);
        [self processError:error failure:failureCompletion refreshToken:^{
            // 执行错误逻辑
            
        }];
    }];
    
}

- (void)POSTNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id))successCompletion failureCompletion:(void (^)(NSError *))failureCompletion{
    //添加公共参数，例如缓存时间、设备信息等
    NSDictionary *finalParams = [self appendingGeneralParams:params path:path];
    
    [YZHNetworkConfig POSTNetworkingResource:path params:finalParams successCompletion:^(id responseObject) {
        // 统一处理返回成功逻辑.
        [self processResponse:responseObject path:path success:successCompletion failure:failureCompletion];
    } failureCompletion:^(NSError *error) {
        // 统一处理返回失败逻辑.
        failureCompletion(error);
        [self processError:error failure:failureCompletion refreshToken:^{
            // 执行错误逻辑
            
        }];
    }];
}

#pragma mark --

- (void)processError:(NSError *)error failure:(void (^)(NSError *error))failure refreshToken:(void (^)(void))refreshToken{
    
    failure(error);
}

- (void)processResponse:(id)response path:(NSString *)path success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure{
    
    success(response);
    
}
#pragma mark -- ConfigPublicParameter
- (NSDictionary *)appendingGeneralParams:(NSDictionary *)params path:(NSString *)path{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    //添加缓存时间
    //添加terminal参数
    //添加CLIENT参数，登录、注册、token刷新接口需要
    //添加App版本号
    dic[@"version"] = self.encodeVersion;
    return dic;
}

#pragma mark -- GET & SET

- (NSString *)encodeVersion{
    
    if (_encodeVersion == nil) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        NSMutableArray<NSString *> *versionArray = [[appVersion componentsSeparatedByString:@"."] mutableCopy];
        //TODO: 与后台协商版本号格式
//        for (int i=0; i<3; i++) {
//            if (i > versionArray.count-1) {
//                [versionArray addObject:@"0"];
//            }
//        }
//        _encodeVersion = [NSString stringWithFormat:@"%02d%02d%02d",versionArray[0].intValue ,versionArray[1].intValue ,versionArray[2].intValue];
        _encodeVersion = appVersion;
    }
    return _encodeVersion;
}

@end
