//
//  YZHTextChatContentCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTextChatContentCell.h"

@implementation YZHTextChatContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = 4;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
