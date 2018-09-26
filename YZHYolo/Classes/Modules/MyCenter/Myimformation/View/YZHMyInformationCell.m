//
//  YZHMyInformationCell.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationCell.h"

@implementation YZHMyInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(YZHMyInformationModel *)viewModel
{
    self.titleLabel.text = viewModel.title;
    if (viewModel.subtitle.length) {
        self.subTitleLabel.text = viewModel.subtitle;
    }
    if (viewModel.image.length) {
        self.photoImageView.image = [UIImage imageNamed:viewModel.image];
    }
}

@end
