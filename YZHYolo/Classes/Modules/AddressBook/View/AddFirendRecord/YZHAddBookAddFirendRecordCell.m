//
//  YZHAddBookAddFirendRecordCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendRecordCell.h"

#import "YZHPublic.h"
static NSString* kAddFirendRecordCellDating = @"addFirendRecordCellDating";
static NSString* kAddFirendRecordCellReview = @"addFirendRecordCellReview";
@implementation YZHAddBookAddFirendRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (self.datingButton) {
        self.datingButton.layer.borderWidth = 1;
        self.datingButton.layer.borderColor = [UIColor yzh_backgroundThemeGray].CGColor;
    }
    [self.photoImageView yzh_cornerRadiusAdvance:3.0f rectCornerType:UIRectCornerAllCorners];
    self.photoImageView.image = [UIImage imageNamed:@"addBook_cover_cell_photo_default"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHAddFirendRecordCellType)cellType {
    
    NSString* identifierID;
    if (cellType == YZHAddFirendRecordCellTypeDating) {
        identifierID = kAddFirendRecordCellDating;
    } else {
        identifierID = kAddFirendRecordCellReview;
    }
    
    YZHAddBookAddFirendRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"YZHAddBookAddFirendRecordCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:cellType];
    }
    
    return cell;
}

- (void)update:(YZHAddFriendRecordModel *)model {
    
    self.nameLabel.text = model.member.info.showName;
    NSString *imageUrl = model.member.info.avatarUrlString ? model.member.info.avatarUrlString : nil;
    //TODO: 加载图片方法需优化.
    if (imageUrl) {
        [_photoImageView yzh_setImageWithString:imageUrl placeholder:@"addBook_cover_cell_photo_default"];
    }
    NSString* showNickName = model.member.info.nickName ? [NSString stringWithFormat:@"(%@)", model.member.info.nickName] : nil;
    self.nickNameLabel.text = showNickName;
    
}

@end
