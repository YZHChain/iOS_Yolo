//
//  UIView+YZHStatusView.h
//  YZHYolo
//
//  Created by Jersey on 2019/1/14.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface UIView (YZHStatusView)

- (UIView *)yzh_beginLoadingWithText:(NSString *)text;
- (void)yzh_endLoading;

- (UIView *)yzh_showErrorViewWithHandler:(YZHErrorBlock)handler;
- (void)yzh_hideErrorView;

- (UIView *)yzh_showEmptyViewWithImage:(UIImage *)image text:(NSString *)text;
- (void)yzh_hideEmptyView;

- (void)yzh_removeStatusView;

@end

NS_ASSUME_NONNULL_END
