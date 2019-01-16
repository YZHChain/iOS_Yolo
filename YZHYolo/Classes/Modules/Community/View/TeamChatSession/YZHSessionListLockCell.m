//
//  YZHSessionListLockCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/30.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSessionListLockCell.h"

#import "NIMAvatarImageView.h"
#import "UIImageView+YZHImage.h"

@implementation YZHSessionListLockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftAdornImageView = [[UIImageView alloc] init];
        self.leftAdornImageView.backgroundColor = [UIColor yzh_fontThemeBlue];
        
        [self.contentView addSubview:self.leftAdornImageView];
        [self.leftAdornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(4);
        }];
        
        self.avatarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatarImageView];
//        [self.avatarImageView yzh_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
        self.avatarImageView.image = [UIImage imageNamed:@"team_sessionList_lockCell_avataricon"];
        self.avatarImageView.layer.cornerRadius = 4;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.leftAdornImageView.mas_right).mas_equalTo(13);
            make.width.height.mas_equalTo(40);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont yzh_commonStyleWithFontSize:16];
        self.nameLabel.textColor = [UIColor yzh_fontShallowBlack];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.avatarImageView.mas_right).mas_equalTo(7);
            make.height.mas_equalTo(20);
        }];
        self.nameLabel.text = @"上锁群";
        
        self.lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.lockButton];
        [self.lockButton setImage:[UIImage imageNamed:@"team_sessionList_lockCell_closeIcon"] forState:UIControlStateSelected];
        [self.lockButton setImage:[UIImage imageNamed:@"team_sessionList_lockCell_openIcon"] forState:UIControlStateNormal];
        self.lockButton.selected = YES;
        [self.lockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.nameLabel.mas_right).mas_equalTo(5);
//            make.width.mas_equalTo(15);
//            make.height.mas_equalTo(15);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont yzh_commonLightStyleWithFontSize:11];
        self.timeLabel.textColor = [UIColor yzh_sessionCellGray];
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        
        self.badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        self.badgeView.hidden = YES;
        [self.contentView addSubview:self.badgeView];
        
        [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(21);
        }];
        
        self.contentView.backgroundColor = YZHColorWithRGB(247, 247, 247);
    }
    return self;
}

- (void)refresh:(NIMRecentSession* )recent{
    
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
}

- (void)refreshTeamLockRecentSeesions:(NSMutableArray<NIMRecentSession *> *)recentSessions isLock:(BOOL)isLock {
    
    NSInteger unreadCount = 0;
    for (NIMRecentSession* ression in recentSessions) {
        unreadCount += ression.unreadCount;
    }
    if (unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(unreadCount).stringValue;
    } else {
        self.badgeView.hidden = YES;
    }
    
    self.lockButton.selected = isLock;
}

@end
