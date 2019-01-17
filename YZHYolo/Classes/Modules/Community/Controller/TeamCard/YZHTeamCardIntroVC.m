//
//  YZHTeamCardIntroVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardIntroVC.h"

#import "YZHTeamCardTextCell.h"
#import "YZHTeamCardHeaderView.h"
#import "YZHTeamCardIntroModel.h"
#import "UIButton+YZHTool.h"
#import "YZHProgressHUD.h"
#import "YZHTeamCardIntro.h"
#import "UIImageView+YZHImage.h"
#import "YZHCommunityChatVC.h"
#import "UIViewController+YZHTool.h"
#import "YZHCommunityListVC.h"
#import "YZHRootTabBarViewController.h"
#import "YZHTeamExtManage.h"
#import "YZHUserModelManage.h"

@interface YZHTeamCardIntroVC()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHTeamCardHeaderView* headerView;
@property (nonatomic, strong) YZHTeamCardIntroModel* viewModel;
@property (nonatomic, strong) UITableViewHeaderFooterView* footerView;
@property (nonatomic, strong) UIButton* addTeamButton;

@end

@implementation YZHTeamCardIntroVC
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
    self.navigationItem.title = @"群详情";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchClose)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

}

- (void)reloadView {
    
    [self.headerView refreshIntroWithModel:self.viewModel.headerModel];
    self.headerView.frame = CGRectMake(0, 0, self.tableView.width, self.headerView.updateHeight);
    [self.tableView setTableHeaderView:self.headerView];
    
    [self configurationFooterView];
    [self.tableView reloadData];
    
    self.tableView.tableFooterView = self.footerView;

    //非好友关系时, 拉取用户最新资料.
    if (![[[NIMSDK sharedSDK] userManager] isMyFriend:self.viewModel.teamOwner] && YZHIsString(self.viewModel.teamOwner)) {
        [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[self.viewModel.teamOwner] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (!error) {
                [self.viewModel updataTeamOwnerData:users.firstObject];
                [self.tableView reloadData];
            }
        }];
    }

    //不是自己的群时, 需更新.
    if (![[[NIMSDK sharedSDK] teamManager] isMyTeam:self.viewModel.teamId]) {
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:self.viewModel.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            if (!error) {
                [self.viewModel updataHeaderModel:team];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - 3.Request Data

- (void)setupData {

    if (![[[NIMSDK sharedSDK] teamManager] isMyTeam:self.teamId]) {
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:self.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
             [hud hideWithText:nil];
             //如果请求失败,或者找不到此群,或者此群解散,按这个逻辑处理,默认都是展示此群已解散。
            
             self.viewModel = [[YZHTeamCardIntroModel alloc] initWithTeam:team];
             if (error) {
                 self.viewModel.error = error;
             }
             [self reloadView];
        }];
    } else {
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId];
        self.viewModel = [[YZHTeamCardIntroModel alloc] initWithTeam:team];
        [self reloadView];
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.haveTeamData ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2; //暂时写死
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHTeamCardIntro* cell;
    
    cell.textLabel.text = @"群成员";
    if (indexPath.row == 0) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntro" owner:nil options:nil].firstObject;
        cell.titleLabel.text = @"群成员";
        cell.subtitleLabel.text = [NSString stringWithFormat:@"%ld人",self.viewModel.team.memberNumber];
    } else {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntro" owner:nil options:nil].lastObject;
        cell.titleLabel.text = @"群主";
        cell.nameLabel.text = self.viewModel.teamOwnerName;
        if (YZHIsString(self.viewModel.teamOwnerAvatarUrl)) {
            [cell.avatarImageView yzh_setImageWithString:self.viewModel.teamOwnerAvatarUrl placeholder:@"addBook_cover_cell_photo_default"];
        } else {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"addBook_cover_cell_photo_default"]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (YZHIsString(self.viewModel.teamOwner)) {
            NSDictionary* info = @{
                                   @"userId": self.viewModel.teamOwner
                                   };
            [YZHRouter openURL:kYZHRouterAddressBookDetails info: info];
        }
    }
}

#pragma mark - 5.Event Response

- (void)onTouchClose{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)addTeam:(UIButton* )sender {
    
    // 添加入群附言.
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] teamManager] applyToTeam:self.teamId message:@"" completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
        if (!error) {
            [hud hideWithText:@"已成功加入群聊"];
            @strongify(self)
            [self.addTeamButton setTitle:@"进入群聊" forState:UIControlStateNormal];
            [self.addTeamButton removeTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
            [self.addTeamButton addTarget:self action:@selector(gotoTeam:) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            if (error.code == 801) {
                [hud hideWithText:@"群人数达到上限"];
            } else {
                [hud hideWithText:@"申请入群失败"];
            }
        }
        
    }];
}

- (void)gotoTeam:(UIButton* )sender {

    NIMSession* teamSession = [NIMSession session:self.teamId type:NIMSessionTypeTeam];
    
    YZHRootTabBarViewController* rootTabBarVC = [YZHRootTabBarViewController instance];
    UINavigationController* navigationVC = rootTabBarVC.viewControllers.firstObject;
    YZHCommunityListVC* teamListVC = navigationVC.viewControllers.firstObject;
    if (teamListVC.teamLock) {
        
        YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:self.teamId];
        if (teamExt.team_lock) {
            [self clickLockTeamSession:teamSession];
        } else {
            [self gotoTeamSession:teamSession];
        }
    } else {
        [self gotoTeamSession:teamSession];
    }
}

//TODO: 封装到工具类
- (void)clickLockTeamSession:(NIMSession *)session {
    
    //设置群锁
    YZHRootTabBarViewController* tabBarVC = [YZHRootTabBarViewController instance];
    UINavigationController* navigationVC = tabBarVC.viewControllers.firstObject;
    YZHCommunityListVC* communityVC = navigationVC.viewControllers.firstObject;
    @weakify(self)
    [YZHAlertManage showTextAlertTitle:@"输入阅读密码解锁查看" message:nil textFieldPlaceholder:nil  actionButtons:@[@"取消", @"确认"] actionHandler:^(UIAlertController *alertController, UITextField *textField, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            @strongify(self)
            YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
            if (YZHIsString(textField.text)) {
                if ([textField.text isEqual:userInfoExt.privateSetting.groupPassword]) {
                    communityVC.teamLock = NO;
                    [self gotoTeamSession:session];
                    [communityVC refresh];
                    
                } else {
                    [YZHAlertManage showAlertMessage:@"阅读密码不正确, 请重新输入"];
                }
            } else {
                if (YZHIsString(userInfoExt.privateSetting.groupPassword)) {
                    [YZHAlertManage showAlertMessage:@"阅读密码不正确, 请重新输入"];
                } else {
                    communityVC.teamLock = NO;
                    [self gotoTeamSession:session];
                    [communityVC refresh];
                }
            }
        }
    }];
}

- (void)gotoTeamSession:(NIMSession *)session {
    
    //查找最近回话, 如果没有则直接使用, 会话进入聊天窗。 并且插入一条最近会话。
    NIMRecentSession* recentSession = [[[NIMSDK sharedSDK] conversationManager] recentSessionBySession:session];
    if (recentSession) {
        YZHCommunityChatVC* teamchatVC = [[YZHCommunityChatVC alloc] initWitRecentSession:recentSession];
        [self.navigationController pushViewController:teamchatVC animated:YES];
    } else {
        YZHCommunityChatVC* teamchatVC = [[YZHCommunityChatVC alloc] initWithSession:session];
        [self.navigationController pushViewController:teamchatVC animated:YES];
        
        NIMImportedRecentSession *recentSession = [[NIMImportedRecentSession alloc] init];
        recentSession.session = session;
        [[[NIMSDK sharedSDK] conversationManager] allRecentSessions];
        [[[NIMSDK sharedSDK] conversationManager] importRecentSessions:@[recentSession] completion:^(NSError * _Nullable error, NSArray<NIMImportedRecentSession *> * _Nullable failedImportedRecentSessions) {
            NSLog(@"插入会话结果%@", error);
        }];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (YZHTeamCardHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntroHeaderView" owner:nil options:nil].lastObject;
        _headerView.autoresizingMask = NO;
        
    }
    return _headerView;
}

- (void)configurationFooterView {
    
    _footerView = [[UITableViewHeaderFooterView alloc] init];
    self.tableView.tableFooterView = _footerView;
    _footerView.frame = CGRectMake(0, 0, self.tableView.width, 110);
    UIButton* addTeamButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addTeamButton.layer.cornerRadius = 4;
    addTeamButton.layer.masksToBounds = YES;
    [addTeamButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:20]];
    [addTeamButton setBackgroundImage:[UIImage imageNamed:@"button_background_optional"] forState:UIControlStateNormal];
    [addTeamButton setBackgroundImage:[UIImage imageNamed:@"button_background_disable"] forState:UIControlStateDisabled];
    [addTeamButton setTitle:@"加入群聊" forState:UIControlStateNormal];
    //TODO: 有空看下云信,查找社群时,是否会返回相应错误参数,包含找不到此群还是此群已解散等信息。
    [addTeamButton setTitle:@"未找到该群" forState:UIControlStateDisabled];
    [addTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.addTeamButton = addTeamButton;
    if (self.viewModel.haveTeamData) {
        if (self.viewModel.team.joinMode == NIMTeamJoinModeNoAuth) {
            [addTeamButton addTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [addTeamButton setTitle:@"该群非公开" forState:UIControlStateDisabled];
            addTeamButton.enabled = NO;
        }
    } else {
        [self.tableView.tableHeaderView removeFromSuperview];
        if (self.viewModel.error.code == 803) {
            [addTeamButton setTitle:@"未找到该群" forState:UIControlStateNormal];
        } else {
            [addTeamButton setTitle:@"未找到该群" forState:UIControlStateNormal];
        }
        addTeamButton.enabled = NO;
    }
    // 判断如果处于本群群成员则,
    if ([[[NIMSDK sharedSDK] teamManager] isMyTeam:self.teamId]) {
        [self.addTeamButton setTitle:@"进入群聊" forState:UIControlStateNormal];
        [self.addTeamButton removeTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
        [self.addTeamButton addTarget:self action:@selector(gotoTeam:) forControlEvents:UIControlEventTouchUpInside];
        self.addTeamButton.enabled = YES;
    }
    
    _footerView.backgroundColor = [UIColor clearColor];
    _footerView.backgroundView = ({
        UIView* view = [[UIView alloc] initWithFrame:_footerView.bounds];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
    [self.footerView addSubview:addTeamButton];
    
    [addTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
        make.height.mas_equalTo(40);
    }];
}

@end
