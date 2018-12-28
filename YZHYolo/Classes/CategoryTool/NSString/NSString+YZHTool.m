//
//  NSString+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "NSString+YZHTool.h"

@implementation NSString (YZHTool)
#pragma mark - 正则表达式校验字符串

- (BOOL)yzh_isHTML
{
    return ([self rangeOfString:@"<"].location!=NSNotFound && [self rangeOfString:@">"].location!=NSNotFound);
}

- (BOOL)yzh_isPhone
{
    return [self validateWithRegex:@"^1\\d{10}$"];
}

- (BOOL)yzh_isPassword
{
    return [self validateWithRegex:@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,12}"];
}

- (BOOL)yzh_isPayPassword
{
    return [self validateWithRegex:@"^\\d{6}$"];
}

- (BOOL)yzh_isNumber
{
    return [self validateWithRegex:@"(0|[1-9]\\d*)(\\.\\d+)?"];
}

- (BOOL)yzh_isNumberChars
{
    return [self validateWithRegex:@"^[0-9]*$"];
}

- (BOOL)yzh_isLowercaseEnglishChars
{
    return [self validateWithRegex:@"^[a-z]+$"];
}

- (BOOL)yzh_isLowerBigCaseEnglishChars
{
    return [self validateWithRegex:@"^[A-Za-z]+$"];
}

- (BOOL)yzh_isSpecialChars
{
    return [self validateWithRegex:@"^[a-z0-9]+$"];
}

- (BOOL)yzh_isMoneyNumber
{
    return [self validateWithRegex:@"(0|[1-9]\\d*)(\\.\\d+)?"];
}

- (BOOL)yzh_isEmail
{
    return [self validateWithRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)yzh_isQQ
{
    return [self validateWithRegex:@"[1-9][0-9]{4,}"];
}

- (BOOL)yzh_isHTTP {
    
   return [self validateWithRegex:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"];
}

+ (BOOL)yzh_isEmptyString:(id)string
{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)yzh_isIDCardNumber
{
    NSString *value = [self copy];
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyzhmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyzhmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

- (BOOL)yzh_isChinese
{
    NSString *value = [self copy];
    NSString *pattern = @"^[\u4e00-\u9fa5]{1,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL regex = [predicate evaluateWithObject:value];
    return regex;
}

- (BOOL)validateWithRegex:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

#pragma mark - Other

- (NSString *)yzh_trimString
{
    NSString* str = @"";
    //1. 去除掉首尾的空白字符和换行字符
    str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //2. 去除掉其它位置的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return str;
}

- (NSString *)yzh_formatThousandsDigits
{
    NSNumber *number = @([[self copy] doubleValue]);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatterStr = [formatter stringFromNumber:number];
    
    return formatterStr;
}

- (BOOL)yzh_isCorrectMoneyFormat
{
    NSString *money = [self copy];
    
    if ([money doubleValue] == 0) {
        return NO;
    }
    
    if ([money hasPrefix:@"0"] || [money hasPrefix:@"."] || [money hasSuffix:@"."])
    {
        if (![money hasPrefix:@"0."] || [money hasSuffix:@"."])
        {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (NSString *)yzh_clearBeforeAndAfterblankString {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (NSMutableAttributedString *)yzh_processStringWithPattern:(NSString *)pattern font:(UIFont *)font color:(UIColor *)color isAll:(BOOL)isall
{
    NSString *str = [self copy];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange searchedRange = NSMakeRange(0, [str length]);
    
    NSError *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:str options:0 range: searchedRange];
    
    if (isall) {
        for (NSTextCheckingResult* match in matches)
        {
            NSString* matchText = [str substringWithRange:[match range]];
            [attStr addAttribute:NSFontAttributeName value:font range:[match range]];
            [attStr addAttribute:NSForegroundColorAttributeName value:color range:[match range]];
            NSLog(@"Match: %@", matchText);
        }
    }else{
        NSTextCheckingResult* match = [matches lastObject];
        NSString* matchText = [str substringWithRange:[match range]];
        [attStr addAttribute:NSFontAttributeName value:font range:[match range]];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:[match range]];
        NSLog(@"Match: %@", matchText);
    }
    
    return attStr;
}

//返回格式化手机
- (NSString *)yzh_formatMobile
{
    if ([self yzh_trimString].length == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@****%@", [[self yzh_trimString] substringToIndex:3], [[self yzh_trimString] substringFromIndex:7]];
}

//过滤中文的字符串
- (NSString *)yzh_stringWithNoChinese
{
    //1.过滤中文
    NSString *pattern = @"^[\u4e00-\u9fa5]{1,}$";
    NSString *newString = [self stringByReplacingOccurrencesOfString:pattern withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
    
    return newString;
}

//是否为整数
- (BOOL)yzh_isPureInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//是否为浮点
- (BOOL)yzh_isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//将百分比字符串转换为float值
- (float)yzh_formatFloatValue
{
    if (self.length > 1) {
        CGFloat rateFloat = [[self substringToIndex:self.length - 1] floatValue] / 100.f;
        return rateFloat;
    }
    return 0;
}

//带万、元单位，小数的数字格式化
- (NSString *)yzh_formatNumWithUnit:(BOOL)unit isDouble:(BOOL)dYes withAccuracy:(int)accuracy
{
    //若不是数字 则返回为0
    if(![self yzh_isPureFloat] && ![self yzh_isPureInt])
    {
        if (unit) {
            return @"0.00元";
        }
        return @"0.00";
    }
    
    //大于10万 显示万元 否则显示元
    NSString *unitT = @"元";
    double tAmount = [self.yzh_trimString doubleValue];
    if (tAmount >= 100000) {
        tAmount = tAmount / 10000.0;
        
        unitT = @"万元";
    }else {//小于 10万
        
    }
    if (!dYes) {
        accuracy = 0;
    }
    
    NSString *newStr = [self getNewStrWithOriginStr:[NSString stringWithFormat:@"%f",tAmount] withAccuracy:accuracy];
    
    NSString *result = nil;
    //拼接单位
    if (unit) {
        result = [NSString stringWithFormat:@"%@%@",newStr.yzh_trimString, unitT];
    }else {
        result = newStr.yzh_trimString;
    }
    
    return result;
}

- (NSString *)getNewStrWithOriginStr:(NSString *)originStr withAccuracy:(int)accuracy
{
    //    NSRoundPlain,   // Round up on a tie ／／貌似取整
    //    NSRoundDown,    // Always down == truncate  ／／只舍不入
    //    NSRoundUp,      // Always up    ／／ 只入不舍
    //    NSRoundBankers  // on a tie round so last digit is even  貌似四舍五入
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:accuracy
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    NSDecimalNumber *transDecimalTAmount = [NSDecimalNumber decimalNumberWithString:originStr];
    
    NSDecimalNumber *addOper = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    transDecimalTAmount = [transDecimalTAmount decimalNumberByAdding:addOper withBehavior:roundUp];
    NSString *result = [NSString stringWithFormat:@"%@", transDecimalTAmount];
    
    return result;
}

-(NSString *)yzh_replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght
{
    NSString *newStr = originalStr;
    for (int i = 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}

+ (NSAttributedString* )yzh_setHTMLText:(NSString *)text
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return string.copy;
}

- (NSInteger)yzh_calculateStringLeng {
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
}
//TODO 利用这种方式计算,对于英文直接转成拼音时,会有一个问题. 如输入 ha,拼接成 哈 应该是 2 个字符, 但是前面读取到 h,  ha直接转成 哈, 这样计算的时候相当于是 3 个字符了。
+ (BOOL)yzh_checkoutStringWithCurrenString:(NSString *)currentString importString:(NSString *)importString standardLength:(NSInteger)standardLength {
    NSInteger currentStringLength = [currentString yzh_calculateStringLeng];
    NSInteger importStringLength = [importString yzh_calculateStringLeng];
    
    BOOL isQualified = currentStringLength + importStringLength <= standardLength;
    
    return isQualified;
}

@end

