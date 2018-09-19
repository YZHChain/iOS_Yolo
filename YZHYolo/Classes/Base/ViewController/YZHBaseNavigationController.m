//
//  YZHBaseNavigationController.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseNavigationController.h"

@interface YZHBaseNavigationController ()

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
    
    self.navigationBar.hidden = YES;
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSInteger count = self.viewControllers.count;
    if (count > 0) {
        //push后隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
//        //设置返回按钮
//        UIViewController *priorVC = self.viewControllers[count-1];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} forState:UIControlStateNormal];
//        priorVC.navigationItem.backBarButtonItem = item;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    NSInteger count = viewControllers.count;
    if (count > 1) {
        //push后隐藏tabBar
        viewControllers.lastObject.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
