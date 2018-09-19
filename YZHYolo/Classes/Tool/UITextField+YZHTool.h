//
//  UITextField+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

//校验类型
typedef enum {
    ENUM_Type_Chinese = 0,//中文
    ENUM_Type_ID ,//身份证
    ENUM_Type_Mobile , //手机号
    ENUM_Type_LoginPWD , //登录密码 实时限定大小写字母和数字混合
    ENUM_Type_TradePWD , //交易密码
    ENUM_Type_CheckCode ,//验证码
    
    ENUM_Type_Int , //整形 实时限定整数
    ENUM_Type_Float_2 ,//2位精度浮点 实时限定精度的浮点数
    ENUM_Type_Num, //纯数字 实时限定数字 可以有0
    ENUM_Type_CharMixDidgt //字符串 实时限定大小写字母和数字混合
} ENUM_CheckField_Type;

@interface UITextField (YZHTool)

@property (nonatomic, assign) NSInteger checkType;//校验类型
@property (nonatomic, strong) UILabel *remindField;//提醒标签
@property (nonatomic, copy) NSString *remindText;//提醒文字
@property (nonatomic, assign) BOOL isBecomeFirstResponder;//键盘响应
@property (nonatomic, assign) BOOL isHaveChinese;//是否有中文
@property (nonatomic, assign) NSInteger precision;//精度
@property (nonatomic, assign) NSInteger maxLen;//最大长度

/**
 * 实时限定精度的浮点数或整数
 * 实时限定大小写字母和数字混合
 * 实时限定数字
 */
- (BOOL)yzh_textFieldWithShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

//单域验证
- (BOOL)proofSingleField;
//多域验证
+ (BOOL)proofWithMutiFields:(NSArray *)fieldsArray;

- (void)setupInputAccessoryView;

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
