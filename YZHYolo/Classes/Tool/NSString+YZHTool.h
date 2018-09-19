//
//  NSString+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YZHTool)

- (NSString *)yzh_trimString;

- (BOOL)yzh_isHTML;
- (BOOL)yzh_isPhone;
- (BOOL)yzh_isPassword;
- (BOOL)yzh_isPayPassword;
- (BOOL)yzh_isNumber;
- (BOOL)yzh_isNumberChars;
- (BOOL)yzh_isLowercaseEnglishChars;
- (BOOL)yzh_isSpecialChars;
- (BOOL)yzh_isMoneyNumber;
- (BOOL)yzh_isIDCardNumber;
- (BOOL)yzh_isChinese;
- (BOOL)yzh_isEmail;
- (BOOL)yzh_isQQ;

+ (BOOL)yzh_isEmptyString:(id)string;
//是否为整数
- (BOOL)yzh_isPureInt;
//是否为浮点
- (BOOL)yzh_isPureFloat;

- (NSString *)yzh_formatMobile;//返回格式化手机
- (NSString *)yzh_stringWithNoChinese;//过滤中文的字符串

//带万、元单位，小数的数字格式化
- (NSString *)yzh_formatNumWithUnit:(BOOL)unit isDouble:(BOOL)dYes withAccuracy:(int)accuracy;

//千分位表示金额
- (NSString *)yzh_formatThousandsDigits;
//正确金额格式
- (BOOL )yzh_isCorrectMoneyFormat;
//将百分比字符串转换为float值
- (float)yzh_formatFloatValue;


/**
 *  加工字符串，把字符串里数字的颜色和字体替换成给定的颜色和字体
 *
 *  @param str     原始字符串
 *  @param pattern 正则规则
 *  @param font    字体
 *  @param color   颜色
 *  @param isall   YES:全部替换，NO:最后一个符合规则的数字
 *
 *  @return 新的字符串
 */
- (NSMutableAttributedString *)yzh_processStringWithPattern:(NSString *)pattern font:(UIFont *)font color:(UIColor *)color isAll:(BOOL)isall;

// 将身份证某段连续用**替换
-(NSString *)yzh_replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;

// 将HTML字符串转NSAttributedString
+ (NSAttributedString* )yzh_setHTMLText:(NSString *)text;

@end
