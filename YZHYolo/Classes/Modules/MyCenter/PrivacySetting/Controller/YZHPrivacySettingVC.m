//
//  YZHPrivacySettingVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivacySettingVC.h"
#import "YZHPrivacySettingModel.h"
#import "YZHPrivacySettingCell.h"
#import "YZHAboutYoloCell.h"

@interface YZHPrivacySettingVC ()<UITableViewDelegate, UITableViewDataSource, YZHPrivacyProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHPrivacySettingContent* viewModel;
@property (nonatomic, assign) NSTimeInterval lastClickTimer;

@end

@implementation YZHPrivacySettingVC

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

- (void)setupNavBar
{
    self.navigationItem.title = @"隐私设置";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    YZHPrivacySettingModel* settingModel = self.viewModel.content.firstObject;
    if (section == 0) {
        if (settingModel.isSelected == NO) {
            return 1;
        } else {
            return self.viewModel.content.count;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString* privacySettingCell = @"privacyCellIdentifier";
        YZHPrivacySettingCell* cell = [tableView dequeueReusableCellWithIdentifier:privacySettingCell];
        YZHPrivacySettingModel* model = self.viewModel.content[indexPath.row];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YZHPrivacySettingCell" owner:nil options:nil].lastObject;
            cell.titleLabel.text = model.title;
            cell.viewModel = self.viewModel;
        }
        cell.indexPath = indexPath;
        cell.subtitleLabel.text = model.subTitle;
        [cell.chooseSwitch setOn:model.isSelected];
        cell.delegate = self;
        return cell;
    } else {
        static NSString* aboutYoloCell = @"aboutYoloCell";
        YZHAboutYoloCell* cell = [tableView dequeueReusableCellWithIdentifier:aboutYoloCell];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YZHAboutYoloCell" owner:nil options:nil].lastObject;
            cell.titleLabel.text = @"设置上锁群阅读密码";
            cell.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kYZHCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        YZHPrivacySettingModel* model = self.viewModel.content[indexPath.row];
        model.isSelected = !model.isSelected;
        [self.tableView reloadData];
        [self updateUserPrivacySetting];
    } else {
        
    }
//    double timerInterval = 0;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm"];
//    if (self.lastClickTimer) {
//        NSDate *startDate = [dateFormatter dateFromString:NSTimeIntervalSince1970];
//        self.lastClickTimer =
//
//    } else {
//
//    }
}

- (void)selectedUISwitch:(UISwitch *)uiSwitch indexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

#pragma mark - 5.Event Response

- (void)updateUserPrivacySetting {
    
    //时间间隔.
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    YZHUserPrivateSettingModel* userSetting = userInfoExt.privateSetting;
    YZHPrivacySettingModel* addFirendModel = self.viewModel.content[0];
    YZHPrivacySettingModel* addVerifyModel = self.viewModel.content[1];
    YZHPrivacySettingModel* phoneAddModel = self.viewModel.content[2];
    userSetting.allowAdd = addFirendModel.isSelected;
    userSetting.allowPhoneAdd = phoneAddModel.isSelected;
    userSetting.addVerift = addVerifyModel.isSelected;
    
    NSString* userInfoExtString = [userInfoExt userInfoExtString];
    
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{
                                                       @(NIMUserInfoUpdateTagExt): userInfoExtString
                                                       } completion:^(NSError * _Nullable error) {
                                                           
                                                       }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (YZHPrivacySettingContent *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [YZHPrivacySettingContent sharePrivacySettingContent];
    }
    return _viewModel;
}

@end
