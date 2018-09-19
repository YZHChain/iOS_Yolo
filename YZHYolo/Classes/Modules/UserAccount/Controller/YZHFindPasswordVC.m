//
//  YZHFindPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHFindPasswordVC.h"

#import "YZHFindPasswordView.h"
#import "YZHPublic.h"
@interface YZHFindPasswordVC ()

@property(nonatomic, strong)YZHFindPasswordView* findPasswordView;

@end

@implementation YZHFindPasswordVC


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
    
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"找回密码";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.findPasswordView = [YZHFindPasswordView yzh_viewWithFrame:self.view.bounds];
    self.findPasswordView.frame = self.view.bounds;
    [self.findPasswordView.confirmButton addTarget:self action:@selector(requestRetrievePassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.findPasswordView];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

#pragma mark - 5.Event Response

- (void)requestRetrievePassword{
    
    // 请求后台 成功则跳转至设置新密码
    [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"hasFindPassword": @(YES)}];
    
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
