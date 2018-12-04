//
//  YZHPrivacyReadPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivacyReadPasswordVC.h"

#import "YZHReadPasswordView.h"
#import "YZHProgressHUD.h"
#import "YZHUserLoginManage.h"
@interface YZHPrivacyReadPasswordVC ()

@property (nonatomic, strong) YZHReadPasswordView* passwrodView;

@property (nonatomic, assign) BOOL havaReadPassword;

@end

@implementation YZHPrivacyReadPasswordVC


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
    
    if (YZHIsString(self.userManage.privateSetting.groupPassword)) {
        self.havaReadPassword = YES;
    } else {
        self.havaReadPassword = NO;
    }
    if (self.havaReadPassword) {
       self.navigationItem.title = @"重置阅读密码";
    } else {
       self.navigationItem.title = @"设置阅读密码";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSava:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    if (self.havaReadPassword) {//已存在则重置
        self.passwrodView = [[NSBundle mainBundle] loadNibNamed:@"YZHReadPasswordView" owner:nil options:nil].lastObject;
    } else {
        //如果无则第一次设置.
        self.passwrodView = [[NSBundle mainBundle] loadNibNamed:@"YZHReadPasswordView" owner:nil options:nil].firstObject;
    }
    self.passwrodView.tipButton.hidden = YES;
    [self.view addSubview:self.passwrodView];
    [self.passwrodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (void)clickSava:(UIButton *)sender {
    
    if (self.havaReadPassword) {
        
        YZHIMLoginData* loginManage = [[YZHUserLoginManage sharedManager] currentLoginData];
        NSString* account = loginManage.userId;
        NSString* password = self.passwrodView.accountPasswordTextField.text;
        NSDictionary* dic = @{
                              @"account": account ? account : @"",
                              @"password": password ? password : @"",
                              };
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_LOGIN_LOGINVERIFY params:dic successCompletion:^(id obj) {
            @strongify(self)
            self.userManage.privateSetting.groupPassword = self.passwrodView.passwordTextField.text;
            NSString* userInfoExt = [self.userManage userInfoExtString];
            [[[NIMSDK sharedSDK] userManager] updateMyUserInfo:@{
                                                                 @(NIMUserInfoUpdateTagExt):userInfoExt
                                                                 } completion:^(NSError * _Nullable error) {
                                                                     @strongify(self)
                                                                     if (!error) {
                                                                         
                                                                         [hud hideWithText:@"重置阅读密码成功"];
                                                                         [self refreshViewStatus:NO];
                                                                         
                                                                     } else {
                                                                         [hud hideWithText:@"重置失败, 请稍后重试"];
                                                                         [self refreshViewStatus:NO];
                                                                     }
                                                                 }];
        } failureCompletion:^(NSError *error) {
            //TODO: 失败处理
            [hud hideWithText:error.domain];
        }];
    } else {
        self.userManage.privateSetting.groupPassword = self.passwrodView.passwordTextField.text;
        NSString* userInfoExt = [self.userManage userInfoExtString];
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
        @weakify(self)
        [[[NIMSDK sharedSDK] userManager] updateMyUserInfo:@{
                                                             @(NIMUserInfoUpdateTagExt):userInfoExt
                                                             } completion:^(NSError * _Nullable error) {
                                                                 @strongify(self)
                                                                 if (!error) {
                                                                     
                                                                     [hud hideWithText:@"设置阅读密码成功"];
                                                                     [self refreshViewStatus:NO];
                                                                 
                                                                 } else {
                                                                     [hud hideWithText:@"设置失败, 请稍后重试"];
                                                                     [self refreshViewStatus:NO];
                                                                 }
                                                             }];
        
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldEditChanged:(NSNotification* )notification{
    
    NSString* readPassword = self.passwrodView.passwordTextField.text;
    NSString* readConfirmPassword = self.passwrodView.confirmPasswordTextField.text;
    if (self.havaReadPassword) {
        NSString* accountPassword = self.passwrodView.accountPasswordTextField.text;
        if (YZHIsString(accountPassword)) {
            if (YZHIsString(readPassword) && YZHIsString(readConfirmPassword)) {
                if ([readPassword isEqualToString:readConfirmPassword]) {
                    [self refreshViewStatus:YES];
                } else {
                    [self refreshViewStatus:NO];
                }
            } else {
                [self refreshViewStatus:NO];
            }
        } else {
            [self refreshViewStatus:NO];
        }
    } else {
        
        if (YZHIsString(readPassword) && YZHIsString(readConfirmPassword)) {
            if ([readPassword isEqualToString:readConfirmPassword]) {
                [self refreshViewStatus:YES];
            } else {
                [self refreshViewStatus:NO];
            }
        } else {
            [self refreshViewStatus:NO];
        }
    }
}

- (void)refreshViewStatus:(BOOL)status {
    
    if (status) {
        self.passwrodView.tipButton.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.passwrodView.tipButton.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - 7.GET & SET

@end
