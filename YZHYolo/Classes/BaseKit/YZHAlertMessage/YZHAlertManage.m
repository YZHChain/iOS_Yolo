//
//  YZHAlertManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAlertManage.h"

#import "UIViewController+YZHTool.h"
// UIAlertMessage 默认标题
static NSString* const YMAlertMessageTitle = @"温馨提示";
static NSString* const YMAlertMessageActionTitle = @"知道了";
@implementation YZHAlertManage

+ (void)showAlertMessage:(NSString *)message
{
    if (message.length == 0) {
        return;
    }
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:YMAlertMessageTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:YMAlertMessageActionTitle style:UIAlertActionStyleDefault handler:nil]];
    //防止alertView动画跟键盘动画冲突
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController* topVC = [UIViewController yzh_findTopViewController];
        topVC = topVC ? topVC : [UIViewController yzh_rootViewController];
        [topVC presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message actionButtons:(NSArray<NSString *> *)actionButtons actionHandler:(void (^)(UIAlertController *alertController, NSInteger buttonIndex))block
{
    //防止title 为空字符串时创建提示框使 message 字体变小。
    if (!title.length) {
        title = nil;
    }
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [actionButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull buttonTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block ? block(alertController, idx) : NULL;
        }];
        [alertController addAction:action];
    }];
    //防止alertView动画跟键盘动画冲突
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController* topVC = [UIViewController yzh_findTopViewController];
        topVC = topVC ? topVC : [UIViewController yzh_rootViewController];
        [topVC presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void)showTextAlertTitle:(NSString *)title message:(NSString *)message textFieldPlaceholder:(NSString *)textFieldPlaceholder actionButtons:(NSArray<NSString *> *)actionButtons actionHandler:(void (^)(UIAlertController *alertController,UITextField *textField ,NSInteger buttonIndex))block {
    
    //防止title 为空字符串时创建提示框使 message 字体变小。
    if (!title.length) {
        title = nil;
    }
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField* pwTextField;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        pwTextField = textField;
        pwTextField.placeholder = textFieldPlaceholder;
        pwTextField.secureTextEntry = YES;
    }];
    
    [actionButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull buttonTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block ? block(alertController, pwTextField, idx) : NULL;
        }];
        [alertController addAction:action];
    }];
    
    //防止alertView动画跟键盘动画冲突
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController* topVC = [UIViewController yzh_findTopViewController];
        topVC = topVC ? topVC : [UIViewController yzh_rootViewController];
        [topVC presentViewController:alertController animated:YES completion:nil];
    });
}

@end
