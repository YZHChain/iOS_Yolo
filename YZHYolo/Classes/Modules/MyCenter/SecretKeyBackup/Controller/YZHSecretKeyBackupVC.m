//
//  YZHSecretKeyBackupVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/10.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHSecretKeyBackupVC.h"

#import "UIButton+YZHTool.h"
#import "UIButton+YZHClickHandle.h"

@interface YZHSecretKeyBackupVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *protocalTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *protocalButton;
@property (weak, nonatomic) IBOutlet UIButton *backupButton;

@end

@implementation YZHSecretKeyBackupVC


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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"备份密钥";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.titleLabel.font = [UIFont yzh_commonFontStyleFontSize:18];
    
    self.contentLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.contentLabel.font = [UIFont yzh_commonFontStyleFontSize:15];

    self.subtitleLabel.textColor = [UIColor yzh_separatorLightGray];
    self.subtitleLabel.font = [UIFont yzh_commonFontStyleFontSize:15];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:@"密钥委托备份协议"];
    NSRange titleRange = NSMakeRange(0, attributedString.length);
    [attributedString addAttributes:@{
                                      NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                      NSFontAttributeName: [UIFont yzh_commonStyleWithFontSize:12]
                                      } range:titleRange];
    self.protocalTitleButton.titleLabel.attributedText = attributedString;
    
    
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

- (IBAction)onTouchProtocol:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    self.backupButton.enabled = sender.selected;
}

- (IBAction)onTouchBackup:(UIButton *)sender {
    
    self.navigationItem.title = @"返回";
    [YZHRouter openURL:kYZHRouterSecretKeyBackupVerify];
}

- (IBAction)onTouchProtocalTitle:(id)sender {
    
    [YZHRouter openURL:kYZHRouterWKWeb info:@{
                                              @"navTitle": @"注册协议",
                                              @"url":@"https://yolotest.yzhchain.com/yolo-web/html/about/backup_protocol.html"
                                              }];
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
