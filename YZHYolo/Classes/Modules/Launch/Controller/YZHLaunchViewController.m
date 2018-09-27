//
//  YZHLaunchViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLaunchViewController.h"

#import "YZHRootTabBarViewController.h"
#import "YZHWelcomeVC.h"
#import "YZHLoginVC.h"
#import "YZHPublic.h"
#import "YZHBaseNavigationController.h"
@interface YZHLaunchViewController ()

@end

@implementation YZHLaunchViewController

#pragma mark ViewController Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  设置闪屏页
    [self setupSplashScreen];
    //  启动流程
    [self startConfign];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetupView

- (void)setupSplashScreen{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark -- Start

- (void)startConfign{
    
    UIViewController* rootViewController;
    if ([self detectionApplicationStatus]) {
        // 引导页
        YZHWelcomeVC* welcomeVC = [[YZHWelcomeVC alloc] init];
        YZHBaseNavigationController* navigationController = [[YZHBaseNavigationController alloc] initWithRootViewController:welcomeVC];
        rootViewController = navigationController;
    } else {
        // 判断用户是否已登录,
        BOOL hasLogin = NO;
        if (hasLogin) {
            
            rootViewController = [[YZHRootTabBarViewController alloc] init];
            
        } else {
            YZHLoginVC* loginVC = [[YZHLoginVC alloc] init];
            YZHBaseNavigationController* navigationController = [[YZHBaseNavigationController alloc] initWithRootViewController:loginVC];
            navigationController.navigationBar.hidden = YES;
            rootViewController = navigationController;
        }
    }
    [self windowReplaceRootViewController:rootViewController];
    
}

- (BOOL)detectionApplicationStatus{
    
    BOOL firstLaunching = false;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastAppVersion = [userDefaults objectForKey:@"LastAppVersion"];
    NSString *currentAppVersion = [[YZHBundle infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if ([lastAppVersion floatValue] < [currentAppVersion floatValue])
    {
        [userDefaults setValue:currentAppVersion forKey:@"LastAppVersion"];
        [userDefaults synchronize];
        
        firstLaunching = true;
    }
    return firstLaunching;
}

#pragma mark -- Privete

- (void)windowReplaceRootViewController:(UIViewController* )viewController{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
