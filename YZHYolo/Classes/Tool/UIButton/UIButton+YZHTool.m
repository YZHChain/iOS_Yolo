//
//  UIButton+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIButton+YZHTool.h"

#import "UIImage+YZHTool.h"
@implementation UIButton (YZHTool)

- (void)yzh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    [self setBackgroundImage:[UIImage yzh_getImageWithColor:backgroundColor withSize:self.frame.size] forState:state];
}


//密码按钮隐藏控制
- (void)yzh_hiddenPwdWithFields:(NSArray *)fieldsArray
{
    self.selected = !self.selected;
    
    for (UITextField *obj in fieldsArray) {
        //依次取得所有参数
        NSString *tempText = obj.text;
        obj.text = @"";
        
        if (!self.selected) {
            [obj setSecureTextEntry:YES];
        }else {
            [obj setSecureTextEntry:NO];
        }
        obj.text = tempText;
    }
}

//是否激活按钮状态
- (void)yzh_statusActive:(UITextField *)textField, ...NS_REQUIRES_NIL_TERMINATION
{
    BOOL result = FALSE ;
    va_list args;
    va_start(args, textField);
    if (textField.text.length)
    {
        result = TRUE;
        UITextField *otherField;
        while ((otherField = va_arg(args, UITextField *)))
        {
            //依次取得所有参数
            result = (otherField.text.length > 0)? TRUE : FALSE;
            if(!result) break;
        }
    }else {
        result = FALSE;
    }
    va_end(args);
    
    //逻辑判断
    if(result)
    {
        self.enabled = YES;
//        self.alpha = 1.0f;
    }else{
        self.enabled = NO;
//        self.alpha = 0.5f;
    }
    
}

@end
