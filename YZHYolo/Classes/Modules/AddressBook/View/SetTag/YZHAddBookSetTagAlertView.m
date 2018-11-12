//
//  YZHAddBookSetTagAlertView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetTagAlertView.h"

#import "NSString+YZHTool.h"

@interface YZHAddBookSetTagAlertView()<UITextFieldDelegate>

@end

@implementation YZHAddBookSetTagAlertView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.customTagTextField.delegate = self;
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length == 0) {
        return YES;
    } else {
        BOOL checkoutStandard = [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:20];
        return checkoutStandard;
    }
    
}

- (IBAction)clickAffirm:(UIButton *)sender {
    
    self.YZHButtonExecuteBlock ? self.YZHButtonExecuteBlock(self.customTagTextField) : NULL;
}


@end
