//
//  YZHRouter.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRouter.h"

#import "JLRoutes.h"

static id instance;
@interface YZHRouter()

@property (nonatomic, copy) NSString *cacheURL;
@property (nonatomic, strong) NSDictionary *cacheInfo;

@end

@implementation YZHRouter

#pragma mark -- init

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

+ (instancetype)shareRouter{
    
    return [[self alloc] init];
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -- RouterSkip

+ (BOOL)openURL:(NSString *)url
{
    return [self routeURL:url info:nil];
}

+ (BOOL)openURL:(NSString *)url info:(NSDictionary *)info
{
    return [self routeURL:url info:info];
}

+ (BOOL)routeURL:(NSString *)url info:(NSDictionary *)info{
    
    NSLog(@"%s %@ %@",__func__ ,url ,info);
    
    //TODO:url不为NSString(或为空)时跳到Route错误页
    if (([url isKindOfClass:[NSString class]]==NO) || (info && [info isKindOfClass:[NSDictionary class]]==NO)) {
        NSLog(@"%s参数类型有误，url:%@ info:%@",__func__ ,url.class ,info.class);
        return NO;
    }
    
    return [JLRoutes routeURL:[NSURL URLWithString:url] withParameters:info];
    
}

#pragma mark -- JLRouter Config

+ (void)configRoute:(NSString* )routePattern handler:(BOOL (^)(NSDictionary* parameters))handlerBlock{
    
    // 可以在这一层添加一些公共参数处理等.
//    [JLRoutes addRoutes:<#(nonnull NSArray *)#> handler:<#^BOOL(NSDictionary * _Nonnull parameters)handlerBlock#>]
    [JLRoutes addRoute:routePattern handler:handlerBlock];
}

+ (void)configRoute:(NSString *)routePattern forScheme:(NSString *)scheme handler:(BOOL (^)(NSDictionary *))handlerBlock{
    
}

@end

@implementation YZHRouter (TZHRouterHandle)



@end
