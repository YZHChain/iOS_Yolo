//
//  YZHIdentification.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/7.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Blocks

/**
 *    This is a common block for handling error.
 */
typedef void (^YZHErrorBlock)(NSError *error);

/**
 * This is a void block.
 */
typedef void (^YZHVoidBlock)(void);

/**
 *    This is a common block for handling to return a string value.
 */
typedef void (^YZHStringBlock)(NSString *result);

/**
 * For single button block.
 */
typedef void(^YZHButtonBlock)(UIButton *sender);

#pragma mark - Cell
/**
 *    @author https://github.com/CoderJackyHuang
 *
 *    The common cell identifier
 */
static const NSString *kYZHCellIdentifier = @"YZHCommonCellIdentifier";

NS_ASSUME_NONNULL_BEGIN

@interface YZHIdentification : NSObject

@end

NS_ASSUME_NONNULL_END
