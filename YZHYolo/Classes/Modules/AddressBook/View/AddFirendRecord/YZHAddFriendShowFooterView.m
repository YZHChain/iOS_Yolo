//
//  YZHAddFriendShowFooterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFriendShowFooterView.h"

#import "UIButton+YZHTool.h"
@implementation YZHAddFriendShowFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.agreeButton yzh_setBackgroundColor:YZHColorRGBAWithRGBA(42, 107, 250, 1) forState:UIControlStateNormal];
    self.agreeButton.layer.cornerRadius = 5;
    self.agreeButton.layer.masksToBounds = YES;
}

@end
