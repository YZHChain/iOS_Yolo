//
//  YZHRouter.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHRouter : NSObject

+ (BOOL)openURL:(NSString *)url;
+ (BOOL)openURL:(NSString *)url info:(NSDictionary *)info;

+ (void)configRoute:(NSString* )routePattern handler:(BOOL (^)(NSDictionary* parameters))handlerBlock;
+ (void)configRoute:(NSString *)routePattern forScheme:(NSString *)scheme handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;

@end

@interface YZHRouter (YMRouterHandle)

+ (instancetype)shareRouter;

+ (void)openCacheURL;
+ (void)handleRouterURL:(NSString *)url source:(NSString *)source;
+ (void)handleUniversalLink:(NSURL *)url;

@end
