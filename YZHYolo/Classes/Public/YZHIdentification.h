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
typedef void(^YZHButtonBlock)(UIButton *sender);



#pragma mark - TableView SubView Identifier Size

/**
 *    @author https://github.com/ZexiFangkong
 *
 *    The common SectionHeader identifier
 */
extern NSString * const kYZHCommonHeaderIdentifier;
/**
 *    @author https://github.com/ZexiFangkong
 *
 *    The common cell identifier
 */
extern NSString * const kYZHCommonCellIdentifier;
/**
 *    @author https://github.com/ZexiFangkong
 *
 *    The common CellHeight
 */
extern YZHHeightFloat const kYZHCellHeight;
/**
 *    @author https://github.com/ZexiFangkong
 *
 *    The common SectionHeight
 */
extern YZHHeightFloat const kYZHSectionHeight;

/**
 *    @author https://github.com/ZexiFangkong
 *
 *    The common SectionHeight
 */
extern YZHHeightFloat const kYZHSectionSecondHeight;

#pragma mark -- Key

/**
 *    @author https://github.com/ZexiFangkong
 *
 *    The common NonnullKey
 */
extern NSString * const kYZHCommonNonnullKey;
NS_ASSUME_NONNULL_BEGIN

@interface YZHIdentification : NSObject

@end

NS_ASSUME_NONNULL_END
