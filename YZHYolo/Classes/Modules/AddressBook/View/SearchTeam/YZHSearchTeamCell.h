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

- (void)onTouchJoinTeam:(YZHSearchModel *)model;

@end

@interface YZHSearchTeamCell : UITableViewCell

@property (nonatomic, strong) YZHSearchModel* model;
- (void)refresh:(YZHSearchModel* )model;
@property (nonatomic, weak) id<YZHSearchTeamCellProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
