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
extern NSString *const kYZHAppConfigSeverTest;
extern NSString *const kYZHAppConfigSeverAddr;
extern NSString *const kYZHAppConfigSeverAddrTest;

@interface YZHServicesConfig : NSObject

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSDictionary *defaultInfo;

+ (instancetype)shareServicesConfi;

+ (id)configValueFromKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)debugTestServerConfig;

//- (void)saveConfigInfo:(NSDictionary *)info;

@end
