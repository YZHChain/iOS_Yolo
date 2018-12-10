//
//  YZHUserDataManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHUserDataModel : NSObject<NSSecureCoding>

@property (nonatomic, strong) NSMutableArray<NSString *>* teamLabel; //用户所推荐群标签

@end

@interface YZHUserDataManage : NSObject

@property (nonatomic, strong, nullable) YZHUserDataModel* currentUserData;
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
