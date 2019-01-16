//
//  NTESSessionListCell.m
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"

@implementation NIMSessionListCell
#define AvatarWidth 40
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.contentView addSubview:self.avatarImageView];
//        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.height.width.mas_equalTo(45);
//            make.centerY.mas_equalTo(0);
//        }];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.nameLabel.backgroundColor = [UIColor whiteColor];
        //Jersey
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font            = [UIFont yzh_commonStyleWithFontSize:16.f];
        self.nameLabel.height = 20.0f;
        [self.contentView addSubview:self.nameLabel];
//
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //Jersey
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font            = [UIFont yzh_commonStyleWithFontSize:12.f];
        self.messageLabel.height = 12.5f;
        self.messageLabel.textColor       = [UIColor lightGrayColor];
        [self.contentView addSubview:self.messageLabel];
//
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.timeLabel.backgroundColor = [UIColor whiteColor];
        //Jersey
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font            = [UIFont yzh_commonStyleWithFontSize:11.f];
        self.timeLabel.height = 13.0f;
        self.timeLabel.textColor       = [UIColor grayColor];
        [self.contentView addSubview:self.timeLabel];
        
        self.badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}


#define NameLabelMaxWidth    230.f
#define MessageLabelMaxWidth 250.f
- (void)refresh:(NIMRecentSession*)recent{
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.messageLabel.nim_width = self.messageLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.nim_width;
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //Session List
    NSInteger sessionListAvatarLeft             = 15;
    NSInteger sessionListNameTop                = 12;
    NSInteger sessionListNameLeftToAvatar       = 7;
    NSInteger sessionListMessageLeftToAvatar    = 7;
    NSInteger sessionListTimeRight              = 20;
    NSInteger sessionListTimeTop                = 12;
    NSInteger sessionBadgeTimeBottom            = 12;
    NSInteger sessionBadgeTimeRight             = 20;
    
    self.avatarImageView.nim_left    = sessionListAvatarLeft;
    self.avatarImageView.nim_centerY = self.nim_height * .5f;
    self.nameLabel.nim_top           = sessionListNameTop;
    self.nameLabel.nim_left          = self.avatarImageView.nim_right + sessionListNameLeftToAvatar;
    self.nameLabel.height = 20.0f;
    self.messageLabel.height = 12.5f;
    self.messageLabel.nim_left       = self.avatarImageView.nim_right + sessionListMessageLeftToAvatar;
    self.messageLabel.nim_bottom     = self.avatarImageView.nim_bottom;
    self.timeLabel.height = 13.0f;
    self.timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
    self.timeLabel.nim_top           = sessionListTimeTop;
    self.badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight;
    self.badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
}

@end
