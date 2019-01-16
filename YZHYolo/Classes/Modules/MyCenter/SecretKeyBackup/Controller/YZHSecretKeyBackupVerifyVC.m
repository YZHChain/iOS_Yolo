//
//  YZHSecretKeyBackupVerifyVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHSecretKeyBackupVerifyVC.h"

#import "UIButton+YZHClickHandle.h"
#import "UIButton+YZHTool.h"
#import "YZHPublic.h"
#import "UIViewController+KeyboardAnimation.h"

@interface YZHSecretKeyBackupVerifyVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *secretKeyTextView;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UILabel *protocalLabel;
@property (weak, nonatomic) IBOutlet UIButton *protocalButton;
@property (weak, nonatomic) IBOutlet UIButton *backupButton;

@end

@implementation YZHSecretKeyBackupVerifyVC


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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self keyboardNotification];
    
    [self setupNavBar];
    
    [self.secretKeyTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    // 移除通知.
    [self an_unsubscribeKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"备份密钥";
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.titleLabel.font = [UIFont yzh_commonFontStyleFontSize:18];
    
    self.contentLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.contentLabel.font = [UIFont yzh_commonFontStyleFontSize:15];
    
    self.subtitleLabel.textColor = [UIColor yzh_separatorLightGray];
    self.subtitleLabel.font = [UIFont yzh_commonFontStyleFontSize:15];
    
    self.secretKeyTextView.textColor = [UIColor yzh_fontShallowBlack];
    self.secretKeyTextView.font = [UIFont yzh_commonFontStyleFontSize:15];
    self.secretKeyTextView.layer.borderColor = [UIColor yzh_sessionCellGray].CGColor;
    self.secretKeyTextView.layer.borderWidth = 1;
    self.secretKeyTextView.layer.masksToBounds = YES;
    
    self.checkoutButton.titleLabel.textColor = [UIColor whiteColor];
    [self.checkoutButton.titleLabel setFont:[UIFont yzh_commonFontStyleFontSize:13]];
    self.checkoutButton.layer.cornerRadius = 2;
    self.checkoutButton.layer.masksToBounds = YES;
    
    self.protocalLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.protocalLabel.font = [UIFont yzh_commonStyleWithFontSize:12];
    
    self.protocalButton.selected = NO;
    [self.protocalButton yzh_setEnlargeEdgeWithTop:15 right:10 bottom:15 left:15];
    
    self.backupButton.enabled = NO;
    [self.backupButton setBackgroundImage:[UIImage imageNamed:@"button_background_disable"] forState:UIControlStateDisabled];
    [self.backupButton setBackgroundImage:[UIImage imageNamed:@"button_background_optional"] forState:UIControlStateNormal];
    [self.backupButton yzh_setupButton];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)onTouchCheckout:(UIButton *)sender {
    
    if (!YZHIsString(self.secretKeyTextView.text)) {
        [YZHProgressHUD showText:@"请按正确格式输入密钥" onView:self.view];
    } else {
        NSDictionary* dic = @{
                              @"secretKey": self.secretKeyTextView.text
                              };
        
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_VERIFY_SECRETKEYFORMAT) params:dic successCompletion:^(id obj) {
            [hud hideWithText:@"您输入的是有效密钥"];
            
        } failureCompletion:^(NSError *error) {
            
            [hud hideWithText:error.domain];
        }];
    }
}

- (IBAction)onTouchProtocol:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    self.backupButton.enabled = sender.selected;
}

- (IBAction)onTouchBackup:(UIButton *)sender {

    if (!YZHIsString(self.secretKeyTextView.text)) {
        [YZHProgressHUD showText:@"请按正确格式输入密钥" onView:self.view];
    } else {
        NSDictionary* dic = @{
                              @"secretKey": self.secretKeyTextView.text
                              };
        
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_VERIFY_SECRETKEYFORMAT) params:dic successCompletion:^(id obj) {
            @strongify(self)
            [hud hideWithText:nil];
            self.navigationItem.title =  @"返回";
            [YZHRouter openURL:kYZHRouterBackupBindingPhone info:@{
                                                                   @"secretKey": self.secretKeyTextView.text
                                                                   }];
            
        } failureCompletion:^(NSError *error) {
            
            [hud hideWithText:error.domain];
        }];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
    
}

- (void)keyboardNotification {
    
//    @weakify(self)
//    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
//        @strongify(self)
//        if (isShowing) {
//            // TODO: 小屏时最好修改一下.
//            self.view.y = - 100;
//        } else {
//            self.view.y = 0;
//        }
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    }];
}

#pragma mark - 7.GET & SET

@end
