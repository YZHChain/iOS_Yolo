//
//  YZHPhoneGetSecretKeyVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHPhoneGetSecretKeyVC.h"

#import "YZHPublic.h"
#import "UIButton+YZHTool.h"
#import "UIButton+YZHCountDown.h"

@interface YZHPhoneGetSecretKeyVC ()

@property (weak, nonatomic) IBOutlet UITextField *phontTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *topContentView;

@end

@implementation YZHPhoneGetSecretKeyVC


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

- (void)setupNavBar {
    
    self.navigationItem.title = @"手机号获取密钥";
    if (self.forgetPassword) {
        self.navigationItem.title = @"忘记密码";
    }
    
    self.hideNavigationBar = YES;
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.topContentView yzh_addGradientLayerView];
    
    [self.phontTextField becomeFirstResponder];
    
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"button_background_optional"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"button_background_disable"] forState:UIControlStateDisabled];
    self.confirmButton.enabled = NO;
    [self.confirmButton yzh_setupButton];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)onTouchCancel:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTouchGetAuthCode:(UIButton *)sender {
    
    // 检测手机号,后台请求
    if (YZHIsString(self.phontTextField.text)) {
        //TODO:
        NSString* yoloNo = [YZHUserLoginManage sharedManager].currentLoginData.yoloId;
        NSDictionary* parameter = @{
                                    @"phoneNum": self.phontTextField.text,
                                    @"type":@(0),
                                    @"yoloNo": yoloNo ? yoloNo : @""
                                    };
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:@""];
        // 处理验证码按钮 倒计时
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_REGISTERED_SENDSMSCODE) params:parameter successCompletion:^(id obj) {
            [hud hideWithText:@"验证码已发送至手机"];
            [sender yzh_startWithTime:60 title:sender.currentTitle countDownTitle:nil mainColor:nil countColor:nil];
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:error.domain];
        }];
    } else {
        [YZHProgressHUD showText:@"请输入正确的手机号码!" onView:self.view];
    }
}

- (IBAction)onTouchComfirm:(UIButton *)sender {
    

        NSDictionary* parameter = @{
                                    @"phoneNum": self.phontTextField.text,
                                    @"type":@(0),
                                    @"verifyCode": self.authCodeTextField.text
                                    };
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:@""];
        // 处理验证码按钮 倒计时
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_REGISTERED_SMSVERIFYCODE) params:parameter successCompletion:^(id obj) {
            @strongify(self)
            if (self.forgetPassword) {
                
                [hud hideWithText:nil];
                [YZHRouter openURL:kYZHRouterPhoneAndAppGetSecretKey info:@{
                                                                            @"phoneNumber": self.phontTextField.text
                                                                            }];
                
            } else {
                NSDictionary* dic = @{
                                      @"phone": self.phontTextField.text,
                                      @"receiveType": @(1)
                                      };
                [[YZHNetworkService shareService] GETNetworkingResource:SERVER_LOGIN(PATH_USER_GETECRETKEY) params:dic successCompletion:^(id obj) {
                    [hud hideWithText:@"密钥已发送到您的手机" completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                } failureCompletion:^(NSError *error) {
                    [hud hideWithText:error.domain];
                }];
            }
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:error.domain];
        }];

}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification* )notification {
    
    if (YZHIsString(self.phontTextField.text) && YZHIsString(self.authCodeTextField.text)) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma mark - 7.GET & SET

@end
