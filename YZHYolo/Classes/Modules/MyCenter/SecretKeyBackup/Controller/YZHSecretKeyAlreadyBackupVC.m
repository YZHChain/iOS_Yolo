//
//  YZHSecretKeyAlreadyBackupVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHSecretKeyAlreadyBackupVC.h"

#import "UIButton+YZHTool.h"

@interface YZHSecretKeyAlreadyBackupVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneGetButton;
@property (weak, nonatomic) IBOutlet UIButton *changePhoneButton;

@end

@implementation YZHSecretKeyAlreadyBackupVC


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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"密钥已备份";
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"密钥已备份";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除备份" style:UIBarButtonItemStylePlain target:self action:@selector(delectBackup)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    
    self.subtitleLabel.textColor = [UIColor yzh_sessionCellGray];
    self.subtitleLabel.font = [UIFont yzh_commonStyleWithFontSize:12];
    
    [self.phoneGetButton yzh_setupButton];
    
    [self.changePhoneButton yzh_setupButton];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (void)delectBackup {
    
    self.navigationItem.title = @"取消";
    [YZHRouter openURL:kYZHRouterDelectBackup];
}

- (IBAction)onTouchPhoneGetSecretKey:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterPhoneGetSecretKey];
}

- (IBAction)changeBindingPhone:(id)sender {
    
    [YZHRouter openURL:kYZHRouterSecretKeyBackupVerify];
}



#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
