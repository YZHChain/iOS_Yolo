//
//  YZHDetailsSettingVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/30.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHDetailsSettingVC.h"

#import "YZHDetailsSettingCell.h"
#import "UIButton+YZHTool.h"
#import "UIImage+YZHTool.h"
#import "YZHAlertManage.h"

@interface YZHDetailsSettingVC ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *chatLogButton;

@end

@implementation YZHDetailsSettingVC

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
    self.navigationItem.title = @"其他设置";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.removeButton setBackgroundImage:[UIImage yzh_getImageWithColor:YZHColorWithRGB(227, 41, 63)] forState:UIControlStateNormal];
    self.removeButton.layer.cornerRadius = 5;
    self.removeButton.layer.masksToBounds = YES;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHDetailsSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"detailsSettingCellIdentity" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 5.Event Response

- (IBAction)trashliChatLog:(UIButton *)sender {
    
    [YZHAlertManage showAlertTitle:@"确定要清空所有社群的聊天记录么？" message:@"此操作不可逆，请谨慎操作" actionButtons:@[@"取消",@"确认"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {

    }];
}

- (IBAction)deleteFriend:(UIButton *)sender {
    
    [YZHAlertManage showAlertTitle:@"删除该好友，并清空与TA的聊天记录" message:nil actionButtons:@[@"取消", @"删除"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {

    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
