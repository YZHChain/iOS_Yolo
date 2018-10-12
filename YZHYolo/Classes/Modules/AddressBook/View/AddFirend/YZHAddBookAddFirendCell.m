//
//  YZHAddBookAddFirendCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendCell.h"

@implementation YZHAddBookAddFirendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YZHAddBookFirendModel *)model {
    
    self.titleLabel.text = model.title;
}

@end
