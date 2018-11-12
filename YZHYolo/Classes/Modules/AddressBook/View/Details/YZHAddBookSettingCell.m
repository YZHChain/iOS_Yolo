//
//  YZHAddBookSettingCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSettingCell.h"


@implementation YZHAddBookSettingCell

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
    self.subTitleLabel.text = model.subtitle;
    if ([model.title isEqualToString: @"设置备注"]) {
        self.subTitleLabel.text = nil;
    }
    if (model.canSkip) {
        self.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
    } else {
        self.guideImageView.image = nil;
    }
    
}

@end
