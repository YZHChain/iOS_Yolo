//
//  YZHTeamNoticeSelectedTeamCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeSelectedTeamCell.h"

#import "UIImageView+YZHImage.h"
@interface YZHTeamNoticeSelectedTeamCell()

@property (weak, nonatomic) IBOutlet UIImageView *teamAvatarImageView;

@end

@implementation YZHTeamNoticeSelectedTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.teamAvatarImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    self.teamNameLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.teamNameLabel.font = [UIFont yzh_commonStyleWithFontSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refresh:(NIMTeam *)team {
    
    if (team.avatarUrl) {
        [self.teamAvatarImageView yzh_setImageWithString:team.avatarUrl placeholder:@"team_cell_photoImage_default"];
    }
    self.teamNameLabel.text = team.teamName;
}

- (UIImageView *)selectedImageView {
    
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.image = [UIImage imageNamed:@"my_information_setName_selected"];
        _selectedImageView.x = YZHScreen_Width - 36;
        _selectedImageView.y = (self.height / 2) - _selectedImageView.height / 2;
        [_selectedImageView sizeToFit];
    }
    return _selectedImageView;
}

@end
