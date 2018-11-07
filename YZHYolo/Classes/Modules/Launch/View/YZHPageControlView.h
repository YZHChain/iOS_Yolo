//
//  YZHPageControlView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/7.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHPageControlView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void(^executeBlock)(NSInteger selectedIndex);

@end

NS_ASSUME_NONNULL_END
