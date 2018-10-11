//
//  UIControl+YZHClickHandle.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YZHClickHandle)

@property (nonatomic, assign) NSTimeInterval yzh_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval yzh_acceptEventTime;

@end

NS_ASSUME_NONNULL_END
