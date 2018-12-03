//
//  YZHPhoneFindPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/3.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPhoneFindPasswordVC.h"

#import "YZHFindPasswordView.h"
#import "YZHPublic.h"
#import "UIButton+YZHCountDown.h"
#import "NSString+YZHTool.h"

@interface YZHPhoneFindPasswordVC ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong)YZHFindPasswordView* findPasswordView;

@end

@implementation YZHPhoneFindPasswordVC

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
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"忘记密码";
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.findPasswordView = [[NSBundle mainBundle] loadNibNamed:@"YZHFindPasswordView" owner:nil options:nil].firstObject;
    self.findPasswordView.frame = self.view.bounds;
    [self.findPasswordView.confirmButton addTarget:self action:@selector(requestRetrievePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.findPasswordView.getSMSCodeButton addTarget:self action:@selector(getMessagingVerificationWithSender:) forControlEvents:UIControlEventTouchUpInside];
    //新版本
    
    [self.view addSubview:self.findPasswordView];
    
    [self.findPasswordView.accountTextField becomeFirstResponder];
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
// 获取密钥.
- (void)requestRetrievePassword:(UIButton*) sender{
    
    NSDictionary* parameter = @{
                                @"phoneNum": self.findPasswordView.accountTextField.text,
                                @"type":@(0),
                                @"verifyCode":self.findPasswordView.SMSCodeTextField.text
                                };
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_REGISTERED_SMSVERIFYCODE params:parameter successCompletion:^(id obj) {
        @strongify(self)
        // 请求后台 成功则跳转至设置新密码 枚举
        
    } failureCompletion:^(NSError *error) {
        [YZHProgressHUD showAPIError:error];
    }];
    
    
}

- (void)getMessagingVerificationWithSender:(UIButton* )sender{
    
    // 检测手机号,后台请求
    if ([self.findPasswordView.accountTextField.text yzh_isPhone]) {
        //TODO:
        NSDictionary* parameter = @{
                                    @"phoneNum": self.findPasswordView.accountTextField.text,
                                    @"type":@(1),
                                    };
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.findPasswordView text:@""];
        // 处理验证码按钮 倒计时
        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_REGISTERED_SENDSMSCODE params:parameter successCompletion:^(id obj) {
            [hud hideWithText:@"验证码已发送至手机"];
            [sender yzh_startWithTime:60 title:sender.currentTitle countDownTitle:nil mainColor:nil countColor:nil];
        } failureCompletion:^(NSError *error) {
            [YZHProgressHUD showAPIError:error];
        }];
        
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

- (void)keyboardNotification{
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
