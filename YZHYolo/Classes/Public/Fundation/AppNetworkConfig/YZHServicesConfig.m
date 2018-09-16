//
//  YZHServicesConfig.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHServicesConfig.h"
#import "YZHConfigKey.h"

NSString *const kYZHAppConfig    = @"YMAppConfig.plist";

NSString *const kYZHAppConfigLogToFile       = @"logToFile";
NSString *const kYZHAppConfigApiLog          = @"apiLog";
NSString *const kYZHAppConfigApiDebug        = @"apiDebug";
NSString *const kYZHAppConfigSeverTest       = @"severTest";
NSString *const kYZHAppConfigSeverAddr       = @"severAddr";
NSString *const kYZHAppConfigSeverAddrTest   = @"severAddrTest";

static id instance;
@implementation YZHServicesConfig

+ (void)initialize{
    
    [self performSelectorOnMainThread:@selector(shareServicesConfi) withObject:nil waitUntilDone:NO];
}

+ (instancetype)shareServicesConfi{

    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:YZHAppConfigFileName ofType:@"plist"];
        _defaultInfo = [NSDictionary dictionaryWithContentsOfFile:path];
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
    // TODO: Key 不存在会崩溃吗？ 要测试下
    NSString* value = [YZHServicesConfig shareServicesConfi].info[key];
    
    return value;
}

+ (NSString *)stringForKey:(NSString *)key{

    id value = [YZHServicesConfig configValueFromKey:key];
    if (value) {
        // TODO: Test  还有什么优雅的转换方法
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

#pragma mark -- ConfigCache

@end
