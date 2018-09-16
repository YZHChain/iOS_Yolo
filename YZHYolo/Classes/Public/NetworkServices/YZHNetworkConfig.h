//
//  YZHNetworkConfig.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHAPIRetryConfig.h"

@interface YZHNetworkConfig : NSObject


+ (NSURL *)baseURL;
+ (void)setupRetryConfig:(YZHAPIRetryConfig *)config;
+ (void)GETNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id obj))successCompletion failureCompletion:(void (^)(NSError *error))failureCompletion;
+ (void)POSTNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id obj))successCompletion failureCompletion:(void (^)(NSError *error))failureCompletion;

@end
