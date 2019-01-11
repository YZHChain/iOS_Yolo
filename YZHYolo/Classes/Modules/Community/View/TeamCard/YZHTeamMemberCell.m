//
//  YZHTeamMemberCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberCell.h"

#import "UIImageView+YZHImage.h"
@interface YZHTeamMemberCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YZHTeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.avatarImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath teamOwner:(BOOL)teamOwner {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    YZHTeamMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"YZHTeamMemberCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        if (teamOwner) {
            cell = [nib instantiateWithOwner:nil options:nil].lastObject;
        } else {
            cell = [nib instantiateWithOwner:nil options:nil].firstObject;
        }
    }
    return cell;
}

- (void)refresh:(YZHContactMemberModel *)member {
    
    self.member = member;
    self.titleLabel.text = member.info.showName;
    if (YZHIsString(member.info.avatarUrlString)) {
        [self.avatarImageView yzh_setImageWithString:member.info.avatarUrlString placeholder:@"addBook_cover_cell_photo_default"];
    }
}

@end
