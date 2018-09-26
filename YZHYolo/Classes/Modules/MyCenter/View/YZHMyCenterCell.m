//
//  YZHMyCenterCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyCenterCell.h"


@implementation YZHMyCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YZHMyCenterModel *)model{
    
    self.iConImageView.image = [UIImage imageNamed:model.image];
    self.titleLabel.text = model.title;
}

@end
