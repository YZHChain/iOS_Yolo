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
        _tagNameLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
        _tagNameLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        [self addSubview:_tagNameLabel];
        
        _tagCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagCountLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
        _tagCountLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        [self addSubview:_tagCountLabel];
        
        _unReadBadgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self addSubview:_unReadBadgeView];
        
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
    
    _tagNameLabel.height = 14.5f;
    _tagNameLabel.nim_left = 12;
    _tagNameLabel.nim_centerY = self.nim_height * .5f;
    
    _tagCountLabel.height = 14.5f;
    _tagCountLabel.nim_left = _tagNameLabel.nim_right + 4.5f;
    _tagCountLabel.nim_centerY = self.nim_height * 0.5f;
    
    _guideImageView.nim_right = self.nim_width - 23;
    _guideImageView.nim_centerY = self.nim_height * .5f;
    
    _unReadBadgeView.nim_right = _guideImageView.nim_left - 4.5f;
    _unReadBadgeView.nim_centerY = self.nim_height * .5f;
}

- (void)refreshStatus {
    
    switch (self.currentStatusType) {
        case YZHListHeaderStatusTypeDefault:
            self.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_default"];
            break;
        case YZHListHeaderStatusTypeShow:
            self.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_show"];
            break;
        default:
            break;
    }
    [self.guideImageView sizeToFit];
}


@end
