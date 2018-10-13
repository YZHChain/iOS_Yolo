//
//  UIViewController+YZHTool.h
//  YZHYolo
//
//  Created by Jerser on 2018/9/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YZHTool)

- (void)yzh_backToRootViewController:(BOOL)animated; //返回根控制器
+ (void)yzh_userLoginSuccessToHomePage;
- (void)yzh_userLoginSuccessToHomePage;
+ (void)yzh_animationReplaceRootViewController:(UIViewController* )viewController;
- (void)yzh_animationReplaceRootViewController:(UIViewController* )viewController;

#pragma mark - To find the ViewController

+ (UIViewController *)yzh_rootViewController;        //根UIViewController
+ (UIViewController *)yzh_findTopViewController;     //当前可见UIViewController

@end
