//
//  YZHServicesConfig.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHServicesConfig.h"
#import "YZHConfigKey.h"
#import "YZHCacheManager.h"

NSString *const kYZHAppConfig    = @"YZHAppConfig.plist";

NSString *const kYZHAppConfigLogToFile               = @"logToFile";
NSString *const kYZHAppConfigApiLog                  = @"apiLog";
NSString *const kYZHAppConfigApiDebug                = @"apiDebug";
NSString *const kYZHAppConfigServerTest              = @"serverTest";
NSString *const kYZHAppConfigServerAddrTest          = @"serverAddrTest";
NSString *const kYZHAppConfigServerAddr              = @"serverAddr";
NSString *const kYZHAppConfigNIMAppKeyTest           = @"NIMKeyTest";
NSString *const kYZHAppConfigNIMAppKey               = @"NIMKey";
NSString *const kYZHAppConfigNIMTest                 = @"NIMServerTest";

static id instance;
@implementation YZHServicesConfig

+ (void)initialize{
    
    [self performSelectorOnMainThread:@selector(shareServicesConfig) withObject:nil waitUntilDone:NO];
}

+ (instancetype)shareServicesConfig{
    
        static id instance;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[[self class] alloc] init];
        });
        return instance;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:YZHAppConfigFileName ofType:@"plist"];
        _defaultInfo = [NSDictionary dictionaryWithContentsOfFile:path];
        _info = (NSDictionary *)[[YZHCacheManager shareManager] objectForName:[self configFileName]];
        // 缓存配置 读取缓存
        if (_info == nil) {
            _info = [_defaultInfo copy];
        }
    }
    
    return self;
}

#pragma mark -- ReadData Method

+ (id)configValueFromKey:(NSString *)key{
    
    NSAssert(key, @"key Can't be empty");
    
    NSString* value = [YZHServicesConfig shareServicesConfig].info[key];
    
    return value;
}

+ (NSString *)stringForKey:(NSString *)key{

    id value = [YZHServicesConfig configValueFromKey:key];
    if (value) {
        return [NSString stringWithFormat:@"%@", value];
    }
    return nil;
}

+ (BOOL)boolForKey:(NSString *)key{
    
    if ([[YZHServicesConfig configValueFromKey:key] boolValue]) {
        return YES;
    } else{
        return NO;
    }
}

+ (NSString *)debugTestServerConfig {
    
    NSString* appConfigSeverKey;
    // 关闭则是正式,开启则是测试.
    if ([[self stringForKey:kYZHAppConfigServerTest] boolValue]) {
        appConfigSeverKey = kYZHAppConfigServerAddrTest;
    } else {
        appConfigSeverKey = kYZHAppConfigServerAddr;
    }
    return [self stringForKey:appConfigSeverKey];
}

+ (NSString *)debugTestNIMAppKeyConfig {
    
    NSString* appConfigNIMAppKey;
    // 关闭则是正式,开启则是测试.
    if ([[self stringForKey:kYZHAppConfigNIMTest] boolValue]) {
        appConfigNIMAppKey = kYZHAppConfigNIMAppKeyTest;
    } else {
        appConfigNIMAppKey = kYZHAppConfigNIMAppKey;
    }

    return [self stringForKey:appConfigNIMAppKey];
}

#pragma mark -- ConfigCache

//保存配置信息，重启后生效
- (void)saveConfigInfo:(NSDictionary *)info
{
    [[YZHCacheManager shareManager] saveObject:info forName:[self configFileName]];
}

- (NSString *)configFileName
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *name = [NSString stringWithFormat:@"%@---%@",kYZHAppConfig ,appVersion];
    return name;
}

@end
