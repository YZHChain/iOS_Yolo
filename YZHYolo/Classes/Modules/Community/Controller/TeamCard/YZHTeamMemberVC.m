//
//  YZHTeamMemberVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberVC.h"

#import "YZHTeamMemberCell.h"
#import "YZHTeamMemberModel.h"
#import "UIButton+YZHTool.h"
#import "YZHTeamMemberManageVC.h"

@interface YZHTeamMemberVC()<UITableViewDataSource, UITableViewDelegate, NIMTeamManagerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHTeamMemberModel* viewModel;
@property (nonatomic, strong) UIImageView* teamOwnerIcon;

@end

@implementation YZHTeamMemberVC

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
    
    [self setupNimDelegate];
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

- (void)setupNimDelegate {
    
    [[[NIMSDK sharedSDK] teamManager] addDelegate:self];
}

- (void)dealloc {
    
    [[[NIMSDK sharedSDK] teamManager] removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"群成员";
    
    if (self.isManage) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理成员" style:UIBarButtonItemStylePlain target:self action:@selector(manageMember:)];
    }
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    
    UITableViewHeaderFooterView* footerView = [[UITableViewHeaderFooterView alloc] init];
    UIButton* inviteFirendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteFirendButton yzh_setupButton];
    [inviteFirendButton setTitle:@"添加好友进群" forState:UIControlStateNormal];
    [inviteFirendButton setBackgroundImage:[UIImage imageNamed:@"button_background_optional"] forState:UIControlStateNormal];
    [inviteFirendButton addTarget:self action:@selector(onTouchupInviteFirend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:footerView];
    [footerView addSubview:inviteFirendButton];
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    [inviteFirendButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self makeData];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.memberArray.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHTeamMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    YZHContactMemberModel* member = self.viewModel.memberArray[indexPath.row];
    
    if ([self.viewModel.teamOwner isEqualToString:member.info.infoId]) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamOwnerCell" owner:nil options:nil].lastObject;
    }
    cell.teamId = self.viewModel.teamId;
    [cell refresh:member];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZHContactMemberModel* member = self.viewModel.memberArray[indexPath.row];
    //跳转至群成员, 非好友时需要有临时会话功能
    //跳转用户资料.
    NSDictionary* info = @{
                           @"userId": member.info.infoId,
                           @"teamId": _teamId,
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

// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

#pragma mark - 5.Event Response

- (void)onTouchupInviteFirend:(UIButton *)sender {

    //邀请好友进群
    [YZHRouter openURL:kYZHRouterSessionSharedCard info:@{
                                                          @"sharedType": @(3),
                                                          kYZHRouteSegue: kYZHRouteSegueModal,
                                                          kYZHRouteSegueNewNavigation: @(YES),
                                                          @"teamId": self.teamId.length ? self.teamId : NULL
                                                          }];
}

- (void)manageMember:(UIBarButtonItem *)sender {
    
    NIMContactTeamMemberSelectConfig *config = [[NIMContactTeamMemberSelectConfig alloc] init];
    config.enableRobot = NO;
    config.needMutiSelected = NO;
    config.teamId = self.teamId;
    config.filterIds = @[[NIMSDK sharedSDK].loginManager.currentAccount];
    //跳转到管理群成员
    YZHTeamMemberManageVC* mamnageVC = [[YZHTeamMemberManageVC alloc] initWithConfig:config withIsManage:YES];
    [self.navigationController pushViewController:mamnageVC animated:mamnageVC];
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
    } containsSelf:YES ];
}

/**
 *  群组成员变动回调,包括数量增减以及成员属性变动
 *
 *  @param team 变动的群组
 */
- (void)onTeamMemberChanged:(NIMTeam *)team {
    
    if ([team.teamId isEqualToString:self.teamId]) {
        [self reloadView];
    }
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHTeamMemberCell" bundle:nil] forCellReuseIdentifier: kYZHCommonCellIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = 55;
    }
    return _tableView;
}

- (UIImageView *)teamOwnerIcon {
    
    if (!_teamOwnerIcon) {
        _teamOwnerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_teamDetails_teamOwner_icon"]];
    }
    return _teamOwnerIcon;
}

@end
