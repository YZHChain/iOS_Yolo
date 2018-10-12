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

typedef CGFloat YZHHeightFloat;

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
typedef void(^YZHButtonExecuteBlock)(UIButton *sender);

#pragma mark - NetWorkin
/**
 *    @author Jersey
 *
 *    YZH统一使用这个类型传参
 */
typedef NSDictionary* YZHParams;
/**
 *    @author Jersey
 *
 *    网易IM统一使用这个类型传参
 */
typedef NSDictionary* YZHIMParams;
/**
 *    @author Jersey
 *
 *    下面三个 Key 是后台 Respone 包含的三个 Key。
 */
extern NSString * const kYZHResponeCodeKey;

extern NSString * const kYZHResponeMessageKey;

extern NSString * const kYZHResponeDataKey;

#pragma mark - TableView SubView Identifier Size

/**
 *    @author Jersey
 *
 *    The common SectionHeader identifier
 */
extern NSString * const kYZHCommonHeaderIdentifier;
/**
 *    @author Jersey
 *
 *    The common cell identifier
 */
extern NSString * const kYZHCommonCellIdentifier;
/**
 *    @author Jersey
 *
 *    The common CellHeight
 */
extern YZHHeightFloat const kYZHCellHeight;
/**
 *    @author Jersey
 *
 *    The common SectionHeight
 */
extern YZHHeightFloat const kYZHSectionHeight;

/**
 *    @author Jersey
 *
 *    The common SectionHeight
 */
extern YZHHeightFloat const kYZHSectionSecondHeight;

#pragma mark -- Key

/**
 *    @author Jersey
 *
 *    The common NonnullKey
 */
extern NSString * const kYZHCommonNonnullKey;
NS_ASSUME_NONNULL_BEGIN

@interface YZHIdentification : NSObject

@end

NS_ASSUME_NONNULL_END
