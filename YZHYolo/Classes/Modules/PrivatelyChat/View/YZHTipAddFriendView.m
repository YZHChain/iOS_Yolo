//
//  YZHTipAddFriendView.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTipAddFriendView.h"


@implementation YZHTipAddFriendView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    
    self.titleLabel.font = [UIFont yzh_commonLightStyleWithFontSize:13];
    self.titleLabel.textColor = [UIColor yzh_sessionCellGray];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"加为好友"];
    NSRange titleRange = {0, [title length]};
    [title addAttributes:@{
                           NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                           NSFontAttributeName: [UIFont yzh_commonLightStyleWithFontSize:14],
                           NSForegroundColorAttributeName: [UIColor yzh_fontThemeBlue]
                           } range:titleRange];
    [self.addFriendButton setAttributedTitle:title
                      forState:UIControlStateNormal];
}

@end
