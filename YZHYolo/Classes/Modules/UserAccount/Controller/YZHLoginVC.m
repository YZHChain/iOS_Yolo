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
#import "YZHUserLoginManage.h"

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
    //4.设置View Event
    [self setupViewResponseEvent];
    //5.请求数据
    [self setupData];
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

#pragma mark - 4.Event Response
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
        [hud hideWithText:nil];
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
    // 缓存.
    self.userLoginModel = [YZHLoginModel YZH_objectWithKeyValues:responData];
    NSString* account = self.userLoginModel.acctId;
    NSString* token = self.userLoginModel.token;
    //请求运行登录服务.
    YZHUserLoginManage *loginManage = [YZHUserLoginManage sharedManager];
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.loginView text:nil];
    [loginManage IMServerLoginWithAccount:account token:token successCompletion:^{
        [hud hideWithText:@"登录成功"];
    } failureCompletion:^(NSError *error) {
        // TODO云信登录错误
        [hud hideWithText:error.domain];
    }];
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
