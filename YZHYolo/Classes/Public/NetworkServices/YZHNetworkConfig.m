//
//  YZHNetworkConfig.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHNetworkConfig.h"

#import <AFNetworking.h>
#import "YZHConfigKey.h"
#import "YZHPathConst.h"
#import "YZHServicesConfig.h"
#import "YZHDevice.h"
//#import <Aspects.h>
#import <AFHTTPSessionManager+RetryPolicy.h>

static NSTimeInterval const YZHAPIDefaultTimeoutInterval = 8.0;//缺省请求超时时间
static YZHNetworkConfig* _instance;
@interface YZHNetworkConfig()

@property(nonatomic, strong) AFHTTPSessionManager *httpManager;
@property(nonatomic, strong) AFHTTPSessionManager *httpJSONManager;
@property(nonatomic, strong) NSURL *baseURL;
@property(nonatomic, strong) YZHAPIRetryConfig* retryConfig;

@end

@implementation YZHNetworkConfig

+ (void)initialize{

    [self performSelectorOnMainThread:@selector(shareNetworkConfig) withObject:nil waitUntilDone:NO];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareNetworkConfig{
    
    if (_instance) {
        return _instance;
    } else {
        return [[self alloc] init];
    }
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        NSString* urlString = [[YZHNetworkConfig confignServerHead] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _baseURL = [NSURL URLWithString:urlString];
        
        // TODO:配置默认参数
        _retryConfig = [self defaultAPIRetryConfig];
        
    }
    return self;
}

#pragma mark -- NetwrokingServer

+ (void)GETNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id))successCompletion failureCompletion:(void (^)(NSError *))failureCompletion{
    
    [self getNetworkingResource:path params:params success:successCompletion failure:failureCompletion retryCount:0 retryInterval:0];
    
}

+ (void)POSTNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id))successCompletion failureCompletion:(void (^)(NSError *))failureCompletion{
    
    [self postNetworkingResource:path params:params success:successCompletion failure:failureCompletion retryCount:0 retryInterval:0];
}

#pragma mark -- Private NetwrokingServer

+ (void)getNetworkingResource:(NSString *)path params:(NSDictionary *)params success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval{
    //APILog模式，打印API信息
   NSString* encodeURL =  [self ConsoleOutputLogWithPath:path params:params];
    
    AFHTTPSessionManager* httpSessionManager = [YZHNetworkConfig shareNetworkConfig].httpManager;
    [httpSessionManager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //APILog模式，打印API信息
        if ([YZHServicesConfig boolForKey:kYZHAppConfigApiLog]) {
            NSLog(@"\n POST responseObject: %@ \n encodeURL: %@ \n params: %@",responseObject, encodeURL, params);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //APILog模式，打印API信息
        if ([YZHServicesConfig boolForKey:kYZHAppConfigApiLog]) {
            NSLog(@"\n POST error: %@ \n encodeURL: %@ \n params: %@",error, encodeURL, params);
        }
        failure(error);
    } retryCount:retryCount retryInterval:retryCount progressive:NO fatalStatusCodes:nil];
    
}

+ (void)postNetworkingResource:(NSString *)path params:(NSDictionary *)params success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval{
    //APILog模式，打印API信息
    NSString* encodeURL =  [self ConsoleOutputLogWithPath:path params:params];
    
    AFHTTPSessionManager* httpSessionManager = [YZHNetworkConfig shareNetworkConfig].httpManager;
    if ([path containsString:PATH_PERSON_MOBILEFRIENDS] || [path containsString:PATH_TEAM_ADDUPDATEGROUP] || [path containsString:PATH_TEAM_DELETEGROUP] || [path containsString:PATH_INTEGRL_COLLARTASK] ) {
        httpSessionManager = [YZHNetworkConfig shareNetworkConfig].httpJSONManager;
    }
    [httpSessionManager POST:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //APILog模式，打印API信息
        if ([YZHServicesConfig boolForKey:kYZHAppConfigApiLog]) {
            NSLog(@"\n POST responseObject: %@ \n encodeURL: %@ \n params: %@",responseObject, encodeURL, params);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //APILog模式，打印API信息
        if ([YZHServicesConfig boolForKey:kYZHAppConfigApiLog]) {
            NSLog(@"\n POST error: %@ \n encodeURL: %@ \n params: %@",error, encodeURL, params);
        }
        failure(error);
    } retryCount:retryCount retryInterval:retryCount progressive:NO fatalStatusCodes:nil];
}

#pragma mark -- ConfignServer
//TODO: 懒加载
+ (NSString* )confignServerHead{
    
    NSString* urlServerString;
//只有 DEBUG 时,才会切环境,否则默认都是使用正式服务地址.
#if DEBUG
//  配置测试服,会检测是否开启、
    urlServerString = [YZHServicesConfig debugTestServerConfig];
#else
    urlServerString = [YZHServicesConfig stringForKey:kYZHAppConfigSeverAddr];
#endif
    
    return urlServerString;
    
}

- (YZHAPIRetryConfig* )defaultAPIRetryConfig{
    
    YZHAPIRetryConfig* retryConfig = [[YZHAPIRetryConfig alloc] init];
    //TODO:
    
    
    return retryConfig;
}
/**
 *  由API路径生成API url字符串
 *
 *  @param path API路径
 *
 *  @return API url字符串
 */
+ (NSString* )urlWithPath:(NSString* )path{
    
    NSString* encodePath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* encodeURL = [NSURL URLWithString:encodePath relativeToURL:[self baseURL]];
    
    return encodeURL.absoluteString;
}

+ (NSURL *)baseURL{
    
    return [YZHNetworkConfig shareNetworkConfig].baseURL;
}

+ (void)setupRetryConfig:(YZHAPIRetryConfig *)config{
    
    if (config) {
        YZHNetworkConfig *manager = [YZHNetworkConfig shareNetworkConfig];
        manager.retryConfig = config;
        manager.httpManager.requestSerializer.timeoutInterval = config.timeoutInterval;
    }
}

+ (NSString* )ConsoleOutputLogWithPath:(NSString* )path params:(NSDictionary* )params{
    
    //APILog模式，打印API信息
    NSString *encodeURL = [self urlWithPath:path];
    if ([YZHServicesConfig boolForKey:kYZHAppConfigApiLog]) {
        NSLog(@"\n GET encodeURL: %@ \n params: %@", encodeURL, params);
    }
    NSAssert(encodeURL, @"URL Can't be empty");
    return encodeURL;
}

#pragma mark -- Security Policy

- (AFSecurityPolicy *)securityPolicy{
    //TODO:参考：http://www.jianshu.com/p/4102b817ff2f
    //服务器端返回的证书与本地保存的证书中的PublicKey部分进行校验，如果正确，才继续进行，不校验证书有效期
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    return policy;
}

#pragma mark -- GET & SET
/**
 *  初始化HTTP请求管理器，加上请求头等参数
 *
 *  @param AFHTTPSessionManager HTTP请求管理器
 *
 *  @return HTTP请求管理器
 */

- (AFHTTPSessionManager *)httpManager{
    
    if (_httpManager == nil) {
        //TODO 暂时不做配置。
//        NSURLSessionConfiguration* URLSessionConfiguration = [URLSessionConfiguration ]
        AFHTTPSessionManager* httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
        // 设置HTTPS安全策略
        httpSessionManager.securityPolicy = [self securityPolicy];
        // TODO设置请求超时时间
        httpSessionManager.requestSerializer.timeoutInterval = YZHAPIDefaultTimeoutInterval;
        // HTTPHeader添加设备信息
        NSString *deviceInfoString = [[YZHDevice shareDevice] deviceInfoJsonString];
        // TODO 需和后台协商
        [httpSessionManager.requestSerializer setValue:deviceInfoString forHTTPHeaderField:@"DeviceInfo"];
        // 数据序列化处理
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        httpSessionManager.retryPolicyLogMessagesEnabled = YES;
        // TODO HOOK?
        _httpManager = httpSessionManager;
    }
    return _httpManager;
}

- (AFHTTPSessionManager *)httpJSONManager{
    
    if (_httpJSONManager == nil) {
        //TODO 暂时不做配置。
        //        NSURLSessionConfiguration* URLSessionConfiguration = [URLSessionConfiguration ]
        AFHTTPSessionManager* httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
        // 设置HTTPS安全策略
        httpSessionManager.securityPolicy = [self securityPolicy];
        // TODO设置请求超时时间
        httpSessionManager.requestSerializer.timeoutInterval = YZHAPIDefaultTimeoutInterval;
//         HTTPHeader添加设备信息
        NSString *deviceInfoString = [[YZHDevice shareDevice] deviceInfoJsonString];
//         TODO 需和后台协商
        [httpSessionManager.requestSerializer setValue:deviceInfoString forHTTPHeaderField:@"DeviceInfo"];
        // 数据序列化处理
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        httpSessionManager.retryPolicyLogMessagesEnabled = YES;
        // TODO HOOK?
        _httpJSONManager = httpSessionManager;
    }
    return _httpJSONManager;
}
// 防止 baseURL 读取失败,直接从这里设置.
- (NSURL *)baseURL{

    if (_baseURL == nil) {
        //TODO: 正式服 BaseURL  异常捕获,
        _baseURL = [NSURL URLWithString:@"https://yoloserver.yzhchain.com"];
    }
    NSAssert(_baseURL, @"_baseURL Can't be empty");
    return _baseURL;
}
@end
