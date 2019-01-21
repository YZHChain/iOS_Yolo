//
//  YZHAddBookSetTagAlertView.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetTagAlertView.h"

#import "NSString+YZHTool.h"
#import "YZHAlertManage.h"
#import "UIViewController+YZHTool.h"

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
        BOOL checkoutStandard = [NSString yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength:12];
        return checkoutStandard;
    }
    
}

- (IBAction)clickAffirm:(UIButton *)sender {
    
    if (YZHIsString(self.customTagTextField.text)) {
        NSString* customTagName = [self.customTagTextField.text yzh_clearBeforeAndAfterblankString];
        //加入用户输入名字为空格,则只计算一位。。
        if (!YZHIsString(customTagName)) {
            customTagName = @" ";
        }
        self.customTagTextField.text = customTagName;
        NSInteger customTagLength = [self.customTagTextField.text yzh_calculateStringLeng];
        if (customTagLength <= 12) {
            self.YZHButtonExecuteBlock ? self.YZHButtonExecuteBlock(self.customTagTextField) : NULL;
        } else {
            [YZHAlertManage showAlertMessage:@"输入分类字数过长,请重新填写"];
        }
    } else {
        [YZHAlertManage showAlertMessage:@"没有输入分类,请重新填写"];
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIViewController* currenVC = [UIViewController yzh_findTopViewController];
    self.center = CGPointMake(currenVC.view.width / 2, currenVC.view.height / 2);
    
}


@end
