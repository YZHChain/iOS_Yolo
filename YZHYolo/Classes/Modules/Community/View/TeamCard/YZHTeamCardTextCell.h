//
//  YZHTeamCardTextCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHTeamCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamCardTextCell : UITableViewCell

- (void)refreshWithModel:(YZHTeamDetailModel* )model;

@end

NS_ASSUME_NONNULL_END
