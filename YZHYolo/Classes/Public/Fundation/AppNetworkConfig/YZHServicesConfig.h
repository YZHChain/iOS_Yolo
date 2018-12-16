//
//  YZHServicesConfig.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kYZHAppConfigLogToFile;
extern NSString *const kYZHAppConfigApiLog;
extern NSString *const kYZHAppConfigApiDebug;
extern NSString *const kYZHAppConfigServerTest;
extern NSString *const kYZHAppConfigServerAddrTest;
extern NSString *const kYZHAppConfigServerAddr;
extern NSString *const kYZHAppConfigNIMAppKeyTest;
extern NSString *const kYZHAppConfigNIMAppKey;
extern NSString *const kYZHAppConfigNIMTest;

@interface YZHServicesConfig : NSObject

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSDictionary *defaultInfo;
@property (nonatomic, assign) BOOL showDebugView;

+ (instancetype)shareServicesConfig;

+ (id)configValueFromKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)debugTestServerConfig;
+ (NSString *)debugTestNIMAppKeyConfig;

- (void)saveConfigInfo:(NSDictionary *)info;

@end
