//
//  YZHAnalytics.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/21.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHAnalytics.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

static NSString* KYZHUmengProAppKey = @"5c452c89f1f55678950000d9"; //生产
static NSString* KYZHUmengDevAppKey = @""; //开发

@implementation YZHAnalytics

+ (void)stactAnalytics {
    
    //友盟统计
    [self startUmeng];
    //异常统计上报,
    [self startCrashSDK];
}

+ (void)startUmeng {
    
#if DEBUG
    [UMConfigure setEncryptEnabled:NO];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:KYZHUmengDevAppKey channel:nil];
#else
    [UMConfigure setEncryptEnabled:YES];
    [UMConfigure setLogEnabled:NO];
    [UMConfigure initWithAppkey:KYZHUmengProAppKey channel:nil];
#endif
    
}

+ (void)startCrashSDK {
    
    //暂时使用 UMeng
#if DEBUG
    [MobClick setCrashReportEnabled:NO];
#else
    [MobClick setCrashReportEnabled:YES];
#endif
    
}

@end
