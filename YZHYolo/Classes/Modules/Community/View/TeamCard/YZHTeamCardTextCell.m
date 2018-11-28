//
//  YZHTeamCardTextCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardTextCell.h"

@interface YZHTeamCardTextCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;

@end

@implementation YZHTeamCardTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    
    self.subtitleLabel.font = [UIFont yzh_commonStyleWithFontSize:14];
    self.subtitleLabel.textColor = [UIColor yzh_sessionCellGray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(YZHTeamDetailModel *)model {
    
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    
    self.guideImageView.hidden = model.notInteraction;
}

@end
