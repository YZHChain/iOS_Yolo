//
//  YZHSessionListCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSessionListCell.h"

@implementation YZHSessionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftAdornImageView = [[UIImageView alloc] init];
        self.leftAdornImageView.backgroundColor = [UIColor yzh_fontThemeBlue];
        
        [self.contentView addSubview:self.leftAdornImageView];
        [self.leftAdornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(4);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
