//
//  YZHTeamCardIntro.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardIntro.h"

#import "UIImageView+YZHImage.h"

@implementation YZHTeamCardIntro

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    
    self.subtitleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.subtitleLabel.textColor = [UIColor yzh_sessionCellGray];
    
    self.nameLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.nameLabel.textColor = [UIColor yzh_fontShallowBlack];
    
    [self.avatarImageView yzh_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
