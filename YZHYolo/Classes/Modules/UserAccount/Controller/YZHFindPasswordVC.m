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
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"找回密码";
 self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.findPasswordView = [YZHFindPasswordView yzh_viewWithFrame:self.view.bounds];
    self.findPasswordView.frame = self.view.bounds;
    [self.findPasswordView.confirmButton addTarget:self action:@selector(requestRetrievePassword) forControlEvents:UIControlEventTouchUpInside];
//    @weakify(self)
//    [self.findPasswordView.getSMSCodeButton bk_addEventHandler:^(id sender) {
//        @strongify(self)
//        // 获取短信
//        [self getMessagingVerificationWithSender:sender];
//    } forControlEvents:UIControlEventTouchUpInside];
    [self.findPasswordView.getSMSCodeButton addTarget:self action:@selector(getMessagingVerificationWithSender:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)requestRetrievePassword{
    
    
    // 请求后台 成功则跳转至设置新密码 枚举
    [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"settingPasswordTypeFind": @(1),
               @"phoneNum":self.findPasswordView.accountTextField.text}];
    
}

- (void)getMessagingVerificationWithSender:(UIButton* )sender{
    
    // 检测手机号,后台请求
    if ([self.findPasswordView.accountTextField.text yzh_isPhone]) {
        NSDictionary* parameter = @{
                                    @"account": self.findPasswordView.accountTextField.text
                                    };
        // 处理验证码按钮 倒计时
        [sender yzh_startWithTime:60 title:sender.currentTitle countDownTitle:nil mainColor:nil countColor:nil];
        //        [YZHNetworkService shareService] GETNetworkingResource: params:<#(NSDictionary *)#> successCompletion:<#^(id obj)successCompletion#> failureCompletion:<#^(NSError *error)failureCompletion#>
//        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_REGISTERED_SMSVERIFYCODE params:parameter successCompletion:^(id obj) {
//            //        @strongify(self)
//            [YZHRouter openURL:kYZHRouterSettingPassword info:@{@"phoneNum":self.registerView.phoneTextField.text}];
//            
//        } failureCompletion:^(NSError *error) {
//            //        error.code = -102;
//            [YZHProgressHUD showAPIError:error];
//        }];
    }
    
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

- (void)keyboardNotification{
    //TODO:需要对 iphoneSE 等小屏做处理, 否则会被键盘盖住.
    //    @weakify(self)
    //    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
    //        @strongify(self)
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
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
