//
//  YZHRegisterView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRegisterView.h"

#import "UIViewController+YZHTool.h"
@interface YZHRegisterView()<UITextFieldDelegate>

@end
@implementation YZHRegisterView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
    
    [self setupNotification];
}

- (void)setupView{
    
    
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification *)notification{
    
    if ([notification.object isKindOfClass:[UITextField class]]){
        
        BOOL hasPhone = self.phoneTextField.text.length >= 11;
        BOOL hasCode  = self.codeTextField.text.length >= 4;
        if (hasCode && hasPhone) {
            self.confirmButton.enabled = YES;
        } else {
            self.confirmButton.enabled = NO;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0) {
        return YES;
    }
    if ([textField isEqual:self.phoneTextField]) {
        if (self.phoneTextField.text.length >= 16) {
            return NO;
        }
    } else {
        if (self.codeTextField.text.length >= 6) {
            return NO;
        }
    }

    return YES;
}
- (IBAction)backThePreviousPage:(UIButton *)sender {
    
        [[UIViewController yzh_findTopViewController].navigationController popViewControllerAnimated:YES];
}


@end
