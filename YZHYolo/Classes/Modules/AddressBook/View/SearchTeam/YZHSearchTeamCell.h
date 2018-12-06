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

@protocol YZHSearchTeamProtocol <NSObject>

- (void)onTouchJoinTeam:(YZHTTTTeamModel *)model;

@end

@interface YZHSearchTeamCell : UITableViewCell

@property (nonatomic, strong) YZHTTTTeamModel* model;
- (void)refresh:(YZHTTTTeamModel* )model;
@property (nonatomic, weak) id<YZHSearchTeamProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
