//
//  NSObject+YZHExtension.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "NSObject+YZHExtension.h"

#import "MJExtension.h"

@implementation NSObject (YZHxtension)

- (instancetype)YZH_setKeyValues:(id)keyValues
{
    return [self mj_setKeyValues:keyValues];
}

+ (instancetype)YZH_objectWithKeyValues:(id)keyValues
{
    return [self mj_objectWithKeyValues:keyValues];
}

+ (NSMutableArray *)YZH_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}


+ (void)YZH_setupObjectClassInArray:(NSDictionary *(^)(void))objectClassInArray
{
    [self mj_setupObjectClassInArray:objectClassInArray];
}

+ (void)YZH_setupReplacedKeyFromPropertyName:(NSDictionary *(^)(void))replacedKeyFromPropertyName
{
    [self mj_setupReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    if ([self respondsToSelector:@selector(YZH_replacedKeyFromPropertyName)]) {
        return [self YZH_replacedKeyFromPropertyName];
    }
    return nil;
}

+ (NSDictionary *)mj_objectClassInArray
{
    if ([self respondsToSelector:@selector(YZH_objectClassInArray)]) {
        return [self YZH_objectClassInArray];
    }
    return nil;
}

#pragma mark - 模型 -> 字典

- (NSMutableDictionary *)YZH_keyValues
{
    return [self mj_keyValues];
}

+ (NSMutableArray *)YZH_keyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    return [self mj_keyValuesArrayWithObjectArray:objectArray];
}


@end
