//
//  YZHNetworkService.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHNetworkService.h"

#import "YZHNetworkConfig.h"
#import "NSObject+YZHApiModel.h"
#import "AFURLResponseSerialization.h"

//数据服务错误代码
#define SERVER_ERROR_NEED_REFRESH   -98      //需要重新刷新
#define SERVER_ERROR_OTHER          -99      //其它错误
#define SERVER_ERROR_MAINTAIN       -103    //系统维护

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
    //添加公共参数，例如缓存时间、设备信息等TODO
//    NSDictionary *finalParams = [self appendingGeneralParams:params path:path];
    
    [YZHNetworkConfig GETNetworkingResource:path params:params successCompletion:^(id responseObject) {
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
// 规范与前面不同意的接口暂时先调这里.
- (void)POSTGDLNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id))successCompletion failureCompletion:(void (^)(NSError *))failureCompletion{
    //添加公共参数，例如缓存时间、设备信息等
    NSDictionary *finalParams = [self appendingGeneralParams:params path:path];
    
    [YZHNetworkConfig POSTNetworkingResource:path params:finalParams successCompletion:^(id responseObject) {
        // 统一处理返回成功逻辑.
//        [self processResponse:responseObject path:path success:successCompletion failure:failureCompletion];
        successCompletion ? successCompletion(responseObject) : NULL;
    } failureCompletion:^(NSError *error) {
        // 统一处理返回失败逻辑.
        failureCompletion ? failureCompletion(error) : NULL;
//        [self processError:error failure:failureCompletion refreshToken:^{
//            // 执行错误逻辑
//
//        }];
    }];
}

#pragma mark -- ResponUniftManage

- (void)processError:(NSError *)error failure:(void (^)(NSError *error))failure refreshToken:(void (^)(void))refreshToken{
    
    NSError *failureError = nil;
    
    switch (error.code) {
            default:
        {
#if DEBUG
            failureError = [NSError errorWithDomain:error.domain code:SERVER_ERROR_NEED_REFRESH userInfo:nil];
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (errorData) {
                NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
                NSLog(@"请求后台报错日志:error--%@",serializedData);
            }
#endif
        }
    }
    if (!failureError) {
        failureError = [[NSError alloc] init];
    }
    failure(failureError);
}

- (void)processResponse:(id)response path:(NSString *)path success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure{
    
    id successObj = nil;
    NSError *failureError = nil;
    
    id finalResponse = [self packageResponse:response path:path];
    // 返回解决有数据, 并且属于 字典类型为成功.
    if (finalResponse && [finalResponse isKindOfClass:[NSDictionary class]]) {
        //取出 Code, 约定 Code 200 为成功
        //取code、message、data TODO:异常捕获
        NSString* code = [finalResponse objectForKey:kYZHResponeCodeKey];
        //排除为空的时候. 避免异常
        if (YZHIsEmptyString(code)) {
            code = nil;
        }
        NSString* detail = [finalResponse objectForKey:kYZHResponeMessageKey];
        //可能是空的
        id value = [finalResponse objectForKey:kYZHResponeDataKey];
        if ([value isKindOfClass:[NSNull class]] || [value isEqual:[NSNull null]]) {
            value = nil;
        } else {
            
        }
        // 如果是空的直接拷贝则崩溃.
//        NSMutableDictionary* value = [[finalResponse objectForKey:kYZHResponeDataKey] mutableCopy];
        if (YZHIsEmptyString(detail)) {
            detail = nil;
        } else {
            if (YZHIsDictionary(value)) {
                value = [value mutableCopy];
                //TODO:
                [value setObject:detail forKey:kYZHResponeMessageKey];
            }
        }
        if ([code isEqualToString:@"200"]) {
            //追加code、detail参数
            successObj = value;
            //追加code、detail参数
            //TODO:请求成功时返回YMAPIModel类型，不返回id类型
            if (!successObj) {
                successObj = [[NSObject alloc] init];
                ((NSObject*)successObj).yzh_apiCode = code;
                ((NSObject*)successObj).yzh_apiDetail = detail;
                ((NSObject*)successObj).yzh_apiEmptyValue = YES;
            }
        } else  { // 这里最好和后台协商, 根据 Code 码来弹出相应的框
            // 非成功状态统一弹框处理. TODO:
            failureError = [NSError errorWithDomain:detail ? detail : @"网络异常" code:[code integerValue] userInfo:nil];
        }
        
        if (failureError) {
            failure(failureError);
        } else {
            success(successObj);
        }
    } else {
        successObj = response;
        success(successObj);
    }
    
}
#pragma mark -- ConfigPublicParameter
- (NSDictionary *)appendingGeneralParams:(NSDictionary *)params path:(NSString *)path{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    //添加缓存时间
    //添加terminal参数
    //添加CLIENT参数，登录、注册、token刷新接口需要
    //添加App版本号
//    dic[@"version"] = self.encodeVersion;
    return dic;
}

#pragma mark -- Respinse PackAge

- (id)packageResponse:(id)response path:(NSString *)path {
    
    return response;
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
        NSString* str;
        [str stringByAppendingString:@""];
    }
    return _encodeVersion;
}

@end
