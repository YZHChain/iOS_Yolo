//
//  YZHDevice.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHDevice.h"

#import "KeychainItemWrapper.h"

static id instance;
@implementation YZHDevice

#pragma mark -- init

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

+ (instancetype)shareDevice{
    
    return [[self alloc] init];
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -- Method

- (NSString *)deviceInfoJsonString{
    
    NSString* infoJsonString = [self confignInfoJson];
    infoJsonString = [infoJsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return infoJsonString;
}
//TODO: 字典异常捕获,
- (NSString *)confignInfoJson{
    
//    NSDictionary *info = @{@"uuid": self.UUID,
//                           @"name": self.name,
//                           @"machine": self.machine,
//                           @"systemName": self.systemName,
//                           @"systemVersion": self.systemVersion,
//                           @"resolution": self.resolution,
//                           };
    NSDictionary* info = @{
                           @"uuid": self.UUID,
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

#pragma GET & SET

- (NSString *)UUID
{
    //初始化keychain
    //TODO:搞清楚accessGroup为什么传nil
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:nil];
    //从keychain中取uuid
    NSString *uuidString = (NSString *)[wrapper objectForKey:(id)kSecValueData];
    //uuid为空，生成一个并存到keychain
    if (uuidString.length == 0) {
        //生成一个uuid的方法
        uuidString = [[NSUUID UUID] UUIDString];
        //去掉横杠
        //uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //将该uuid保存到keychain
        [wrapper setObject:uuidString forKey:(id)kSecValueData];
    }
    return uuidString;
}

- (NSString *)name
{
    return [UIDevice currentDevice].name;
}

//- (NSString *)machine
//{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *machineStr = [NSString stringWithCString:systemInfo.machine  encoding:NSUTF8StringEncoding];
//    return machineStr;
//}

- (NSString *)systemName
{
    return [UIDevice currentDevice].systemName;
}

- (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)resolution
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    CGFloat height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%@*%@",@(width) ,@(height)];
}

@end
