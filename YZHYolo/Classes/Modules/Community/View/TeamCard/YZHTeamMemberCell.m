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
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation YZHTeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    
    self.subtitleLabel.font = [UIFont yzh_commonStyleWithFontSize:12];
    self.subtitleLabel.textColor = [UIColor yzh_separatorLightGray];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
