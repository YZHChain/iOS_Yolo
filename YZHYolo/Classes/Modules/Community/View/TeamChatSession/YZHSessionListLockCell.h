//
//  YZHSessionListLockCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/30.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "NIMSessionListCell.h"

#import "NIMBadgeView.h"
#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface YZHSessionListLockCell : MGSwipeTableCell

@property (nonatomic, strong) UIImageView* leftAdornImageView;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) NIMRecentSession* session;
@property (nonatomic, strong) UIButton* lockButton;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) NIMBadgeView *badgeView;

- (void)refreshTeamLockRecentSeesions:(NSMutableArray<NIMRecentSession *> *)recentSessions isLock:(BOOL)isLock;

@end


NS_ASSUME_NONNULL_END
