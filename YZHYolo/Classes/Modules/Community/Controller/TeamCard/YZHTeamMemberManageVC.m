//
//  YZHTeamMemberManageVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberManageVC.h"

#import "YZHTeamMemberManageCell.h"
#import "YZHAlertManage.h"
#import "YZHProgressHUD.h"
#import "YZHPublic.h"

@interface YZHTeamMemberManageVC()<UITableViewDelegate, UITableViewDataSource, YZHTeamMemberManageProtocol, NIMTeamManagerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* allBannedButton;
@property (nonatomic, assign) BOOL isAllBanned;
@property (nonatomic, strong) YZHTeamMemberModel* viewModel;

@end

@implementation YZHTeamMemberManageVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithConfig:(id<NIMContactSelectConfig>)config withIsManage:(BOOL)isManage {
    
    self = [super init];
    if (self) {
        _config = config;
        _isManage = isManage;
        _teamId = config.teamId;
        _viewModel = [[YZHTeamMemberModel alloc] init];
        [self makeData];
    }
    return self;
}

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
    
    [[[NIMSDK sharedSDK] teamManager] addDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[[NIMSDK sharedSDK] teamManager] removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"设置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭管理" style:UIBarButtonItemStylePlain target:self action:@selector(closeManage:)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHTeamMemberManageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kYZHCommonCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.rowHeight = 50;
    
    [self.view addSubview:self.tableView];
    
    UITableViewHeaderFooterView* footerView = [[UITableViewHeaderFooterView alloc] init];
    UIButton* allBannedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBannedButton setTitle:@"全体禁言" forState:UIControlStateNormal];
    [allBannedButton setTitle:@"全体解禁" forState:UIControlStateSelected];
    [allBannedButton yzh_setupButton];
    [allBannedButton setBackgroundImage:[UIImage imageNamed:@"button_background_optional"] forState:UIControlStateNormal];
    [allBannedButton addTarget:self action:@selector(onTouchupAllBanned:) forControlEvents:UIControlEventTouchUpInside];
    self.allBannedButton = allBannedButton;
    
    [self.view addSubview:footerView];
    [footerView addSubview:allBannedButton];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    [allBannedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(68);
        make.right.mas_equalTo(-68);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(footerView.mas_top).mas_equalTo(0);
    }];
    
    footerView.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:footerView.bounds];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
}

- (void)reloadView {
    
    [self setupView];
    [self makeData];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    
    self.isAllBanned = [[[NIMSDK sharedSDK] teamManager] teamById:self.viewModel.teamId].inAllMuteMode;
    self.allBannedButton.selected = self.isAllBanned;
    
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.memberArray.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHContactMemberModel* member = self.viewModel.memberArray[indexPath.row];
    YZHTeamMemberManageCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    [cell refresh:member];
    BOOL isBanned = [[[NIMSDK sharedSDK] teamManager] teamMember:member.info.infoId inTeam:self.viewModel.teamId].isMuted;
    NSLog(@"成员名%@ iD:%@禁言状态%d", member.info.showName, member.info.infoId, isBanned);
    cell.bannedButton.selected = isBanned;
//    if (isBanned) {
//        cell.bannedButton.titleLabel.text = @"解除禁言";
//    } else {
//        cell.bannedButton.titleLabel.text = @"禁言";
//    }
    cell.delegete = self;
    
    return cell;
}

// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZHContactMemberModel* member = self.viewModel.memberArray[indexPath.row];
    //跳转用户资料.
    NSDictionary* info = @{
                           @"userId": member.info.infoId,
                           @"teamId": self.viewModel.teamId,
                           };
    if ([member.info.infoId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        //跳转用户资料.
        NSDictionary* info = @{
                               @"userId": member.info.infoId,
                               };
        //这里要到我们的用户详情页里
        [YZHRouter openURL:kYZHRouterAddressBookDetails info:info];
    } else {
        [YZHRouter openURL:kYZHRouterTeamMemberBookDetails info:info];
    }
}
// 禁言和移出群按钮回调;
- (void)onTouchBannedWithMember:(nonnull YZHContactMemberModel *)member {
    
    BOOL isBanned = [[[NIMSDK sharedSDK] teamManager] teamMember:member.info.infoId inTeam:self.viewModel.teamId].isMuted;
    
    NSString* title;
    NSString* succeedTitle;
    if (isBanned) {
        title = [NSString stringWithFormat:@"确定要对用户: (%@) 解除禁言么?", member.info.showName];
    } else {
        title = [NSString stringWithFormat:@"确定要对用户: (%@) 禁言么?", member.info.showName];
    }
    if (isBanned) {
        succeedTitle = [NSString stringWithFormat:@"已解除用户: (%@) 禁言", member.info.showName];
    } else {
        succeedTitle = [NSString stringWithFormat:@"已对用户: (%@) 禁言", member.info.showName];
    }
    [YZHAlertManage showAlertTitle:nil message:title actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
            @weakify(self)
            [[[NIMSDK sharedSDK] teamManager] updateMuteState:!isBanned userId:member.info.infoId inTeam:self.viewModel.teamId completion:^(NSError * _Nullable error) {
                if (!error) {
                    @strongify(self)
                    [hud hideWithText:succeedTitle];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                } else {
                    [hud hideWithText:@"网络异常, 请重试"];
                }
            }];
        }
    }];
}

- (void)onTouchKickOutWithMember:(nonnull YZHContactMemberModel *)member {

    [YZHAlertManage showAlertTitle:nil message:[NSString stringWithFormat:@"确定要把用户: (%@) 踢出群么?", member.info.showName] actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //执行移出群操作
            @weakify(self)
            YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
            [[[NIMSDK sharedSDK] teamManager] kickUsers:@[member.info.infoId] fromTeam:self.viewModel.teamId completion:^(NSError * _Nullable error) {
                @strongify(self)
                if (!error) {
                    [hud hideWithText:[NSString stringWithFormat:@"已将用户: (%@) 移出群聊", member.info.showName]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                } else {
                    [hud hideWithText:@"网络异常, 请重试"];
                }
            }];
        }
    }];
}

#pragma mark - 5.Event Response

- (void)closeManage:(UIBarButtonItem *)sender {
    
    //TODO:关闭管理跳转到哪？
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTouchupAllBanned:(UIButton *)sender {
   // 全体成员禁言
    NSString* title;
    if (self.isAllBanned) {
        title = [NSString stringWithFormat:@"确定要解除全员禁言么?"];
    } else {
        title = [NSString stringWithFormat:@"确定要对全员禁言么?"];
    }
    [YZHAlertManage showAlertTitle:nil message:title actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
            @weakify(self)
            [[[NIMSDK sharedSDK] teamManager] updateMuteState:!self.isAllBanned inTeam:self.viewModel.teamId completion:^(NSError * _Nullable error) {
                if (!error) {
                    @strongify(self)
                    [hud hideWithText:@"已对全体成员禁言"];
                    self.isAllBanned = !self.isAllBanned;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.allBannedButton.selected = self.isAllBanned;
                        [self.tableView reloadData];
                    });
                } else {
                    [hud hideWithText:@"网络异常, 请重试"];
                }
            }];
        }
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)makeData {
    
    @weakify(self)
    [self.config getTeamMemberData:^(YZHTeamMemberModel *teamMemberModel) {
        @strongify(self)
        self.viewModel = teamMemberModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } containsSelf:NO];
}

- (void)onTeamAdded:(NIMTeam *)team {
    
    
}

/**
 *  群组更新回调
 *
 *  @param team 更新的群组
 */
- (void)onTeamUpdated:(NIMTeam *)team {
    
}

/**
 *  群组移除回调
 *
 *  @param team 被移除的群组
 */
- (void)onTeamRemoved:(NIMTeam *)team {
    
}

/**
 *  群组成员变动回调,包括数量增减以及成员属性变动
 *
 *  @param team 变动的群组
 */
- (void)onTeamMemberChanged:(NIMTeam *)team {
    
    if ([self.viewModel.teamId isEqualToString:team.teamId]) {
        [self reloadView];
    }
}

#pragma mark - 7.GET & SET

@end
