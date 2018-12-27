//
//  YZHAddFriendShowFooterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFriendShowFooterView.h"

#import "UIButton+YZHTool.h"
#import "YZHPublic.h"
@implementation YZHAddFriendShowFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.agreeButton yzh_setupButton];
    
    self.backgroundView = ({
        UIView* view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
}

@end
