//
//  YZHLoginView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLoginView.h"

#import "YZHPublic.h"
#import "YZHLoginVC.h"
@implementation YZHLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.accountTextField.delegate = self;
}

+ (instancetype)yzh_configXibView{

    return [[NSBundle mainBundle] loadNibNamed:@"YZHLoginView" owner:nil options:nil].lastObject;
}
- (IBAction)gotoRegisterViewController:(id)sender {
    
//    [YZHRouter openURL:kYZHRouterRegister info:@{kYZHRouteSeguePush: @(YES)}];
//    [YZHRouter openURL:kYZHRouterRegister];
//    YZHLoginVC* vc = [[YZHLoginVC alloc] init];
    
}

@end
