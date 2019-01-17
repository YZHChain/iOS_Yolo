//
//  YZHUnreadAtMyMessageView.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/15.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHUnreadAtMyMessageView.h"

@implementation YZHUnreadAtMyMessageView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView {
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:12];
    self.titleLabel.textColor = [UIColor yzh_buttonBackgroundPinkRed];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = YZHColorRGBAWithRGBA(220, 221, 221, 1).CGColor;
    self.layer.masksToBounds = YES;
    
    [self sizeToFit];
}

- (void)refreshAtUnreadCount:(NSInteger)atUnreadCount {
    
    if (atUnreadCount) {
        if (atUnreadCount > 99) {
            self.titleLabel.text = [NSString stringWithFormat:@"有99+条@您"];
        } else {
            self.titleLabel.text = [NSString stringWithFormat:@"有%ld条@您", atUnreadCount];
        }
    }
}

@end
