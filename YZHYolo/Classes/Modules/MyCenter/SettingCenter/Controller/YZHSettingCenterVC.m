//
//  YZHSettingCenterVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSettingCenterVC.h"

#import "YZHAboutYoloCell.h"
#import "YZHAlertManage.h"
#import "UIButton+YZHTool.h"
#import "YZHUserLoginManage.h"
#import "YZHUserDataManage.h"

static NSString* const kYZHCellPasswordTitle = @"修改密码";
static NSString* const kYZHCellChatLogTitle  = @"清空聊天记录";
static NSString* const kYZHEmptyLogAlertTitle = @"确认要清空全部聊天记录吗？";
static NSString* const kYZHEmptyLogAlertMessage = @"此操作不可逆,请谨慎操作";

@interface YZHSettingCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITableViewHeaderFooterView* footerView;
@property (nonatomic, strong) UIButton* logOutButton;

@end

@implementation YZHSettingCenterVC

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
    self.navigationItem.title = @"设置";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = kYZHCellHeight;
    
    self.tableView.tableFooterView = self.footerView;
    [self.tableView.tableFooterView addSubview:self.logOutButton];

    [_logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(240);
        make.centerX.mas_equalTo(self.tableView.tableFooterView);
        
    }];
    [self.tableView.tableFooterView layoutIfNeeded];
    [_logOutButton yzh_setBackgroundColor:[UIColor colorWithRed:204.0/ 255.0 green:208.0/ 255.0 blue:214.0/ 255.0 alpha:1] forState:UIControlStateNormal];
    
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHAboutYoloCell* cell = [[NSBundle mainBundle] loadNibNamed:@"YZHAboutYoloCell" owner:nil options:nil].lastObject;
    if (indexPath.row == 0) {
        cell.titleLabel.text = kYZHCellPasswordTitle;
    } else {
        cell.titleLabel.text = kYZHCellChatLogTitle;
    }
    
    cell.subtitleLabel.text = nil;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 7;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* view = [[UIView alloc] init];

    return view;
}

// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHAboutYoloCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.titleLabel.text isEqualToString:kYZHCellPasswordTitle]) {
        //TODO: 修改密码未做.
        [YZHRouter openURL:kYZHRouterModifyPassword];
    } else {
        [YZHAlertManage showAlertTitle:kYZHEmptyLogAlertTitle message:kYZHEmptyLogAlertMessage actionButtons:@[@"取消",@"确认"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //TODO: 执行删除聊天记录
                NIMDeleteMessagesOption* messageOption = [[NIMDeleteMessagesOption alloc] init];
                messageOption.removeTable = NO;
                messageOption.removeSession = NO;
                [[[NIMSDK sharedSDK] conversationManager] deleteAllMessages:messageOption];
            }
        }];
    }
}

#pragma mark - 5.Event Response

- (void)executeExitLogin {
//
    [YZHAlertManage showAlertTitle:@"确定要退出登录么？" message:nil actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
                if (!error) {
                    YZHUserLoginManage* manage = [YZHUserLoginManage sharedManager];
                    // 清空缓存用户信息
                    [manage setCurrentLoginData:nil];
                    //TODO:
                    // 跳转至登录页
                    [manage executeHandInputLogin];
                } else {
                    NSLog(@"退出异常原因:%@", error);
                    [YZHProgressHUD showText:@"退出失败,请重试" onView:self.view];
                }
            }];
        }
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableViewHeaderFooterView *)footerView {
    
    if (!_footerView) {
        _footerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, YZHView_Width, YZHView_Height - 117 - YZHNavigationStatusBarHeight)];
        _footerView.backgroundView = ({
            UIView * view = [[UIView alloc] initWithFrame:_footerView.bounds];
            view.backgroundColor = [UIColor yzh_backgroundThemeGray];
            view;
        });
        self.tableView.tableFooterView = _footerView;
    }
    return _footerView;
}

- (UIButton *)logOutButton {
    
    if (!_logOutButton) {
        UIButton* logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOutButton setBackgroundImage:[UIImage imageNamed:@"button_background_disable"] forState:UIControlStateNormal];
        _logOutButton = logOutButton;
        _logOutButton.layer.cornerRadius = 4;
        _logOutButton.layer.masksToBounds = YES;
        [logOutButton addTarget:self action:@selector(executeExitLogin) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _logOutButton;
}

@end

