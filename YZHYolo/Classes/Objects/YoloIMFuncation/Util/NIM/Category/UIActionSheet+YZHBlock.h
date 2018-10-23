//
//  UIActionSheet+YZHBlock.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ActionSheetBlock)(NSInteger);
@interface UIActionSheet (YZHBlock)
- (void)showInView: (UIView *)view completionHandler: (ActionSheetBlock)block;
- (void)clearActionBlock;
@end

NS_ASSUME_NONNULL_END
