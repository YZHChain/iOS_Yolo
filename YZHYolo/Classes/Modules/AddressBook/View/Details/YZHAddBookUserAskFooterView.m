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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    
    
    [super awakeFromNib];
    
    [self.addFriendButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendMessageButton yzh_setBackgroundColor:[UIColor yzh_buttonBackgroundGreen] forState:UIControlStateNormal];
    
}



@end
