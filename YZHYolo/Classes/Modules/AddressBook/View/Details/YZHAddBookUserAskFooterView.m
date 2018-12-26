//
//  YZHAddBookUserAskFooterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookUserAskFooterView.h"

#import "UIButton+YZHTool.h"
#import "YZHPublic.h"

@implementation YZHAddBookUserAskFooterView


- (void)awakeFromNib{
    
    
    [super awakeFromNib];
    
    [self.addFriendButton yzh_setupButton];
    [self.senderMessageBlock yzh_setupButton];
    
    self.backgroundView = ({
        UIView* view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
    
}

- (IBAction)onTouchAddFriend:(UIButton *)sender {
    
    self.addFriendBlock ? self.addFriendBlock(sender) : NULL;
    
}

- (IBAction)onTouchSenderMessage:(UIButton *)sender {
    
    self.senderMessageBlock ? self.senderMessageBlock(sender) : NULL;
}

@end
