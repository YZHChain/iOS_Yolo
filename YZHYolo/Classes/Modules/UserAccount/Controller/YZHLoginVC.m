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
#import "YZHLoginModel.h"

@interface YZHLoginVC ()

@property(nonatomic, strong)YZHLoginView* loginView;
@property (nonatomic, strong) YZHLoginModel* userLoginModel;

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
    //3.设置View Event
    [self setupViewResponseEvent];
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
    self.loginView.accountTextField.text = _phoneString;
    
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
    
}

// 使设置 ExecuteBlock 回调与分离出来, 有利于调试, 提高 Code 可读性
- (void)setupViewResponseEvent {
    
    @weakify(self)
    self.loginView.loginButtonBlock = ^(UIButton *sender) {
        @strongify(self)
        [self setupLoginEvent];
    };
    self.loginView.regesterButtonBlock = ^(UIButton *sender) {
        @strongify(self)
        [self setupRegistEvent];
    };
    self.loginView.findPasswordButtonBlock = ^(UIButton *sender) {
        @strongify(self)
        [self setupFindPasswordEvent];
    };
}

- (void)setupLoginEvent {
    
    NSString* account = self.loginView.accountTextField.text;
    NSString* password = self.loginView.passwordTextField.text;
    NSDictionary* parameter = @{@"account"  :account,
                                @"password" :password
                                };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.loginView text:nil];
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_LOGIN_LOGINVERIFY params:parameter successCompletion:^(id obj) {
        @strongify(self)
        [self serverloginSuccessWithResponData:obj];
    } failureCompletion:^(NSError *error) {
        //TODO: 失败处理
        [hud hideWithAPIError:error];
    }];
}

- (void)setupRegistEvent {
    
    if (YZHIsString(self.loginView.accountTextField.text)) {
        
        [YZHRouter openURL: kYZHRouterRegister info: @{@"phoneNumberString": self.loginView.accountTextField.text}];
    } else {
        [YZHRouter openURL: kYZHRouterRegister];
    }
}

- (void)setupFindPasswordEvent {
    
    if (YZHIsString(self.loginView.accountTextField.text)) {
        
        [YZHRouter openURL: kYZHRouterFindPassword info: @{@"phoneNumberString": self.loginView.accountTextField.text}];
    } else {
        [YZHRouter openURL: kYZHRouterFindPassword];
    }
}


#pragma mark - 6.Private Methods
// 后台登录成功处理
- (void)serverloginSuccessWithResponData:(id)responData{
    
<<<<<<< HEAD
    NSString *account = @"3529437617057729695";
    NSString *token   = @"06a44716b291734937a8b34d73066e7a";
    [[[NIMSDK sharedSDK] loginManager] login:account token:token completion:^(NSError * _Nullable error) {
        if (error == nil) {
            [self IMServerLoginSuccessWithResponData:nil];
        } else {
            // 错误提示
            
        }
    }];
=======
    self.userLoginModel = [YZHLoginModel YZH_objectWithKeyValues:responData];
    
    YZHIMParams params = @{@"accid":self.userLoginModel.acctId,
                           @"token":self.userLoginModel.token
                               };
    // 请求登录云信.
    
>>>>>>> developer
    
}
// 网易IM信登录成功处理
- (void)IMServerLoginSuccessWithResponData:(id)responData{
    
    [self yzh_userLoginSuccessToHomePage];
    
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


#pragma mark - 8. IMLoginDelegate

//- (void)setLoginView:(YZHLoginView *)loginView{
//
//}

@end
