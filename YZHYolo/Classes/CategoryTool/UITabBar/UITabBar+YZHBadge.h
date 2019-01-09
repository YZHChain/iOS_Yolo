//
//  UITabBar+YZHBadge.h
//  YZHYolo
//
//  Created by Jersey on 2019/1/9.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (YZHBadge)

- (void)yzh_showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)yzh_hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end

NS_ASSUME_NONNULL_END
