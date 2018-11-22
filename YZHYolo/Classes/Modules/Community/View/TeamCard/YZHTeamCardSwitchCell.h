//
//  YZHTeamCardSwitchCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHTeamCardModel.h"
#import "YZHPrivacySettingCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamCardSwitchCell : UITableViewCell

@property (nonatomic, strong) YZHTeamDetailModel* model;
@property (nonatomic, strong) NSIndexPath* indexPath;

- (void)refreshWithModel:(YZHTeamDetailModel* )model;
@property (nonatomic, weak) id<YZHSwitchProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
