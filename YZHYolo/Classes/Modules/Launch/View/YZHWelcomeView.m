//
//  YZHWelcomeView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHWelcomeView.h"

#import "YZHPublic.h"

@interface YZHWelcomeView()<UITextFieldDelegate>


@end
@implementation YZHWelcomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupNotification];
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)textFieldEditChanged:(NSNotification* )notification{

//    BOOL hasConform = self.phoneTextField.text >
//    if (hasConform) {
//        self.confirmButton.enabled = YES;
//    } else {
//        self.confirmButton.enabled = NO;
//    }
}

- (IBAction)gotoRegister:(UIButton *)sender {
    
    // 请求后台对手机号做校验 弹出相应框 通过则引导其去注册
    
    [YZHAlertManage showAlertTitle:nil message:@"该账号尚未注册、是否马上去注册" actionButtons:@[@"返回",@"去注册"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [YZHRouter openURL:kYZHRouterRegister info: @{@"hiddenBack": @(YES),@"phoneNumberString": self.phoneTextField.text, kYZHRouteBackIndex: @(1)}];
        }
    }];

//    [YZHRouter openURL:kYZHRouterRegister info: @{@"hiddenBack": @(YES),@"phoneNumberString": self.phoneTextField.text, kYZHRouteBackIndex: @(1)}];
}

- (IBAction)gotoLogin:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterLogin info:@{kYZHRouteBackIndex: @(1)}];
}

#pragma mark -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.phoneTextField.text.length >= 15 && string.length != 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
