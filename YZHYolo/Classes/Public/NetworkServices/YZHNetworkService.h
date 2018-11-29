//
//  YZHNetworkService.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHNetworkService : NSObject

+ (instancetype)shareService;

- (void)GETNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id obj))successCompletion failureCompletion:(void (^)(NSError *error))failureCompletion;
- (void)POSTNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id obj))successCompletion failureCompletion:(void (^)(NSError *error))failureCompletion;
// 规范与前面不同意的接口暂时先调这里.
- (void)POSTGDLNetworkingResource:(NSString *)path params:(NSDictionary *)params successCompletion:(void (^)(id obj))successCompletion failureCompletion:(void (^)(NSError *error))failureCompletion;

@end
