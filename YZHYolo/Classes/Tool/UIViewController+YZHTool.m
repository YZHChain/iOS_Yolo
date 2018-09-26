//
//  UIViewController+YZHTool.m
//  YZHYolo
//
//  Created by Jerser on 2018/9/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIViewController+YZHTool.h"

@implementation UIViewController (YZHTool)


#pragma mark - To find the ViewController

+ (UIViewController *)yzh_rootViewController{
    
    UIWindow* window = YZHWindow;
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
