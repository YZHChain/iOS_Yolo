//
//  YZHTeamMemberManageCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberManageCell.h"

#import "UIButton+YZHTool.h"
#import "UIImageView+YZHImage.h"
@interface YZHTeamMemberManageCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YZHTeamMemberManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.avatarImageView yzh_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    
    [self.bannedButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:12]];
    [self.bannedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bannedButton.layer.cornerRadius = 2;
    self.bannedButton.layer.masksToBounds = YES;
    [self.bannedButton yzh_setBackgroundColor:[UIColor yzh_separatorLightGray] forState:UIControlStateSelected];
    [self.bannedButton yzh_setBackgroundColor:[UIColor yzh_buttonBackgroundPinkRed] forState:UIControlStateNormal];
    [self.bannedButton setTitle:@"禁言" forState:UIControlStateNormal];
    [self.bannedButton setTitle:@"解除禁言" forState:UIControlStateSelected];
    
    [self.kickOutButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:12]];
    [self.kickOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.kickOutButton yzh_setBackgroundColor:YZHColorWithRGB(0, 46, 96) forState:UIControlStateNormal];
    self.kickOutButton.layer.cornerRadius = 2;
    self.kickOutButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refresh:(YZHContactMemberModel *)member {
    
    self.member = member;
    NIMTeamMember* teamMember = [[[NIMSDK sharedSDK] teamManager] teamMember:member.info.infoId inTeam:self.teamId];
    if (YZHIsString(teamMember.nickname)) {
        self.titleLabel.text = teamMember.nickname;
    } else {
        self.titleLabel.text = member.info.showName;
    }
    if (YZHIsString(member.info.avatarUrlString)) {
        [self.avatarImageView yzh_setImageWithString:member.info.avatarUrlString placeholder:@"addBook_cover_cell_photo_default"];
    }
}

- (IBAction)clickBanned:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(onTouchBannedWithMember:)]) {
        [self.delegete onTouchBannedWithMember:self.member];
    }
}

- (IBAction)clickKickOut:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(onTouchKickOutWithMember:)]) {
        [self.delegete onTouchKickOutWithMember:self.member];
    }
}


@end
