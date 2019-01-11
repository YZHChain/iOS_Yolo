//
//  YZHBackupBindingPhoneVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHBackupBindingPhoneVC.h"

#import "YZHPublic.h"
#import "UIButton+YZHCountDown.h"
#import "UIButton+YZHTool.h"
#import "NSString+YZHTool.h"
#import "YZHUserLoginManage.h"

@interface YZHBackupBindingPhoneVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation YZHBackupBindingPhoneVC


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
    self.navigationItem.title = @"找回方式";
    
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.subtitleLabel.textColor = [UIColor yzh_buttonBackgroundPinkRed];
    self.subtitleLabel.font = [UIFont yzh_commonLightStyleWithFontSize:12];
    
    self.confirmButton.enabled = NO;
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"button_background_optional"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"button_background_disable"] forState:UIControlStateDisabled];
    [self.confirmButton yzh_setupButton];
    
    [self.phoneNumberTextField becomeFirstResponder];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)onTouchGetCode:(UIButton *)sender {
    
    // 检测手机号,后台请求
    if (YZHIsString(self.phoneNumberTextField.text)) {
        //TODO:
        NSDictionary* parameter = @{
                                    @"phoneNum": self.phoneNumberTextField.text, 
                                    @"type":@(1),
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

- (IBAction)onTouchConfirm:(id)sender {
    
    NSDictionary* parameter = @{
                                @"phoneNum": self.phoneNumberTextField.text ?
                                @"type":@(1),
                                @"verifyCode":self.authCodeTextField.text
                                };
    @weakify(self)
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_REGISTERED_SMSVERIFYCODE) params:parameter successCompletion:^(id obj) {
        @strongify(self)
        [hud hideWithText:nil];
        
        [self backupSecreKey];
        
    } failureCompletion:^(NSError *error) {
        //   error.code = -102;
        [hud hideWithText:error.domain];
//        [self backupSecreKey];
    }];
}

- (void)backupSecreKey {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    NSString* yoloNo = [YZHUserLoginManage sharedManager].currentLoginData.yoloId;
    
    NSDictionary* parameter = @{
                                @"phone": self.phoneNumberTextField.text ? self.phoneNumberTextField.text : @"",
                                @"secretKey": self.secretKey,
                                @"yoloNo": yoloNo ? yoloNo : @"",
                                };
    
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_BACKUPSECRETKEY) params:parameter successCompletion:^(id obj) {
        
        [hud hideWithText:nil];
        [YZHRouter openURL:kYZHRouterBackupCompletion];
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}
#pragma mark - 6.Private Methods

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    if (YZHIsString(self.phoneNumberTextField.text) && YZHIsString(self.authCodeTextField.text)) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

#pragma mark - 7.GET & SET

@end
