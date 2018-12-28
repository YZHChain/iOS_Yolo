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
#import "YZHUserLoginManage.h"
#import "UIViewController+YZHTool.h"
#import "YZHCheckVersion.h"
#import "YZHLaunchModel.h"

@interface YZHLaunchViewController ()

@property (nonatomic, strong) YZHLaunchModel* viewModel;

@end

@implementation YZHLaunchViewController

#pragma mark ViewController Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置闪屏页
    [self setupSplashScreen];
    // 启动流程
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
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.viewModel = [[YZHLaunchModel alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:self.viewModel.image];
    [self.view addSubview:imageView];
//    self.imageView = imageView;
}

#pragma mark -- Start

- (void)startConfign {
    
    __block UIViewController* rootViewController;
    
    YZHCheckVersion* checkVersion = [YZHCheckVersion shareInstance];
    [checkVersion checkoutCurrentVersionUpdataCompletion:^{
        if ([self detectionApplicationStatus]) {
            // 引导页
            YZHWelcomeVC* welcomeVC = [[YZHWelcomeVC alloc] init];
            YZHBaseNavigationController* navigationController = [[YZHBaseNavigationController alloc] initWithRootViewController:welcomeVC];
            rootViewController = navigationController;
            [self yzh_animationReplaceRootViewController:rootViewController];
        } else {
            // 判断用户是否已登录, 设置用户自动登录.
            [self startAutoLogin];
        }
    }];
}

- (BOOL)detectionApplicationStatus {
    
    BOOL firstLaunching = false;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastAppVersion = [userDefaults objectForKey:@"LastAppVersion"];
    NSString *currentAppVersion = [[YZHBundle infoDictionary] objectForKey:@"CFBundleVersion"];
    if (![currentAppVersion isEqualToString:lastAppVersion]) {
        
        [userDefaults setValue:currentAppVersion forKey:@"LastAppVersion"];
        [userDefaults synchronize];
        firstLaunching = true;
    }
    
    return firstLaunching;
}

#pragma mark -- Privete

// 自动登录
- (void)startAutoLogin {
   
    YZHUserLoginManage* loginManage = [YZHUserLoginManage sharedManager];
    [loginManage executeLogincheckout];
}

@end
