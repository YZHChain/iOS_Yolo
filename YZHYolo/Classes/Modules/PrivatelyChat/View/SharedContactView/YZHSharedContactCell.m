//
//  YZHSharedContactCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSharedContactCell.h"

#import "UIImageView+YZHImage.h"
@interface YZHSharedContactCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation YZHSharedContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_photoImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUser:(YZHContactMemberModel *)member {
    
    self.titleLabel.text = member.info.showName;
    NSString *imageUrl = member.info.avatarUrlString ? member.info.avatarUrlString : nil;
    //TODO: 加载图片方法需优化.
    if (imageUrl) {
        [_photoImageView yzh_setImageWithString:imageUrl placeholder:@"addBook_cover_cell_photo_default"];
    }
    NSString* showNickName = member.info.nickName ? [NSString stringWithFormat:@"(%@)", member.info.nickName] : nil;
    self.subtitleLabel.text = showNickName;
}

- (void)refreshTeam:(NIMTeam *)team {
    
    self.titleLabel.text = team.teamName;
    NSString *imageUrl = team.avatarUrl ? team.avatarUrl : nil;
    //TODO: 加载图片方法需优化.
    if (imageUrl) {
        [_photoImageView yzh_setImageWithString:imageUrl placeholder:@"team_createTeam_avatar_icon_normal"];
    } else {
        [_photoImageView setImage:[UIImage imageNamed:@"team_createTeam_avatar_icon_normal"]];
    }
//    NSString* showNickName = member.info.nickName ? [NSString stringWithFormat:@"(%@)", member.info.nickName] : nil;
    self.subtitleLabel.text = nil;
}

- (UIImageView *)selectedImageView {

    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_information_setName_selected"]];
        _selectedImageView.right = self.width - 44;
        _selectedImageView.y = (self.height / 2) - _selectedImageView.height / 2;
        [_selectedImageView sizeToFit];
    }
    return _selectedImageView;
}

@end
