//
//  YZHAboutYoloCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAboutYoloCell.h"

@interface YZHAboutYoloCell()



@end

@implementation YZHAboutYoloCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YZHAboutYoloModel *)model {
    
    _model = model;
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
}

@end
