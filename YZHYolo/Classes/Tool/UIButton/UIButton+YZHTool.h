//
//  UIButton+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YZHTool)

//密码按钮隐藏控制
- (void)yzh_hiddenPwdWithFields:(NSArray *)fieldsArray;
//是否激活按钮状态
- (void)yzh_statusActive:(UITextField *)textField, ...NS_REQUIRES_NIL_TERMINATION;
- (void)yzh_statusRegisterActive:(UITextField *)textField, ...NS_REQUIRES_NIL_TERMINATION;

//倒计时 缺省
- (void)yzh_countdownWithTimeInterval:(NSInteger)ti;
- (void)yzh_countDown;

@end
