//
//  YZHAddFirendSubtitleCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendSubtitleCell.h"

@implementation YZHAddFirendSubtitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YZHAddBookDetailModel *)model {
    
    _model = model;
    
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
}

@end
