//
//  YZHAddBookSetTagSectionView.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/1.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetTagSectionView.h"

#import "UIFont+YZHFontStyle.h"
@implementation YZHAddBookSetTagSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
        _titleLabel.textColor = [UIColor yzh_fontShallowBlack];
        _titleLabel.frame = CGRectMake(12, 6, YZHScreen_Width - 30, 14);
    }
    return _titleLabel;
}

@end
