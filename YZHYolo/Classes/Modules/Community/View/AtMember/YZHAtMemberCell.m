//
//  YZHAtMemberCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAtMemberCell.h"

#import "UIImageView+YZHImage.h"
@interface YZHAtMemberCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation YZHAtMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_photoImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshAtmember:(YZHContactMemberModel *)member {
    
    NIMTeamMember* teamMember = [[[NIMSDK sharedSDK] teamManager] teamMember:member.info.infoId inTeam:self.teamId];
    //有限限制群昵称,如果有则后面接用户昵称。 如果没有群昵称则单独显示用户昵称。
    if (YZHIsString(teamMember.nickname)) {
        self.titleLabel.text = teamMember.nickname;
        self.subtitleLabel.text = member.info.showName;
    } else {
        self.titleLabel.text = member.info.showName;
        self.subtitleLabel.text = nil;
    }
    NSString *imageUrl = member.info.avatarUrlString ? member.info.avatarUrlString : nil;
    //TODO: 加载图片方法需优化.
    if (imageUrl) {
        [_photoImageView yzh_setImageWithString:imageUrl placeholder:@"addBook_cover_cell_photo_default"];
    }
}

- (UIImageView *)selectedImageView {
    
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_information_setName_selected"]];
        _selectedImageView.x = YZHScreen_Width - 36;
        _selectedImageView.y = (self.height / 2) - _selectedImageView.height / 2;
        [_selectedImageView sizeToFit];
    }
    return _selectedImageView;
}

@end
