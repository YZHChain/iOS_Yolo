//
//  UIScrollView+YZHRefresh.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIScrollView+YZHRefresh.h"

#import "MJRefresh.h"
@implementation UIScrollView (YZHRefresh)

#pragma mark - Header

- (void)ym_addHeaderWithRefreshHandler:(YZHRefreshHandler)handler
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        handler();
    }];
    
    MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.mj_header;
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
}

- (void)ym_headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)ym_headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

#pragma mark - Footer

- (void)ym_addFooterWithRefreshHandler:(YZHRefreshHandler)handler
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        handler();
    }];
    
    MJRefreshBackStateFooter *footer = (MJRefreshBackStateFooter *)self.mj_footer;
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
}

- (void)ym_footerBeginRefreshing
{
    [self.mj_footer beginRefreshing];
}

- (void)ym_footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

#pragma mark - Method

- (void)ym_endRefreshing
{
    [self ym_headerEndRefreshing];
    [self ym_footerEndRefreshing];
}

@end
