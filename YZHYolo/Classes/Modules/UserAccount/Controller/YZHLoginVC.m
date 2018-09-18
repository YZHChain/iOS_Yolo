//
//  YZHLoginViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLoginVC.h"

#import "YZHPublic.h"
#import "YZHLoginView.h"
#import "YZHRegisterVC.h"
#import "YZHFindPasswordVC.h"

@interface YZHLoginVC ()

@property(nonatomic, strong)YZHLoginView* loginView;

@end

@implementation YZHLoginVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
    [self setupData];
    //4.设置通知
    [self setupNotification];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"去登录";
    
    if (self.gotoRegister) {
        [YZHRouter openURL:kYZHRouterRegister];
    }
}

- (void)setupView
{
    YZHLoginView* loginView = [YZHLoginView yzh_configXibView];
    loginView.frame = self.view.bounds;
    [self.view addSubview:loginView];
    
    [loginView.registerButton addTarget:self action:@selector(gotoRegisterViewController) forControlEvents:UIControlEventTouchUpInside];
    [loginView.findPasswrodButton addTarget:self action:@selector(gotoFindPasswrod) forControlEvents:UIControlEventTouchUpInside];
    self.loginView = loginView;
}

#pragma mark - 3.Request Data

- (void)setupData
{

}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten


#pragma mark - 5.Event Response

- (void)gotoRegisterViewController{
    
//    [self dismissViewControllerAnimated:NO completion:^{
//        [YZHRouter openURL:kYZHRouterLogin info:@{kYZHRouteAnimated: @(NO), @"gotoRegister": @(YES)}];
//    }];
    [YZHRouter openURL:kYZHRouterRegister];
    
}

- (void)gotoFindPasswrod{
    
    [YZHRouter openURL:kYZHRouterFindPassword];

}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

//- (BOOL)hideNavigationBarLine{
//    
//    return YES;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
