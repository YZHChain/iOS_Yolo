//
//  YZHSecretBackupCompletionVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHSecretBackupCompletionVC.h"

#import "UIButton+YZHTool.h"

@interface YZHSecretBackupCompletionVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;

@end

@implementation YZHSecretBackupCompletionVC


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
    self.navigationItem.title = @"备份完成";
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    
    self.subtitleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.subtitleLabel.font = [UIFont yzh_commonFontStyleFontSize:12];
    
    [self.completionButton yzh_setupButton];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)onTouchCompletion:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [YZHRouter openURL:kYZHRouterPrivacySetting];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
