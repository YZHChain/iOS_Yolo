//
//  UIWindow+Motion.m
//  YEAMoney
//
//  Created by suke on 2017/6/2.
//  Copyright © 2017年 YEAMoney. All rights reserved.
//

#if DEBUG

#import "UIWindow+Motion.h"

#import <AudioToolbox/AudioToolbox.h>
#import "FLEXManager.h"
#import <objc/runtime.h>
#import "YZHServicesConfig.h"

//参考http://blog.csdn.net/yuanbohx/article/details/34898927

@interface UIWindow()

@end

@implementation UIWindow (Motion)

- (BOOL)canBecomeFirstResponder
{
    if (self == [UIApplication sharedApplication].delegate.window) {
        return YES;
    }
    //其它window返回缺省值，防止iOS8下闪退(例：未设置指纹解锁时在验证手势密码页去开启指纹解锁)，原因未明。
    else {
        return [super canBecomeFirstResponder];
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (![[YZHServicesConfig shareServicesConfig] showDebugView]) {
        // 震动
        [YZHServicesConfig shareServicesConfig].showDebugView = YES;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        // 弹出开发者选项
        [UIAlertView bk_showAlertViewWithTitle:@"Developer Options"
                                       message:@"Developer use only, please careful operation!"
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@[@"App Config", @"Show Explorer", @"Route List"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           if (buttonIndex == 1) {
                                               [YZHRouter openURL:kYZHRouterAppConfig];
                                           } else if (buttonIndex == 2) {
                                               [YZHRouter openURL:@"yeamoney://showExplorer"];
                                               [[FLEXManager sharedManager] showExplorer];
                                           } else if (buttonIndex == 3) {
                                               [YZHRouter openURL:@"yeamoney://routeList"];
                                           }
                                           [YZHServicesConfig shareServicesConfig].showDebugView = NO;
                                       }];
    } else {
        
    }

}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

#pragma mark -- SET -- GET

@end


#endif
