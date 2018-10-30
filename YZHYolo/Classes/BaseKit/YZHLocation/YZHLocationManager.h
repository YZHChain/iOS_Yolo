//
//  YZHLocationManager.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^callLocationBlock)(void);
@interface YZHLocationManager : NSObject

@property (nonatomic, copy) NSString *country;  // 国家
@property (nonatomic, copy) NSString *province; // 当前省份
@property (nonatomic, copy) NSString *city; // 当前市
@property (nonatomic, copy) NSString *currentLocation; // 拼接当前位置;
@property(nonatomic, copy)callLocationBlock managerSucceedBlock;
@property(nonatomic, copy)callLocationBlock managerfaildBlock;

+ (instancetype)shareManager;
- (void)getLocationWithSucceed:(callLocationBlock)succeed faildBlock:(callLocationBlock)faildBlock;  //获取当前用户地理位置

@end

NS_ASSUME_NONNULL_END
