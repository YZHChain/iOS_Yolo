//
//  YZHProgressHUD.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YZHHUDNetworkStatusTypeSucceed,
    YZHHUDNetworkStatusTypeDefeated,
    YZHHUDNetworkStatusTypeLoading,
    YZHHUDNetworkStatusTypeWarning,
    YZHHUDNetworkStatusTypeSystemError,
} YZHHUDNetworkStatusType;//网络指示器状态类型

@interface YZHProgressHUD : NSObject

//弹出API错误提示
+ (void)showAPIError:(NSError *)error;
//Alert提醒框 4.0修改。
+ (void)showAlertMessage:(NSString *)message;
//文本提醒, 停留1.5s, 原有实现基础上 修改限制最小宽230、高45、 文本与HUD边距为10。
+ (void)showText:(NSString *)text onView:(UIView *)view;
//文本提醒, 停留1.5s, 完成后执行completion
+ (void)showText:(NSString *)text onView:(UIView *)view completion:(void (^)(void))completion;
//文本提醒, 自定义图像, 停留1.5s。完成后执行completion  HUD最小为120.120。
+ (void)showText:(NSString *)text image:(UIImage*)image onView:(UIView *)view completion:(void (^)(void))completion;
//文本提醒, 自定义图像, 停留1.5S。 HUD可设置最小大小。图片或文字与HUD边距默认20, 当文字或图片过宽或过高时, 自适应使HUD按边距20 变大。
+ (void)showText:(NSString *)text customView:(UIView *)customView minSize:(CGSize)minSize onView:(UIView *)view completion:(void (^)(void))completion;
//文本提醒, 图像，停留1.5S。根据hudType、 展示不同状态网络指示器漏点图、
+ (void)showText:(NSString *)text onView:(UIView *)view statusType:(YZHHUDNetworkStatusType)statusType completion:(void (^)(void))completion;
//loading HUD,可带文字
+ (YZHProgressHUD *)showLoadingOnView:(UIView *)view text:(NSString *)text;
//loading HUD,图片 + 文字
+ (YZHProgressHUD *)showLoadingOnView:(UIView *)view text:(NSString *)text statusType:(YZHHUDNetworkStatusType)statusType;

//隐藏HUD, 弹出API错误提示
- (void)hideWithAPIError:(NSError *)error;
//隐藏HUD,弹出Alert提醒框
- (void)hideWithAlert:(NSString *)text;
//隐藏HUD,可带文字,停留1.5s
- (void)hideWithText:(NSString *)text;
//隐藏HUD,可带文字,停留1.5s，完成后执行completion
- (void)hideWithText:(NSString *)text completion:(void (^)(void))completion;

@end
