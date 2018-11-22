//
//  YZHTeamCardHeaderView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHTeamCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamCardHeaderView : UITableViewHeaderFooterView

- (void)refreshWithModel:(YZHTeamHeaderModel* )model;
@property (nonatomic, copy) YZHButtonExecuteBlock headerHandle;

@end

NS_ASSUME_NONNULL_END
