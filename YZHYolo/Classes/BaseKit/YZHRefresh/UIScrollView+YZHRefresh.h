//
//  UIScrollView+YZHRefresh.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YZHRefreshHandler)(void);

@interface UIScrollView (YZHRefresh)

- (void)ym_addHeaderWithRefreshHandler:(YZHRefreshHandler)handler;
- (void)ym_headerBeginRefreshing;
- (void)ym_headerEndRefreshing;

- (void)ym_addFooterWithRefreshHandler:(YZHRefreshHandler)handler;
- (void)ym_footerBeginRefreshing;
- (void)ym_footerEndRefreshing;

- (void)ym_endRefreshing;

@end
