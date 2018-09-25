//
//  YZHProgressHUD.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHProgressHUD.h"

#import "Aspects.h"
#import "MBProgressHUD.h"
#import "UIViewController+YZHTool.h"

//文本提示停留时间
static NSTimeInterval const YZHProgressHUDTextDelay = 1.5;
//MBProgressHUD 自定义视图 图像与Label默认偏移量
static NSUInteger const YZHProgressCustomHUDOffsetY = 5;
// UIAlertMessage 默认标题
static NSString* const YZHAlertMessageTitle = @"温馨提示";
//API错误提示类型
typedef NS_ENUM(NSInteger, YZHAPIErrorHUDType) {
    YZHAPIErrorHUDTypeAlert  = -101, // 弹框提示
    YZHAPIErrorHUDTypeText   = -102, // 吐司提示
};

@interface YZHProgressHUD()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation YZHProgressHUD
/**
 *  弹出API错误提示
 *
 *  @param error 错误信息
 */
+ (void)showAPIError:(NSError *)error
{
    switch (error.code) {
        case YZHAPIErrorHUDTypeAlert:  // 弹框提示
        {
            [YZHProgressHUD showAlertMessage:error.domain];
        }
            break;
        case YZHAPIErrorHUDTypeText:  // 吐司提示
        {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            [YZHProgressHUD showText:error.domain onView:window];
        }
            break;
            
        default:  // 缺省为吐司提示
        {
            if (error.domain.length) {
                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                [YZHProgressHUD showText:error.domain onView:window];
            }
        }
            break;
    }
}
//Alert提醒框   将UIAlertView 替换成 UIAlertController
+ (void)showAlertMessage:(NSString *)message
{
    if (message.length == 0) {
        return;
    }
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:YZHAlertMessageTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    //防止alertView动画跟键盘动画冲突
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController* topVC = [UIViewController yzh_findTopViewController];
        topVC = topVC ? topVC : [UIViewController yzh_rootViewController];
        [topVC presentViewController:alertController animated:YES completion:nil];
    });
}
//文本提醒,停留1.5s
+ (void)showText:(NSString *)text onView:(UIView *)view
{
    [self showText:text onView:view completion:nil];
}
//文本提醒，停留1.5s，完成后执行completion
+ (void)showText:(NSString *)text onView:(UIView *)view completion:(void (^)(void))completion
{
    UIView *finalView = [view isKindOfClass:[UIWindow class]] ? view : view.window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:finalView];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    [self setupHUD:hud];
    hud.completionBlock = completion;
    [finalView addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:YZHProgressHUDTextDelay];
}
//文本提醒，自定义图像，停留1.5s，完成后执行completion
+ (void)showText:(NSString *)text image:(UIImage*)image onView:(UIView *)view completion:(void (^)(void))completion
{
    UIView *finalView = [view isKindOfClass:[UIWindow class]] ? view : view.window;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:finalView];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.detailsLabelText = text;
    [self setupHUD:hud];
    hud.completionBlock = completion;
    hud.minSize = CGSizeMake(120, 120);
    [finalView addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:YZHProgressHUDTextDelay];
    
}
//自定义图片和文字指示图、停留1.5S。 HUD可设置最小大小。图片或文字与HUD边距默认20、当文字或图片过宽或过高时、自适应使HUD按边距20 变大。
+ (void)showText:(NSString *)text customView:(UIView *)customview minSize:(CGSize)minSize onView:(UIView *)view completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *finalView = [view isKindOfClass:[UIWindow class]] ? view : [UIApplication sharedApplication].delegate.window;
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:finalView];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = customview;
        hud.detailsLabelText = text;
        // 统一设置hud规格
        [self setupHUD:hud];
        hud.completionBlock = completion;
        // 默认取最小长宽 120、120。 如果展示图片或文字与HUD间距小于默认设置的 margin 边距20 则HUD会自动变大。不在受minSize控制。
        if (minSize.width && minSize.height) {
            hud.minSize = minSize;
        } else {
            hud.minSize = CGSizeMake(120, 120);
        }
        [finalView addSubview:hud];
        // 调整自定义图片 和 Label的间距。 默认 图片向上偏移 5、 Label 向下偏移 5。
        [self adjustCenterAfterLayout:hud labeltext:text];
        [hud show:YES];
        [hud hide:YES afterDelay:YZHProgressHUDTextDelay];
    });
}
/**
 *  图像 + 文本提醒。 根据hudType、 展示不同状态网络指示图。
 *
 *  @param statusType 网络指示器状态类型
 */
+(void)showText:(NSString *)text onView:(UIView *)view statusType:(YZHHUDNetworkStatusType)statusType completion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView* finalView = [view isKindOfClass:[UIWindow class]] ? view : [UIApplication sharedApplication].delegate.window;
        MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:finalView];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabelText = text;
        hud.customView = [self matchingCreateImageViewFormStatusType:statusType];
        // 统一设置hud规格
        [self setupHUD:hud];
        hud.completionBlock = completion;
        if (statusType == YZHHUDNetworkStatusTypeSystemError) {
            hud.minSize = CGSizeMake(200, 104);
        } else {
            hud.minSize = CGSizeMake(120, 120);
        }
        [finalView addSubview:hud];
        // 调整自定义图片 和 Label的间距。 默认 图片向上偏移 5、 Label 向下偏移 5。
        [self adjustCenterAfterLayout:hud labeltext:text];
        [hud show:YES];
        [hud hide:YES afterDelay:YZHProgressHUDTextDelay];
    });
}
//loading HUD,可带文字
+ (YZHProgressHUD *)showLoadingOnView:(UIView *)view text:(NSString *)text
{
    YZHProgressHUD *progressHUD = [[YZHProgressHUD alloc] init];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = text;
    [self setupHUD:hud];
    [view addSubview:hud];
    [hud show:YES];
    
    progressHUD.hud = hud;
    return progressHUD;
}
//loading HUD,图片 + 文字
+ (YZHProgressHUD *)showLoadingOnView:(UIView *)view text:(NSString *)text statusType:(YZHHUDNetworkStatusType)statusType
{
    YZHProgressHUD * progressHUD = [[YZHProgressHUD alloc] init];
    UIView *finalView = [view isKindOfClass:[UIWindow class]] ? view : [UIApplication sharedApplication].delegate.window;
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:finalView];
    hud.detailsLabelText = text;
    [self setupCustomViewHUD:hud statusType:statusType];
    
    [view addSubview:hud];
    [hud show:YES];
    
    progressHUD.hud = hud;
    return progressHUD;
}
//设置HUD样式UI
+ (void)setupHUD:(MBProgressHUD *)hud
{
    UIActivityIndicatorView *indicator = [hud valueForKey:@"indicator"];
    if ([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.opacity = 0.5;
    hud.cornerRadius = 5.0;
    hud.color = [UIColor colorWithWhite:0.1 alpha:0.7];
}
//统一设置图像+文字HUD
+ (void)setupCustomViewHUD:(MBProgressHUD *)hud statusType:(YZHHUDNetworkStatusType)statusType
{
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    [self setupHUD:hud];
    hud.customView = [self matchingCreateImageViewFormStatusType:statusType];
}

#pragma mark - Object Method

//隐藏loading HUD,弹出Alert提醒框
- (void)hideWithAlert:(NSString *)text
{
    [self hideWithText:nil completion:nil];
    [YZHProgressHUD showAlertMessage:text];
}

//隐藏loading HUD,可带文字,停留1.5s
- (void)hideWithText:(NSString *)text
{
    [self hideWithText:text completion:nil];
}

//隐藏loading HUD,可带文字,停留1.5s，完成后执行completion
- (void)hideWithText:(NSString *)text completion:(void (^)(void))completion
{
    self.hud.completionBlock = completion;
    if (text.length) {
        self.hud.mode = MBProgressHUDModeText;
        //        self.hud.labelText = text;
        self.hud.detailsLabelText = text;
        [self.hud hide:YES afterDelay:YZHProgressHUDTextDelay];
    } else {
        [self.hud hide:NO];
    }
}

#pragma mark -- Adjust UI Space
//调整文字与指示图间距、如文字存在则调整。否则图片居中展示。
+ (void)adjustCenterAfterLayout:(MBProgressHUD *)hud labeltext:(NSString *)labeltext
{
    // 如果只有图片无文字则不需要调整、图片居中显示
    if (labeltext) {
        //修复MBProgressHUD 自定义视图与Label间距过小
        [hud aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            
            CGRect rect = hud.customView.frame;
            rect.origin.y -= YZHProgressCustomHUDOffsetY;
            hud.customView.frame = rect;
            
            for (id obj in hud.subviews) {
                if ([obj isMemberOfClass:[UILabel class]]) {
                    NSString* objText = [obj valueForKey:@"text"];
                    if ([objText isEqualToString:labeltext]) {
                        UILabel* label = obj;
                        CGRect rect = label.frame;
                        rect.origin.y += YZHProgressCustomHUDOffsetY;
                        label.frame = rect;
                    }
                }
            }
        } error:NULL];
    }
}

#pragma mark -- Privat Method
/**
 *  根据状态、返回对应类型的图片视图。
 *
 *  @param statusType 网络指示器状态类型
 */
+ (UIImageView* )matchingCreateImageViewFormStatusType:(YZHHUDNetworkStatusType)statusType
{
    UIImageView* imageView = [[UIImageView alloc] init];
    switch (statusType) {
        case YZHHUDNetworkStatusTypeSucceed:
            imageView.image = [UIImage imageNamed:@"toast_success"];
            imageView.frame = CGRectMake(0, 0, 28, 28);
            break;
        case YZHHUDNetworkStatusTypeDefeated:
            imageView.image = [UIImage imageNamed:@"toast_warning"];
            imageView.frame = CGRectMake(0, 0, 28, 28);
            break;
        case YZHHUDNetworkStatusTypeLoading:
            imageView.image = [UIImage imageNamed:@"gesture_pwd_logo"];
            imageView.frame = CGRectMake(0, 0, 40, 40);
            break;
        case YZHHUDNetworkStatusTypeWarning:
            imageView.image = [UIImage imageNamed:@"toast_warning"];
            imageView.frame = CGRectMake(0, 0, 28, 28);
            break;
        case YZHHUDNetworkStatusTypeSystemError:
            imageView.image = [UIImage imageNamed:@"240x240"];
            imageView.frame = CGRectMake(0, 0, 40, 17);
            break;
            
        default:
            break;
    }
    return imageView;
}
/**
 *  隐藏HUD，弹出API错误提示
 *
 *  @param error 错误信息
 */
- (void)hideWithAPIError:(NSError *)error
{
    switch (error.code) {
        case YZHAPIErrorHUDTypeAlert:  // 弹框提示
        {
            [self hideWithText:nil completion:nil];
            [YZHProgressHUD showAlertMessage:error.domain];
        }
            break;
        case YZHAPIErrorHUDTypeText:  // 吐司提示
        {
            [self hideWithText:error.domain completion:nil];
        }
            break;
            
        default:  // 缺省为吐司提示
        {
            [self hideWithText:error.domain completion:nil];
        }
            break;
    }
}

@end
