//
//  YZHBaseNavigationController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseNavigationController.h"

@interface YZHBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation YZHBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar{
    
    self.navigationController.delegate = self;
    self.navigationBar.translucent = NO;
    [self.navigationBar setBarTintColor:[UIColor yzh_backgroundDarkBlue]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
}

#pragma mark -- Push Pop
// 保证导航栏展示根控制器时, 隐藏状态。Push 之后隐藏Bar。并显示导航栏.  此方法在 ViewController 视图生命周期之后, 所以如果想单独配置并不会影响。  TODO: 还是需要再每个控制器添加一段隐藏Naviga 的代码,因为 pop 回来时,是显示的状态.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSInteger viewControllerCount = self.viewControllers.count;
    if (viewControllerCount > 0) {
        //push后隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
    }
    [super pushViewController:viewController animated:animated];
}
// 保证每次到 RootViewController 时导航栏隐藏.

// 直接通过 set 方法设置时也要将其 Bar 隐藏起来.
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    NSInteger count = viewControllers.count;
    if (count > 1) {
        //push后隐藏tabBar
        viewControllers.lastObject.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark -- delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
//    self.navigationController.viewControllers
    NSLog(@"导航栏检测");
    
}

@end
