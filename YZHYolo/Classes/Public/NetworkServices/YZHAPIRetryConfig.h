//
//  YZHAPIRetryConfig.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSTimeInterval const YMAPIDefaultTimeoutInterval = 8.0; //缺省请求超时时间

//API请求重试类型
typedef NS_ENUM(NSInteger, YMAPIRetryType) {
    YMAPIRetryTypeNone      = 0, //不重试
    YMAPIRetryTypeTimeout   = 1, //请求超时
    YMAPIRetryType504       = 2, //HTTP错误等于504
    YMAPIRetryType5xx       = 3, //HTTP错误大于500，但不等于504
};

@interface YZHAPIRetryConfig : NSObject

@property (nonatomic, assign) NSTimeInterval timeoutInterval;       //请求超时时间
@property (nonatomic, assign) NSInteger timeoutRetryCount;          //请求超时重试次数
@property (nonatomic, assign) NSTimeInterval timeoutRetryInterval;  //请求超时重试间隔
@property (nonatomic, assign) NSInteger fzfRetryCount;              //504错误重试次数
@property (nonatomic, assign) NSTimeInterval fzfRetryInterval;      //504错误重试间隔
@property (nonatomic, assign) NSInteger fxxRetryCount;              //5xx错误重试次数
@property (nonatomic, assign) NSTimeInterval fxxRetryInterval;      //5xx错误重试间隔

@end
