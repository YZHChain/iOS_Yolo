//
//  YZHDeleteBackupVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHDeleteBackupVC.h"

#import "YZHPublic.h"
#import "UIButton+YZHTool.h"
#import "YZHUserLoginManage.h"

@interface YZHDeleteBackupVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *delectButton;


@end

@implementation YZHDeleteBackupVC


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
    
    self.navigationItem.title = @"密钥已备份";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.titleLabel.font = [UIFont yzh_commonFontStyleFontSize:15];
    
    [self.delectButton yzh_setupButton];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)delectBackup:(id)sender {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    
    NSString* yoloNo = [YZHUserLoginManage sharedManager].currentLoginData.yoloId;
    NSDictionary* dic = @{
                          @"yoloNo": yoloNo ? yoloNo : @""
                          };
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_USER_DELECT_BACKUPSECRETKEY) params:dic successCompletion:^(id obj) {
        
        [hud hideWithText:@"密钥信息已删除" completion:^{
            [YZHRouter openURL:kYZHRouterPrivacySetting info:@{
                                                               kYZHRouteBackIndex: @(3)
                                                               }];
        }];
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

- (void)onTouchCancel {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
