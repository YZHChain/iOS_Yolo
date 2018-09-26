//
//  YZHDevice.h
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHDevice : NSObject

@property (nonatomic, copy, readonly) NSString *UUID;//设备ID
@property (nonatomic, copy, readonly) NSString *name;//设备名
@property (nonatomic, copy, readonly) NSString *machine;//设备型号
@property (nonatomic, copy, readonly) NSString *systemName;//系统名称
@property (nonatomic, copy, readonly) NSString *systemVersion;//系统版本
@property (nonatomic, copy, readonly) NSString *resolution;//设备分辨率

+ (instancetype)shareDevice;

- (NSString *)deviceInfoJsonString;
//- (NSString *)deviceInfoJsonBase64String;

@end
