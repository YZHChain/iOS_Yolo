//
//  YZHTeamCardVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardVC.h"
#import "YZHTeamModel.h"
#import "YZHTeamCardModel.h"
#import "YZHTeamCardTextCell.h"
#import "YZHTeamCardHeaderView.h"
#import "YZHAddFirendRecordSectionHeader.h"
#import "UIButton+YZHTool.h"
#import "YZHPrivacySettingCell.h"
#import "YZHTeamCardSwitchCell.h"
#import "YZHProgressHUD.h"
#import "NIMContactDefines.h"
#import "NIMContactSelectConfig.h"
#import "YZHTeamMemberVC.h"
#import "YZHAlertManage.h"

static NSString* kYZHSectionIdentify = @"YZHAddFirendRecordSectionHeader";
@interface YZHTeamCardVC ()<UITableViewDataSource, UITableViewDelegate, YZHSwitchProtocol, NIMTeamManagerDelegate>

@property (nonatomic, strong) YZHTeamCardModel* viewModel;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHTeamCardHeaderView* headerView;
@property (nonatomic, strong) UITableViewHeaderFooterView* footerView;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, strong) NSDate* lastDate;
@property (nonatomic, assign) BOOL hasLastClick;
@property (nonatomic, assign) BOOL executeDelayUpdate;
@property (nonatomic, copy)   YZHVoidBlock headerTeamDataUpdataHandle;

@end

@implementation YZHTeamCardVC

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
    
    [[[NIMSDK sharedSDK] teamManager] addDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"群信息";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(YZHScreen_Width);
        make.width.mas_equalTo(YZHScreen_Height - 64);
    }];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.viewModel = [[YZHTeamCardModel alloc] initWithTeamId:_teamId isManage:_isTeamOwner];
    [self.headerView refreshWithModel:self.viewModel.headerModel];
    self.headerView.height = self.headerView.height;
//    self.tableView.tableHeaderView = self.headerView;
    [self.tableView setTableHeaderView:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.width.mas_equalTo(YZHScreen_Width);
        make.height.mas_equalTo(self.headerView.height);
    }];
    [self configurationFooterView];
    if (self.viewModel.isManage) {
        UIButton* headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headerView addSubview:headerButton];
        [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [headerButton addTarget:self action:@selector(onTouchHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.tableView reloadData];
}

- (void)refresh {
    
    if (self.viewModel.updateSucceed) {
        
    } else {
        self.viewModel = [[YZHTeamCardModel alloc] initWithTeamId:_teamId isManage:_isTeamOwner];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.headerView.height);
            }];
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.viewModel.modelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.modelList[section].count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHTeamDetailModel* model = self.viewModel.modelList[indexPath.section][indexPath.row];
    
    YZHTeamCardSwitchCell* cell = [tableView dequeueReusableCellWithIdentifier:model.cellClass forIndexPath:indexPath];
    [cell refreshWithModel:model];
    if ([model.cellClass isEqualToString:@"YZHTeamCardSwitchCell"]) {
        cell.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else if (section == 1 || section == self.viewModel.modelList.count - 2 || section == self.viewModel.modelList.count - 1) {
        return 30;
    } else {
        return 10;
    }
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddFirendRecordSectionHeader* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHSectionIdentify];
    if (section == 1) {
        headerView.dateLabel.text = @"群主设置";
    } else if (self.viewModel.modelList.count - 2 == section) {
        headerView.dateLabel.text = @"群功能";
    } else if (self.viewModel.modelList.count - 1 == section) {
        headerView.dateLabel.text = @"其他";
    } else {
        headerView.dateLabel.text = nil;
    }
    
    return headerView;
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
    YZHTeamDetailModel* model = self.viewModel.modelList[indexPath.section][indexPath.row];
    
    if ([model.title isEqualToString:@"群成员"]) {
        NIMContactTeamMemberSelectConfig *config = [[NIMContactTeamMemberSelectConfig alloc] init];
        config.enableRobot = NO;
        config.needMutiSelected = NO;
        config.teamId = self.teamId;
        config.filterIds = @[[NIMSDK sharedSDK].loginManager.currentAccount];
        NSString* teamManage = [[[NIMSDK sharedSDK] teamManager] teamById:config.teamId].owner;
        bool isManage = [config.filterIds.firstObject isEqual:teamManage];
        
        YZHTeamMemberVC* teamMemberVC = [[YZHTeamMemberVC alloc] initWithConfig:config withIsManage:isManage];
        [self.navigationController pushViewController:teamMemberVC animated:YES];
    } else if ([model.title isEqualToString:@"清空聊天记录"]) {
        @weakify(self)
        [YZHAlertManage showAlertTitle:@"确定要清空本群的聊天记录么?" message:@"此操作不可逆,请谨慎操作" actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
            @strongify(self)
            if (buttonIndex == 1) {
                NIMDeleteMessagesOption* option = [[NIMDeleteMessagesOption alloc] init];
                option.removeTable = NO;
                NIMSession *session = [NIMSession session:self.viewModel.teamId type:NIMSessionTypeTeam];
                [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:session option:option];
                [YZHProgressHUD showText:@"聊天记录已清除" onView:nil];
            }
        }];
    } else {
        [YZHRouter openURL:model.router info:model.routetInfo];
    }
}

- (void)selectedUISwitch:(UISwitch *)uiSwitch indexPath:(NSIndexPath *)indexPath {
    
    [self.tableView reloadData];
    if (!self.lastDate) {
        self.lastDate = [NSDate date];
        //无上一次点击事件记录,直接执行
        [self updateTeamSwitchSetting];
    } else {
        NSDate *end = [NSDate date];
        NSTimeInterval clickTimerInterval = [end timeIntervalSinceDate:self.lastDate];
        //计算点击间隔.如果数据连续点击,并且间隔在 5S 之内,则只会执行其最后一次操作.防止重复请求后台.
        if (clickTimerInterval <= 5.000000) {
            // 更新最后一次点击时间
            self.lastDate = [NSDate date];
            // 处理连续点击事件,最终只更新最后一次数据
            [self executeDelayUpdateLogic];
        } else {
            // 更新
            _lastDate = nil;
            //时间间隔超过5S,执行有效更新
            [self updateTeamSwitchSetting];
        }
    }
}

#pragma mark NIMTeamManagerDelegate

/**
 *  群组增加回调
 *
 *  @param team 添加的群组
 */
- (void)onTeamAdded:(NIMTeam *)team {
    
    if ([_teamId isEqualToString:team.teamId]) {
        [self refresh];
    }
}

/**
 *  群组更新回调
 *
 *  @param team 更新的群组
 */
- (void)onTeamUpdated:(NIMTeam *)team {
    
    if ([_teamId isEqualToString:team.teamId]) {
        [self refresh];
    }
}

/**
 *  群组移除回调
 *
 *  @param team 被移除的群组
 */
- (void)onTeamRemoved:(NIMTeam *)team {
    
    if ([_teamId isEqualToString:team.teamId]) {
        [self refresh];
    }
}

/**
 *  群组成员变动回调,包括数量增减以及成员属性变动
 *
 *  @param team 变动的群组
 */
- (void)onTeamMemberChanged:(NIMTeam *)team {
    
    if ([_teamId isEqualToString:team.teamId]) {
        [self refresh];
    }
}

#pragma mark - 5.Event Response

- (void)onTouchHeaderView:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterCommunityCardHeaderEdit info:@{
                                                                @"viewModel": self.viewModel.headerModel,
                                                                @"teamDataSaveSucceedBlock": self.headerTeamDataUpdataHandle
                                                                }];
}

- (void)removeTeam:(UIButton* )sender {
    
    //解散并退出社群
    @weakify(self)
    [YZHAlertManage showAlertTitle:@"确定要解散并删除本群么？" message:@"(您将失去所有群成员)\n\n 此操作不可逆,请谨慎操作" actionButtons:@[@"取消",@"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            @strongify(self)
            NIMDeleteMessagesOption* option = [[NIMDeleteMessagesOption alloc] init];
            option.removeTable = YES;
            option.removeSession = YES;
            NIMSession *session = [NIMSession session:self.viewModel.teamId type:NIMSessionTypeTeam];
            [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:session option:option];
            YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
            [[[NIMSDK sharedSDK] teamManager] dismissTeam:self.teamId completion:^(NSError * _Nullable error) {
                if (!error) {
                    @strongify(self)
                    [hud hideWithText:nil];
                    //通知后台
                    NSDictionary* dic = @{
                                          @"groupId": self.teamId
                                          };
                    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_TEAM_DELETEGROUP params:dic successCompletion:^(id obj) {
                        
                        
                    } failureCompletion:^(NSError *error) {
                        
                    }];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud hideWithText:@"网络异常,请重试"];
                }
            }];
        }
    }];
}

- (void)exitTeam:(UIButton* )sender {
    //删除并退出社群
    @weakify(self)
    [YZHAlertManage showAlertTitle:@"确定要退出群以及删除聊天记录么？" message:nil actionButtons:@[@"取消",@"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            @strongify(self)
            YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
            NIMDeleteMessagesOption* option = [[NIMDeleteMessagesOption alloc] init];
            option.removeTable = YES;
            option.removeSession = YES;
            NIMSession *session = [NIMSession session:self.viewModel.teamId type:NIMSessionTypeTeam];
            [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:session option:option];
            [[[NIMSDK sharedSDK] teamManager] quitTeam:self.teamId completion:^(NSError * _Nullable error) {
                if (!error) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud hideWithText:@"网络异常,请重试"];
                }
            }];
        }
    }];
}
// 处理延迟更新逻辑
- (void)executeDelayUpdateLogic {
    
    if (self.executeDelayUpdate) {
        //修改 Flag. 直到真正执行成功之后才算.
        self.executeDelayUpdate = NO;
        //延迟执行
        [self performSelector:@selector(delayUpdateTeamSwitchSetting) withObject:nil afterDelay:0.10000];
    } else {
        //取消掉上一次
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayUpdateTeamSwitchSetting) object:nil];
        //执行最后一次.
        [self performSelector:@selector(delayUpdateTeamSwitchSetting) withObject:nil afterDelay:0.10000];
    }
}

// 执行延迟更新
- (void)delayUpdateTeamSwitchSetting {
    NSLog(@"成功执行一次延后更新");
    //执行更新,修改标志.
    self.executeDelayUpdate = YES;
    
    [self updateTeamSwitchSetting];
}

- (void)updateTeamSwitchSetting {
    
    self.viewModel.updateSucceed = NO;
    //TODO: 需修改
    [self.viewModel updata];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        [_tableView registerNib:[UINib nibWithNibName:@"YZHMyCenterCell" bundle:nil] forCellReuseIdentifier: KCellIdentifier];
        _tableView.frame = CGRectMake(0, 0, YZHView_Width, YZHView_Height - 64);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = 50;
        [_tableView registerNib:[UINib nibWithNibName:@"YZHTeamCardImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YZHTeamCardImageCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHTeamCardTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YZHTeamCardTextCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHTeamCardSwitchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YZHTeamCardSwitchCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddFirendRecordSectionHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:kYZHSectionIdentify];
    }
    return _tableView;
}

- (YZHTeamCardHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardHeaderView" owner:nil options:nil].lastObject;
    }
    return _headerView;
}
//TODO:
- (YZHVoidBlock)headerTeamDataUpdataHandle {
    
    if (!_headerTeamDataUpdataHandle) {
        @weakify(self)
        _headerTeamDataUpdataHandle = ^(){
            @strongify(self)
            [self reloadView];
        };
    }
    return _headerTeamDataUpdataHandle;
}

- (void)configurationFooterView {
    
    _footerView = [[UITableViewHeaderFooterView alloc] init];
    self.tableView.tableFooterView = _footerView;
    _footerView.frame = CGRectMake(0, 0, self.tableView.width, 110);
    UIButton* removeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (self.viewModel.isManage) {
        [removeButton setTitle:@"解散群" forState:UIControlStateNormal];
    } else {
        [removeButton setTitle:@"删除并退出群聊" forState:UIControlStateNormal];
    }
    removeButton.layer.cornerRadius = 4;
    removeButton.layer.masksToBounds = YES;
    [removeButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:20]];
    [removeButton yzh_setBackgroundColor:[UIColor yzh_buttonBackgroundPinkRed] forState:UIControlStateNormal];
    [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.isTeamOwner) {
        [removeButton addTarget:self action:@selector(removeTeam:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [removeButton addTarget:self action:@selector(exitTeam:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self.footerView addSubview:removeButton];
    
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
        make.height.mas_equalTo(40);
    }];
}

@end
