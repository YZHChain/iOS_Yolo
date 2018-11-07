//
//  NSObject+YZHApiModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "NSObject+YZHApiModel.h"

#import <objc/runtime.h>
#pragma mark - Setter/Getter

@implementation NSObject (YZHApiModel)

- (NSString *)yzh_apiCode
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYzh_apiCode:(NSString *)yzh_apiCode
{
    objc_setAssociatedObject(self, @selector(yzh_apiCode), yzh_apiCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)yzh_apiDetail
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYzh_apiDetail:(NSString *)yzh_apiDetail
{
    objc_setAssociatedObject(self, @selector(yzh_apiDetail), yzh_apiDetail, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)yzh_apiEmptyValue {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYzh_apiEmptyValue:(BOOL )yzh_apiEmptyValue {
    
    objc_setAssociatedObject(self, @selector(yzh_apiEmptyValue), @(yzh_apiEmptyValue), OBJC_ASSOCIATION_ASSIGN);
    
}

@end
