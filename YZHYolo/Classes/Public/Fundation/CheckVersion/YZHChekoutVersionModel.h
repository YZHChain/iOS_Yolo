//
//  YZHChekoutVersionModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHChekoutVersionModel : NSObject

@property (nonatomic, copy) NSString* title; // 提示文案
@property (nonatomic, assign) BOOL updateState; // 是否需要更新 0 更新 1不需要
@property (nonatomic, assign) BOOL updateForced; // 是否强更 0 不需要, 1 强更
@property (nonatomic, copy) NSString* updateContent; // 更新内容
@property (nonatomic, copy) NSString* fileSize; //    文件大小
@property (nonatomic, copy) NSString* installCatalog; // 跳转地址

@end

NS_ASSUME_NONNULL_END
