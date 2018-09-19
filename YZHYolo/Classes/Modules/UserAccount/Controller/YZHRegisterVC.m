//
//  YZHRegisterVC.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRegisterVC.h"

#import "YZHPublic.h"
#import "YZHRegisterView.h"
#import "UITextField+YZHTool.h"
#import "NSString+YZHTool.h"

@interface YZHRegisterVC ()<UITextFieldDelegate>

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
    
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_backgroungImage"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupView
{
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
    @weakify(self)
    [self.registerView.getCodeButton bk_addEventHandler:^(id sender) {
        @strongify(self)
        // 获取短信
        [self getMessagingVerificationWithSender:sender];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.registerView.confirmButton bk_addEventHandler:^(id sender) {
        @strongify(self)
        //注册
        [self postRegister];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerView];
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
    
//    NSDictionary* parameter = @{@"code": self.registerView.codeTextField.text,
//                                @"phone": self.registerView.phoneTextField.text
//                                };
//    @weakify(self)
//    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_REGISTERED_CONFIRM params:parameter successCompletion:^(id obj) {
//        @strongify(self)
//        [YZHRouter openURL:kYZHRouterSettingPassword];
//
//    } failureCompletion:^(NSError *error) {
//
//    }];
    [YZHRouter openURL:kYZHRouterSettingPassword];
    
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

- (void)getMessagingVerificationWithSender:(UIButton* )sender{
    
    // 检测手机号,后台请求
    if ([self.registerView.phoneTextField.text yzh_isPhone]) {
        // 处理验证码按钮 倒计时
        
//        [YZHNetworkService shareService] GETNetworkingResource: params:<#(NSDictionary *)#> successCompletion:<#^(id obj)successCompletion#> failureCompletion:<#^(NSError *error)failureCompletion#>
        
    }
    
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
