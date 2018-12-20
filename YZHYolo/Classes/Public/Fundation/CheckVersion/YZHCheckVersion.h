//
//  YZHCheckVersion.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHChekoutVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHCheckVersion : NSObject

+ (instancetype)shareInstance;
- (void)checkoutCurrentVersionUpdataCompletion:(YZHVoidBlock)completion;
@property (nonatomic, strong) YZHChekoutVersionModel* model;

@end

NS_ASSUME_NONNULL_END
