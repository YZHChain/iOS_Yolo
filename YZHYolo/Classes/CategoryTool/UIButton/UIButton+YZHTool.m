//
//  UIButton+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIButton+YZHTool.h"

#import "UIImage+YZHTool.h"
#import <objc/runtime.h>

@implementation UIButton (YZHTool)

+ (instancetype)yzh_setBarButtonItemWithStateNormalImageName:(NSString *)stateNormalImageName stateSelectedImageName:(NSString *)stateSelectedImageName tapCallBlock:(YZHButtonExecuteBlock)callBlock {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button yzh_setBarButtonItemWithStateNormalImageName:stateNormalImageName stateSelectedImageName:stateSelectedImageName tapCallBlock:callBlock];
    
    return button;
}

+ (instancetype)yzh_setBarButtonItemWithImageName:(NSString *)imageName tapCallBlock:(YZHButtonExecuteBlock)callBlock {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button yzh_setBarButtonItemWithStateNormalImageName:imageName stateSelectedImageName:imageName tapCallBlock:callBlock];

    return button;
}

- (instancetype)yzh_setBarButtonItemWithStateNormalImageName:(NSString  *)stateNormalImageName stateSelectedImageName:(NSString *)stateSelectedImageName tapCallBlock:(YZHButtonExecuteBlock)callBlock {
    
    [self setImage:[UIImage imageNamed:stateNormalImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:stateSelectedImageName] forState:UIControlStateSelected];
    [self sizeToFit];
    
    if (callBlock) {
        
        self.tapCallBlock = [callBlock copy];
        [self addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)yzh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    [self setBackgroundImage:[UIImage yzh_getImageWithColor:backgroundColor withSize:self.frame.size] forState:state];
}

- (void)yzh_setupButton {
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    [self.titleLabel setFont:[UIFont yzh_commonFontStyleFontSize:18]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
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


#pragma mark -- GET && SET

- (YZHButtonExecuteBlock)tapCallBlock {
    
    return objc_getAssociatedObject(self, &kYZHCommonNonnullKey);
}

- (void)setTapCallBlock:(YZHButtonExecuteBlock)tapCallBlock {
    
    objc_setAssociatedObject(self, &kYZHCommonNonnullKey, tapCallBlock, OBJC_ASSOCIATION_COPY);
}


#pragma mark

- (void)tapButton:(UIButton *)sender {
    
    self.tapCallBlock ? self.tapCallBlock(sender) : NULL;
}

@end
