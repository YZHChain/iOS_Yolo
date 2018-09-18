//
//  YZHWelcomeView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHWelcomeView.h"

#import "YZHPublic.h"

@implementation YZHWelcomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)gotoRegister:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterRegister];
}

- (IBAction)gotoLogin:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterLogin];
}

@end
