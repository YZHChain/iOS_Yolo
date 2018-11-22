//
//  YZHSharedFunctionView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHSharedFunctionView : UIView

@property (nonatomic, copy) YZHButtonExecuteBlock firendSharedBlock;
@property (nonatomic, copy) YZHButtonExecuteBlock teamSharedBlock;
@property (nonatomic, copy) YZHButtonExecuteBlock cancelBlock;

@end

NS_ASSUME_NONNULL_END
