//
//  YZHSearchTeamCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHSearchModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YZHSearchTeamCellProtocol <NSObject>

@optional
- (void)onTouchJoinTeam:(YZHSearchModel *)model;
- (void)onTouchJoinRecruitTeam:(YZHSearchRecruitModel *)model;

@end

@interface YZHSearchTeamCell : UITableViewCell

@property (nonatomic, strong) YZHSearchModel* model;
@property (nonatomic, strong) YZHSearchRecruitModel* recruitModel;
- (void)refresh:(YZHSearchModel* )model;
- (void)refreshRecruit:(YZHSearchRecruitModel *)model;
@property (nonatomic, weak) id<YZHSearchTeamCellProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
