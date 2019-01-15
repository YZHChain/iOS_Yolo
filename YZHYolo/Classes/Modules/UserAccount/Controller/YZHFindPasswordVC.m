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
#import "UIButton+YZHCountDown.h"
#import "NSString+YZHTool.h"

@interface YZHFindPasswordVC ()<UIGestureRecognizerDelegate>

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

    [super viewWillAppear:animated];
    
    if (self.secretKey) {
        self.findPasswordView.passwordTextView.text = self.secretKey;
        self.findPasswordView.nextButton.enabled = YES;
    }
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
    self.findPasswordView = [[NSBundle mainBundle] loadNibNamed:@"YZHFindPasswordView" owner:nil options:nil].lastObject;
    self.findPasswordView.frame = self.view.bounds;
    self.findPasswordView.accountTextField.text = self.phoneNumberString;
    [self.findPasswordView.confirmButton addTarget:self action:@selector(requestRetrievePassword:) forControlEvents:UIControlEventTouchUpInside];
    
    //新版本
    [self.findPasswordView.nextButton addTarget:self action:@selector(onTouchNext:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.findPasswordView.tipButton addTarget:self action:@selector(onTouchPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.findPasswordView];
    
    [self.findPasswordView.passwordTextView becomeFirstResponder];
    
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

- (void)requestRetrievePassword:(UIButton*) sender{
    
    NSDictionary* parameter = @{
                                @"phoneNum": self.findPasswordView.accountTextField.text ? self.findPasswordView.accountTextField.text : @"",
                                @"type":@(1),
                                @"verifyCode":self.findPasswordView.SMSCodeTextField.text
                                };
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_REGISTERED_SMSVERIFYCODE) params:parameter successCompletion:^(id obj) {
        @strongify(self)
        // 请求后台 成功则跳转至设置新密码 枚举
        [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"settingPasswordType": @(1),
                                                            @"phoneNum":self.findPasswordView.accountTextField.text}];
    } failureCompletion:^(NSError *error) {
        //        error.code = -102;
        [YZHProgressHUD showAPIError:error];
    }];

}

- (void)getMessagingVerificationWithSender:(UIButton* )sender{
    
    // 检测手机号,后台请求
    if (YZHIsString(self.findPasswordView.accountTextField.text)) {
        //TODO:
        NSString* yoloNo = [YZHUserLoginManage sharedManager].currentLoginData.yoloId;
        NSDictionary* parameter = @{
                                    @"phoneNum": self.findPasswordView.accountTextField.text ? self.findPasswordView.accountTextField.text : @"",
                                    @"type":@(1),
                                    @"yoloNo": yoloNo ? yoloNo : @""
                                    };
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.findPasswordView text:@""];
        // 处理验证码按钮 倒计时
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_REGISTERED_SENDSMSCODE) params:parameter successCompletion:^(id obj) {
            [hud hideWithText:@"验证码已发送至手机"];
            [sender yzh_startWithTime:60 title:sender.currentTitle countDownTitle:nil mainColor:nil countColor:nil];
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:error.domain];
        }];
    } else {
        [YZHProgressHUD showText:@"请输入正确格式手机号" onView:self.view];
    }
}

// 下一步
- (void)onTouchNext:(UIButton *)sender {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    NSDictionary *dic = @{
                          @"secretKey": self.findPasswordView.passwordTextView.text
                          };
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_CHECKSECRETKEY) params:dic successCompletion:^(id obj) {
        [hud hideWithText:nil];
        //跳转至重新设置密码
        // 请求后台 成功则跳转至设置新密码 枚举
        [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"settingPasswordType": @(1),
                                                            @"phoneNum":obj}];
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
   
}

// 手机号码获取密钥
- (void)onTouchPhone:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterPhoneGetSecretKey info:@{
                                                          @"forgetPassword": @(YES)
                                                          }];
    
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
