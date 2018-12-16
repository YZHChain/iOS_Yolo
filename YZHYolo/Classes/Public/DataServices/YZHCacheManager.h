//
//  YZHCacheManager.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/16.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHCacheManager : NSObject

@property (nonatomic, assign) NSUInteger size;

+ (instancetype)shareManager;

// 把对象归档存到沙盒里
- (void)saveObject:(id<NSCoding>)object forName:(NSString *)name;
// 从沙盒中取出归档对象
- (id<NSCoding>)objectForName:(NSString *)name;
// 删除沙盒中的归档对象
- (void)removeObjectForName:(NSString *)name;

- (BOOL)cacheJsonData:(NSDictionary *)info forNameSpace:(NSString *)nameSpace;
- (NSDictionary *)freshJsonData:(NSDictionary *)info ForNameSpace:(NSString *)nameSpace;
- (NSString *)cacheTimeForNameSpace:(NSString *)nameSpace;

- (void)cleanCache:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
