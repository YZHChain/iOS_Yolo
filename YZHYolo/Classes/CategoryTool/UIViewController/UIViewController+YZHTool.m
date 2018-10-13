//
//  UIViewController+YZHTool.m
//  YZHYolo
//
//  Created by Jerser on 2018/9/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIViewController+YZHTool.h"

#import "YZHRootTabBarViewController.h"
@implementation UIViewController (YZHTool)

#pragma mark extension

- (void)yzh_backToRootViewController:(BOOL)animated {
    
    
}

+ (void)yzh_userLoginSuccessToHomePage {
    
    UIViewController* topViewController = [self yzh_rootViewController];
    [topViewController yzh_userLoginSuccessToHomePage];
}

- (void)yzh_userLoginSuccessToHomePage{
    
    YZHRootTabBarViewController* tabBarViewController = [[YZHRootTabBarViewController alloc] init];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [window setRootViewController:tabBarViewController];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:^(BOOL finished){
                        // 将当前控制器视图移除,否则会造成内存泄漏,被Window 引用无法正常释放.
                        [self.view removeFromSuperview];
                    }];
}

+ (void)yzh_animationReplaceRootViewController:(UIViewController *)viewController {
    UIViewController* topViewController = [self yzh_rootViewController];
    [topViewController yzh_animationReplaceRootViewController:viewController];
}

- (void)yzh_animationReplaceRootViewController:(UIViewController* )viewController{
    
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [window setRootViewController:viewController];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:^(BOOL finished){
                        // 将当前控制器视图移除,否则会造成内存泄漏,被Window 引用无法正常释放.
                        [self.view removeFromSuperview];
                    }];
}


#pragma mark - To find the ViewController

+ (UIViewController *)yzh_rootViewController{
    
    UIWindow* window = YZHAppWindow;
    return window.rootViewController;
}

+ (UIViewController *)yzh_findTopViewController{
    
    UIViewController* currenViewController = [self yzh_rootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currenViewController.presentedViewController) {
            currenViewController = currenViewController.presentedViewController;
        } else {
            if ([currenViewController isKindOfClass:[UINavigationController class]]) {
                currenViewController = [currenViewController.childViewControllers lastObject];
            } else if ([currenViewController isKindOfClass:[UITabBarController class]]) {
                UITabBarController* tabBarController = (UITabBarController* )currenViewController;
                currenViewController = tabBarController.selectedViewController;
            } else {
                if (currenViewController.childViewControllers.count > 0) {
                    currenViewController = [currenViewController.childViewControllers lastObject];
                } else {
                    return currenViewController;
                }
            }
        }
    }
    
    return currenViewController;
}
@end
