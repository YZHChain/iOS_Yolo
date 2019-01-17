//
//  YZHTeamCardImageCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardImageCell.h"

@interface YZHTeamCardImageCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *functionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;

@end

@implementation YZHTeamCardImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_default"];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(YZHTeamDetailModel *)model {
    
    self.titleLabel.text = model.title;
    self.functionImageView.image = [UIImage imageNamed:model.imageName];
    self.subTitleLabel.text = model.subtitle;
    
}

@end
