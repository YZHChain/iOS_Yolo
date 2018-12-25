//
//  UIButton+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YZHTool)

@property (nonatomic, copy) YZHButtonExecuteBlock tapCallBlock;

+ (instancetype)yzh_setBarButtonItemWithStateNormalImageName:(NSString  *)stateNormalImageName stateSelectedImageName:(NSString *)stateSelectedImageName tapCallBlock:(YZHButtonExecuteBlock)callBlock;
+ (instancetype)yzh_setBarButtonItemWithImageName:(NSString *)imageName tapCallBlock:(YZHButtonExecuteBlock)callBlock;
- (void)yzh_setupButton;

/**
 *  设置背景颜色
 *
 *  @param backgroundColor 背景颜色
 *  @param state           状态
 */
- (void)yzh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
//密码按钮隐藏控制
- (void)yzh_hiddenPwdWithFields:(NSArray *)fieldsArray;
//是否激活按钮状态
- (void)yzh_statusActive:(UITextField *)textField, ...NS_REQUIRES_NIL_TERMINATION;
//- (void)yzh_statusRegisterActive:(UITextField *)textField, ...NS_REQUIRES_NIL_TERMINATION;

@end
