//
//  YZHFindPasswordView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHFindPasswordView.h"

#import "YZHPublic.h"
#import "UIViewController+YZHTool.h"

@interface YZHFindPasswordView()<UITextFieldDelegate>

@end

@implementation YZHFindPasswordView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupNotification];
}

- (IBAction)returnThePreviousPage:(UIButton *)sender {

    [[UIViewController yzh_findTopViewController].navigationController popViewControllerAnimated:YES];
}

- (void)setupNotification{
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
 
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    BOOL hasConform = self.accountTextField.text.length >= 11 && self.SMSCodeTextField.text.length >= 4;
    if (hasConform) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma makr -- TextDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.accountTextField]) {
        return  [self checkAccountTextFieldWithinputCharacters:string];
    } else {
        return [self checkSMSCodePasswordTextFieldWithinputCharacters:string];
    }
    
}

#pragma mark -- checkTextField

- (BOOL)checkAccountTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.accountTextField.text.length >= 15 && characters.length != 0) {
        return NO;
    } else {
        return YES;
    }
    
}

- (BOOL)checkSMSCodePasswordTextFieldWithinputCharacters:(NSString* )characters{
    
    if (self.SMSCodeTextField.text.length >= 8 && characters.length != 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
