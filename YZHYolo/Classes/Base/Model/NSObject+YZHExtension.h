//
//  NSObject+YZHExtension.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YZHKeyValue <NSObject>

@optional

+ (NSDictionary *)YZH_replacedKeyFromPropertyName;
+ (NSDictionary *)YZH_objectClassInArray;

@end

@interface NSObject (YZHExtension) <YZHKeyValue>

- (instancetype)YZH_setKeyValues:(id)keyValues;

+ (instancetype)YZH_objectWithKeyValues:(id)keyValues;
+ (NSMutableArray *)YZH_objectArrayWithKeyValuesArray:(id)keyValuesArray;

+ (void)YZH_setupObjectClassInArray:(NSDictionary *(^)(void))objectClassInArray;
+ (void)YZH_setupReplacedKeyFromPropertyName:(NSDictionary *(^)(void))replacedKeyFromPropertyName;

- (NSMutableDictionary *)YZH_keyValues;
+ (NSMutableArray *)YZH_keyValuesArrayWithObjectArray:(NSArray *)objectArray;

@end
