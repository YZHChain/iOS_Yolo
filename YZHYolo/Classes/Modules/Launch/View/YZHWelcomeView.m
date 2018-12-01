//
//  YZHWelcomeView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHWelcomeView.h"

@interface YZHWelcomeView()<UITextFieldDelegate>


@end
@implementation YZHWelcomeView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.registerButton.layer.cornerRadius = 4;
    self.registerButton.layer.masksToBounds = YES;
    [self.registerButton.titleLabel setFont:[UIFont yzh_commonLightStyleWithFontSize:15]];
    self.registerButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self setupNotification];
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    //TODO:校验手机号
//    BOOL hasConform = self.phoneTextField.text >
//    if (hasConform) {
//        self.confirmButton.enabled = YES;
//    } else {
//        self.confirmButton.enabled = NO;
//    }
}
// 去登录或注册时将欢迎页销毁掉.
- (IBAction)gotoRegister:(UIButton *)sender {
    
    self.regesterButtonBlock ? self.regesterButtonBlock(sender) : NULL;
}

- (IBAction)gotoLogin:(UIButton *)sender {
    
    self.loginButtonBlock ? self.loginButtonBlock(sender) : NULL;
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
