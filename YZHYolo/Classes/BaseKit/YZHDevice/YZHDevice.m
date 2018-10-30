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
    
    NSDictionary *info = @{@"uuid": self.UUID,
                           @"name": self.name,
                           @"machine": self.machine,
                           @"systemName": self.systemName,
                           @"systemVersion": self.systemVersion,
                           @"resolution": self.resolution,
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

#pragma GET & SET

@end
