//
//  YZHAlertManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZHAlertManage : NSObject

//Alert提醒框 4.0修改。标题默认温馨提示
+ (void)showAlertMessage:(NSString *)message;
//UIAlertController 提醒框
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message actionButtons:(NSArray<NSString *> *)actionButtons actionHandler:(void (^)(UIAlertController *alertController, NSInteger buttonIndex))block;

@end
