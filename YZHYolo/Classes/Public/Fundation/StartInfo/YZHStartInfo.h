//
//  YZHStartInfo.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHStartInfo : NSObject

+ (instancetype)shareInstance;
- (void)checkUserEveryDayTask; //检查当前账号,是否已调用今日任务接口

@end

NS_ASSUME_NONNULL_END
