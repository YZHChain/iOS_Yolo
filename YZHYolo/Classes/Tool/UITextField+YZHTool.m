//
//  UITextField+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UITextField+YZHTool.h"

#import "NSString+YZHTool.h"
#import <objc/runtime.h>
#import "YZHPublic.h"

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kNum @"0123456789"

@implementation UITextField (YZHTool)

- (void)setupInputAccessoryView
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, YZHSCREEN_WIDTH, 44)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboardBarAction)];
    [toolBar setItems:@[flexItem, doneItem] animated:NO];
    self.inputAccessoryView = toolBar;
}

- (void)hideKeyboardBarAction
{
    [self resignFirstResponder];
}

- (NSInteger)maxLen
{
    NSNumber *maxL = objc_getAssociatedObject(self, _cmd);
    if(!maxL) return [@"255" integerValue];
    return [maxL intValue];
}

- (void)setMaxLen:(NSInteger)maxL
{
    objc_setAssociatedObject(self, @selector(maxLen), [NSNumber numberWithInteger:maxL], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSInteger)precision
{
    NSNumber *pre = objc_getAssociatedObject(self, _cmd);
    if(!pre) return [@"0" integerValue];
    return [pre intValue];
}

- (void)setPrecision:(NSInteger)pre
{
    objc_setAssociatedObject(self, @selector(precision), [NSNumber numberWithInteger:pre], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)checkType
{
    NSNumber *type = objc_getAssociatedObject(self, _cmd);
    if(!type) return ENUM_Type_CharMixDidgt;
    return [type intValue];
    
}

- (void)setCheckType:(NSInteger)type
{
    objc_setAssociatedObject(self, @selector(checkType), [NSNumber numberWithInteger:type], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isHaveChinese
{
    NSNumber *isHC = objc_getAssociatedObject(self, _cmd);
    if(!isHC) return [@"1" boolValue];//默认有中文
    return [isHC boolValue];
}

- (void)setIsHaveChinese:(BOOL)isHC
{
    objc_setAssociatedObject(self, @selector(isHaveChinese), [NSNumber numberWithBool:isHC], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isBecomeFirstResponder
{
    NSNumber *isBF = objc_getAssociatedObject(self, _cmd);
    if(!isBF) return [@"1" boolValue];
    return [isBF boolValue];
}

- (void)setIsBecomeFirstResponder:(BOOL)isBF
{
    objc_setAssociatedObject(self, @selector(isBecomeFirstResponder), [NSNumber numberWithBool:isBF], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)remindField
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRemindField:(UILabel *)remindLabel
{
    objc_setAssociatedObject(self, @selector(remindField), remindLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)remindText
{
    NSString *text = objc_getAssociatedObject(self, _cmd);
    if(!text) return @"";
    return text;
}

- (void)setRemindText:(NSString *)remindStr
{
    objc_setAssociatedObject(self, @selector(remindText), remindStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)yzh_textFieldWithShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //依据不同情况处理....................................
    //0.通用处理
    //0.1长度判断
    if (string.length == 0) return YES;
    
    NSInteger existedLength = self.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > self.maxLen) {
        return NO;
    }
    
    //类型判断
    switch (self.checkType)
    {
        case ENUM_Type_Chinese:
        {//1.汉字 只能输入中文
            return YES;
        }
            break;
        case ENUM_Type_ID:
        {//2.身份证 数字字母混合
            [self yzh_textFieldWithMIXShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
        case ENUM_Type_Mobile:
        {//3.手机号 整形 不能以0开头
            [self yzh_textFieldWithIntShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
            
        case ENUM_Type_LoginPWD:
        {//4.登录密码 字母数字混合
            [self yzh_textFieldWithMIXShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
        case ENUM_Type_TradePWD:
        {//5.交易密码 纯数字 可以0开头
            [self yzh_textFieldWithNumShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
            
        case ENUM_Type_CheckCode:
        {//6.验证码 纯数字 可以0开头
            [self yzh_textFieldWithNumShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
            
        case ENUM_Type_Int:
        {//7. 整形 实时限定整数
            [self yzh_textFieldWithIntShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
            
        case ENUM_Type_Float_2:
        {//8. 精度浮点 实时限定精度的浮点数
            [self yzh_textFieldWithFloatShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
        case ENUM_Type_Num:
        {//9. 纯数字 实时限定数字 可以有0
            [self yzh_textFieldWithNumShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
        case ENUM_Type_CharMixDidgt:
        {//10. 字符串 实时限定大小写字母和数字混合
            [self yzh_textFieldWithMIXShouldChangeCharactersInRange:range replacementString:string];
        }
            break;
            
        default:
        {//11.缺省，不指定类型都可以输入
            return YES;
        }
            break;
    }
    return YES;
}

//精度浮点
- (BOOL)yzh_textFieldWithFloatShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian = NO;
    if ([self.text rangeOfString:@"."].location == NSNotFound) {
        
        isHaveDian = NO;
    }else {
        isHaveDian = YES;
    }
    
    if(self.precision && self.precision > 0)
    {
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能小数点 可以是0
                if([self.text length] == 0){
                    if(single == '.') {
                        [self.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [self.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [self.text rangeOfString:@"."];
                        if (range.location - ran.location <= self.precision) {
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }
            else{//输入的数据格式不正确
                [self.text stringByReplacingCharactersInRange:range withString:@""];
                
                return NO;
            }
        }else {
            //输入为空
            return YES;
        }
        
    }else {
        //精度输入不正确
    }
    return YES;
}

//纯数字 实时限定数字 可以有0
- (BOOL)yzh_textFieldWithNumShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    NSUInteger newLength = self.text.length+string .length-range.length;
    return newLength > self.maxLen? NO : canChange;
}

//整形
- (BOOL)yzh_textFieldWithIntShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9')) {//数据格式正确
            
            //首字母不能为0
            if([self.text length] == 0){
                if (single == '0') {
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            return YES;
        }
        else{//输入的数据格式不正确
            [self.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
        }
    }
    else
    {//输入为空
        
        return YES;
    }
    
}

//字母数字混合
- (BOOL)yzh_textFieldWithMIXShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    NSUInteger newLength = self.text.length+string .length-range.length;
    return newLength > self.maxLen?NO : canChange;
}

//验证后的响应
- (BOOL)responseProofPost:(UITextField *)inputField
{
    if (self.isBecomeFirstResponder) {
        [inputField becomeFirstResponder];
    }
    
    //统一改为吐司
//    [yzhProgressHUD showText:self.remindText onView:self.window];
    return NO;
}

//多域验证
+ (BOOL)proofWithMutiFields:(NSArray *)fieldsArray
{
    BOOL result = FALSE ;
    
    for (int i = 0; i < fieldsArray.count; i++) {
        UITextField *otherField = (UITextField *)fieldsArray[i];
        //依次取得所有参数
        result = [otherField proofSingleField];
        if(!result) break;
    }
    
    return result;
}
/*
//单域验证
- (BOOL)proofSingleField
{
    
    if (![self isKindOfClass:[UITextField class]] ) {
//        [yzhProgressHUD showText:@"非法输入域" onView:self.window];
        return NO;
    }
    
    UITextField *inputField = self;
    
    //交易类型
    switch (self.checkType) {
        case ENUM_Type_Mobile://枚举类型
        {//手机号码
            return [inputField.text yzh_isPhone]? YES:[self responseProofPost:inputField];
        }
            break;
            
        case ENUM_Type_LoginPWD:
        {//登录密码
            return [inputField.text yzh_isPassword]? YES:[self responseProofPost:inputField];
        }
            break;
            
        case ENUM_Type_TradePWD:
        {//交易密码
            return [inputField.text yzh_isPayPassword]? YES:[self responseProofPost:inputField];
        }
            break;
            
        case ENUM_Type_CheckCode:
        {//验证码
            return [inputField.text yzh_isNumberChars]? YES:[self responseProofPost:inputField];
        }
            break;
            
        case ENUM_Type_Chinese:
        {//中文
            return [inputField.text yzh_isChinese]? YES:[self responseProofPost:inputField];
        }
            break;
            
        case ENUM_Type_ID:
        {//身份证
            return [inputField.text yzh_isIDCardNumber]? YES:[self responseProofPost:inputField];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}
 */

- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end

