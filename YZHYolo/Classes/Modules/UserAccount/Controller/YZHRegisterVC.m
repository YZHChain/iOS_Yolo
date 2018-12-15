//
//  YZHRegisterVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRegisterVC.h"

#import "YZHPublic.h"
#import "YZHRegisterView.h"
#import "NSString+YZHTool.h"
#import "UIViewController+KeyboardAnimation.h"
#import "UIButton+YZHCountDown.h"
#import "YZHBaseNavigationController.h"

@interface YZHRegisterVC ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong)YZHRegisterView* registerView;

@end

@implementation YZHRegisterVC

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

- (void)setupNavBar {
 self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.hideNavigationBar = YES;
}

- (void)setupView {
    
    self.registerView = [YZHRegisterView yzh_viewWithFrame:self.view.bounds];
    if (self.hiddenBack == YES) {
        // TODO:  封装一个快速优雅的隐藏. 不能导致图层混用.
        self.registerView.backButton.enabled = NO;
        self.registerView.backIconButton.hidden = YES;
        self.registerView.backTextButton.hidden = YES;
    }
    if (self.phoneNumberString.length > 0) {
        self.registerView.phoneTextField.text = self.phoneNumberString;
    }
//    @weakify(self)
//    [self.registerView.getCodeButton bk_addEventHandler:^(id sender) {
//        @strongify(self)
//        // 获取短信
//        [self getMessagingVerificationWithSender:sender];
//    } forControlEvents:UIControlEventTouchUpInside];
    
//    [self.registerView.confirmButton bk_addEventHandler:^(id sender) {
//        @strongify(self)
//        //注册
//        [self postRegister];
//    } forControlEvents:UIControlEventTouchUpInside];
    [self.registerView.registerButton addTarget:self action:@selector(clickRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerView.protocolButton addTarget:self action:@selector(clickReadProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerView];
    
    [self.registerView.phoneTextField becomeFirstResponder];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITextFieldDelegaten

#pragma mark - 5.Event Response

- (void)postRegister{
    
    NSDictionary* parameter = @{
                                 @"verifyCode": self.registerView.codeTextField.text,
                                 @"phoneNum": self.registerView.phoneTextField.text };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.registerView text:nil];
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_REGISTERED_SMSVERIFYCODE params:parameter successCompletion:^(NSObject* obj) {
        if ([obj.yzh_apiCode isEqualToString:@"200"]) {
            [hud hideWithText:nil];
            @strongify(self)
            [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"phoneNum":self.registerView.phoneTextField.text}];
        }
    } failureCompletion:^(NSError *error) {

        [hud hideWithText:error.domain];
    }];
}
//获取短信
- (void)getMessagingVerificationWithSender:(UIButton* )sender{
    
    NSString* phoneNumText = self.registerView.phoneTextField.text;
    // 检测手机号,后台请求
    if ([phoneNumText yzh_isPhone]) {
        NSDictionary* parameters = @{
                                     @"phoneNum":  phoneNumText,
                                     @"type":@(0),};
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.registerView text:nil];
        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_REGISTERED_SENDSMSCODE params:parameters successCompletion:^(NSObject* obj) {
            if ([obj.yzh_apiCode isEqualToString:@"200"]) {
                [hud hideWithText:obj.yzh_apiDetail];
                // 处理验证码按钮 倒计时
                [sender yzh_startWithTime:60 title:sender.currentTitle countDownTitle:nil mainColor:nil countColor:nil];
            }
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:error.domain];
        }];
    } else {
        [YZHProgressHUD showText:@"请输入正确的手机号码!" onView:self.registerView];
    }
    
}
// 新版注册. 
- (void)clickRegister:(UIButton *)sender {

    if (YZHIsString(self.registerView.codeTextField.text)) {
        
        [self checkoutInviteCode];
    } else {
        [self checkoutYoloNo];
    }
}
//SuccessCompletion:(YZHVoidBlock)successCompletion
- (void)checkoutInviteCode {
    
    NSDictionary* dic = @{
                          @"inviteCode":self.registerView.codeTextField.text
                          };
    @weakify(self)
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [[YZHNetworkService shareService] GETNetworkingResource:PATH_USER_REGISTERED_CHECKINVITECODE params:dic successCompletion:^(id obj) {
        @strongify(self)
        [hud hideWithText:nil];
        self.registerView.codeTipLabel.hidden = YES;
        self.registerView.codeTipLabel.text = nil;
        [self checkoutYoloNo];
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
        self.registerView.codeTipLabel.hidden = NO;
        if (error.domain) {
            self.registerView.codeTipLabel.text = error.domain;
        } else {
            self.registerView.codeTipLabel.text = @"邀请码输入错误";
        }
    }];
}

- (void)checkoutYoloNo {
    
    NSDictionary* dic = @{
                          @"yoloNo":self.registerView.phoneTextField.text.length ? self.registerView.phoneTextField.text : @""
                          };
    //检测 Yolo 号是否可用
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_CHECKOUTYOLOID params:dic successCompletion:^(id obj) {
        @strongify(self)
        [hud hideWithText:nil];
        // 跳转至设置密码,并且带 YoloID,和邀请码.
        [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"phoneNum":self.registerView.phoneTextField.text, @"settingPasswordType": @(0), @"inviteCode": self.registerView.codeTextField.text.length ? self.registerView.codeTextField.text : @""}];
        
    } failureCompletion:^(NSError *error) {
        
        [hud hideWithText:error.domain];
    }];
}

// 阅读协议.
- (void)clickReadProtocol:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterWKWeb info:@{
                                              @"navTitle": @"注册协议"
                                              }];
}
#pragma mark - 6.Private Methods

- (void)setupNotification
{

}

- (void)keyboardNotification{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.registerView.phoneTextField]) {
        if (textField.text.length >= 16 && string.length == 0) {
            return NO;
        }
    } else {
        if (textField.text.length >= 4 && string.length == 0) {
            return NO;
        }
    }
    
    return YES;
    
}

#pragma mark - 7.GET & SET

@end
