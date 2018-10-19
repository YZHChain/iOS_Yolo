//
//  YZHModifyPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHModifyPasswordVC.h"

#import "YZHPublic.h"
@interface YZHModifyPasswordVC ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
@property (weak, nonatomic) IBOutlet UIButton *modifyTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *modifyTypeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *checkStatusImageView;
@property (weak, nonatomic) IBOutlet UIView *securityIndexView;
@property (weak, nonatomic) IBOutlet UILabel *securityIndexLable;

@end

@implementation YZHModifyPasswordVC

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
    self.navigationItem.title = @"修改密码";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.confirmButton.layer.cornerRadius = 4;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.enabled = NO;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
