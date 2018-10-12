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
    
    [self setupNotification];
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    BOOL hasConform = self.accountTextField.text.length >= 1 && self.passwordTextField.text.length >= 6;
    if (hasConform) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}
// 登录
- (IBAction)executeLogin:(UIButton *)sender {
    
    self.loginButtonBlock ? self.loginButtonBlock(sender) : NULL;
}

// 前往注册
- (IBAction)gotoRegisterViewController:(UIButton *)sender {
    
    self.regesterButtonBlock ? self.regesterButtonBlock(sender) : NULL;
}
// 前往找回密码
- (IBAction)gotoFindPasswordViewController:(UIButton *)sender {
    
    self.findPasswordButtonBlock ? self.findPasswordButtonBlock(sender) : NULL;
}

#pragma mark -- TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.accountTextField isEqual:textField]) {
        return [self checkAccountTextFieldWithinputCharacters:string];
    } else {
        return [self checkPasswordTextFieldWithinputCharacters:string];
    }
}

#pragma mark -- UITextFieldInputCheck

- (BOOL)checkAccountTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.accountTextField.text.length >= 18 && characters.length != 0) {
        return NO;
    }
    return YES;
}

-(BOOL)checkPasswordTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.passwordTextField.text.length >= 18 && characters.length != 0) {
        return NO;
    }
    return YES;
}

@end
