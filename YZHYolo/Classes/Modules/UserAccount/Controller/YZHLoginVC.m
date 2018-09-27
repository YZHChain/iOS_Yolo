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
#import "YZHRootTabBarViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import "UIViewController+YZHTool.h"

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
    
    [super viewWillAppear:animated];
    
    [self keyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    // 移除通知.
    [self an_unsubscribeKeyboard];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"去登录";
    
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    self.loginView = [YZHLoginView yzh_viewWithFrame:self.view.bounds];
    [self.loginView.confirmButton addTarget:self action:@selector(postLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loginView];
    
    [self.loginView.accountTextField becomeFirstResponder];
}

#pragma mark - 3.Request Data

- (void)setupData
{

}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten


#pragma mark - 5.Event Response
// TODO:请求登录,云信登录待补充
- (void)postLogin{
    
    NSString* account = self.loginView.accountTextField.text;
    NSString* password = self.loginView.passwordTextField.text;
    NSDictionary* parameter = @{@"account"  :account,
                                @"password" :password
                                };
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_LOGIN_LOGINVERIFY params:parameter successCompletion:^(id obj) {
        @strongify(self)
        [self serverloginSuccessWithResponData:obj];
    } failureCompletion:^(NSError *error) {
        //TODO: 失败处理
    }];

}

#pragma mark - 6.Private Methods
// 后台登录成功处理
- (void)serverloginSuccessWithResponData:(id)responData{
    
    
    
}
// 网易IM信登录成功处理
- (void)IMServerLoginSuccessWithResponData:(id)responData{
    
}

- (void)setupNotification
{

}

- (void)keyboardNotification{
    
    @weakify(self)
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        @strongify(self)
        if (isShowing) {
            // TODO: 小屏时最好修改一下.
            self.loginView.y = -(keyboardRect.size.height);
        } else {
            self.loginView.y = 0;
        }
        [self.loginView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - 7.GET & SET


@end
