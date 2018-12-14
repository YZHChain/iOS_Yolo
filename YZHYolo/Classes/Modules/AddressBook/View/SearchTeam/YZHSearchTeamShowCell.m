//
//  YZHSearchTeamShowCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchTeamShowCell.h"

#import "UIImageView+YZHImage.h"

@interface YZHSearchTeamShowCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YZHSearchTeamShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = 2;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refresh:(NIMTeam *)model {
    
    self.model = model;
    if (YZHIsString(model.avatarUrl)) {
        [self.avatarImageView yzh_setImageWithString: model.avatarUrl placeholder:@"team_cell_photoImage_default"];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"team_cell_photoImage_default"];
    }
    self.titleLabel.text = model.teamName ? model.teamName : @"群聊";
}

@end
