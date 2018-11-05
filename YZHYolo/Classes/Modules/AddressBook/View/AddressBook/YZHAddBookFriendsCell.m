//
//  YZHAddBookFriendsCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookFriendsCell.h"

#import "NIMAvatarImageView.h"
#import "UIImageView+YZHImage.h"

static NSString* const kYZHFriendsCellIdentifier = @"friendsCellIdentifier";
@implementation YZHAddBookFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_photoImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [tableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil]   forCellReuseIdentifier:kYZHFriendsCellIdentifier];
    });
    
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHFriendsCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)refreshUser:(YZHContactMemberModel *)member {
    
    self.titleLabel.text = member.info.showName;
    NSString *imageUrl = member.info.avatarUrlString ? member.info.avatarUrlString : nil;
    [_photoImageView yzh_setImageWithString:imageUrl placeholder:@"addBook_cover_cell_photo_default"];
    NSString* showNickName = member.info.nickName ? [NSString stringWithFormat:@"(%@)", member.info.nickName] : nil;
    self.subtitleLabel.text = showNickName;
}


@end
