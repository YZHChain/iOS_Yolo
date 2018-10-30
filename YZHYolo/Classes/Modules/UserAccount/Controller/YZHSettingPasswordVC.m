//
//  YZHSettingPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSettingPasswordVC.h"

#import "YZHSettingPasswordView.h"
#import "YZHRootTabBarViewController.h"
#import "YZHProgressHUD.h"
#import "YZHUserLoginManage.h"

@interface YZHSettingPasswordVC ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong)YZHSettingPasswordView* settingPasswordView;

@end

@implementation YZHSettingPasswordVC

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

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置密码";
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    self.settingPasswordView = [YZHSettingPasswordView yzh_viewWithFrame:self.view.bounds];
    if (self.settingPasswordType == YZHSettingPasswordTypeFind) {
        self.settingPasswordView.navigationTitleLaebl.text = @"忘记密码";
        self.settingPasswordView.tileTextLabel.text = @"设置新密码";
//        [self.settingPasswordView.confirmButton setTitle:@"完成" forState:UIControlStateNormal];
//        [self.settingPasswordView.confirmButton setTitle:@"完成" forState:UIControlStateDisabled];
    }
    [self.settingPasswordView.confirmButton addTarget:self action:@selector(requestSettingPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.settingPasswordView];
    
    [self.settingPasswordView.passwordTextField becomeFirstResponder];
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

- (void)requestSettingPassword{
    
    NSString* requestURL;
    switch (_settingPasswordType) {
        case YZHSettingPasswordTypeRegister:
            requestURL = PATH_USER_REGISTERED_REGISTEREDNVERIFY;
            break;
            case YZHSettingPasswordTypeFind:
            requestURL = PATH_USER_LOGIN_FORGETPASSWORD;
        default:
            requestURL = PATH_USER_REGISTERED_REGISTEREDNVERIFY;
            break;
    }
    NSDictionary* parameters = @{@"password":self.settingPasswordView.passwordTextField.text,
          @"phoneNum":self.phoneNum };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.settingPasswordView text:nil];
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:requestURL params:parameters successCompletion:^(id obj) {
        [hud hideWithText:nil];
        @strongify(self)
        if (self.settingPasswordType == YZHSettingPasswordTypeRegister) {
            [self autoLoginWithResponse:obj];
        } else {
            
        }
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

#pragma mark - 6.Private Methods
// 注册时设置完密码自动登录
- (void)autoLoginWithResponse:(id)response {
    
    YZHLoginModel* model = [YZHLoginModel YZH_objectWithKeyValues:response];
    
    YZHUserLoginManage* manage = [[YZHUserLoginManage alloc] init];
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.settingPasswordView text:nil];
    [manage IMServerLoginWithAccount:model.acctId token:model.token successCompletion:^{
        //TODO:
        [hud hideWithText:@"登录成功"];
    } failureCompletion:^(NSError *error) {
        // TODO:云信登录错误 需要和产品确认
        [hud hideWithText:error.domain];
    }];
}

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
