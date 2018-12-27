//
//  YZHPrivatelyChatListHeaderView.m
//  NIM
//
//  Created by Jersey on 2018/10/17.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "YZHPrivatelyChatListHeaderView.h"

#import "UIView+NIM.h"
@implementation YZHPrivatelyChatListHeaderView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _tagNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagNameLabel.font = [UIFont systemFontOfSize:13];
        _tagNameLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        [self addSubview:_tagNameLabel];
        
        _unReadCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unReadCountLabel.font = [UIFont systemFontOfSize:13];
        _unReadCountLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        [self addSubview:_unReadCountLabel];
        
        _guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:_guideImageView];
        
        _groupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
        [_groupButton addTarget:self action:@selector(executeSelected:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:_groupButton];
    
    }
    return self;
}

- (void)executeSelected:(UIButton* )sender {
    
    self.callBlock ? self.callBlock(_section) : NULL;
}

- (void)refresh:(NIMRecentSession*)recent {
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _tagNameLabel.nim_left = 12;
    _tagNameLabel.nim_centerY = self.nim_height * .5f;
    
    _unReadCountLabel.nim_left = self.tagNameLabel.nim_right + 5;
    _unReadCountLabel.nim_centerY = self.nim_height * .5f;
    
    _guideImageView.nim_right = self.nim_width - 26;
    _guideImageView.nim_centerY = self.nim_height * .5f;
}

- (void)refreshStatus {
    
}


@end
