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
    
    [self.headerView refreshWithModel:self.viewModel.headerModel];
    [self.tableView setTableHeaderView:self.headerView];
    
    [self configurationFooterView];
    [self.tableView reloadData];
    
    self.tableView.tableFooterView = self.footerView;
    
    //非好友关系时, 拉取用户最新资料.
    if (![[[NIMSDK sharedSDK] userManager] isMyFriend:self.viewModel.teamOwner] && YZHIsString(self.viewModel.teamOwner)) {
        [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[self.viewModel.teamOwner] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (!error) {
                [self.viewModel updataTeamOwnerData];
                [self.tableView reloadData];
            }
        }];
    }
    //不是自己的群时, 需更新.
    if (![[[NIMSDK sharedSDK] teamManager] isMyTeam:self.viewModel.teamId]) {
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:self.viewModel.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            if (!error) {
                [self.viewModel updataHeaderModel];
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
            [hud hideWithText:@"申请入群失败"];
        }
        
    }];
}

- (void)gotoTeam:(UIButton* )sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
//    //销毁掉前面所有控制器.
//    UITabBarController* topViewController = (UITabBarController *)[UIViewController yzh_rootViewController];
//    [topViewController setSelectedIndex:0];
//    UINavigationController* communityNav = topViewController.viewControllers.firstObject;
//    NIMSession* teamSession = [NIMSession session:self.teamId type:NIMSessionTypeTeam];
//    YZHCommunityChatVC* teamVC = [[YZHCommunityChatVC alloc] initWithSession:teamSession];
//    [communityNav pushViewController:teamVC animated:YES];

      NIMSession* teamSession = [NIMSession session:self.teamId type:NIMSessionTypeTeam];
      YZHCommunityChatVC* teamVC = [[YZHCommunityChatVC alloc] initWithSession:teamSession];
      [self.navigationController pushViewController:teamVC animated:YES];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (YZHTeamCardHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardHeaderView" owner:nil options:nil].lastObject;
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
    [addTeamButton yzh_setBackgroundColor:[UIColor yzh_buttonBackgroundPinkRed] forState:UIControlStateNormal];
    [addTeamButton yzh_setBackgroundColor:[UIColor yzh_separatorLightGray] forState:UIControlStateDisabled];
    [addTeamButton setTitle:@"加入群聊" forState:UIControlStateNormal];
    //TODO: 有空看下云信,查找社群时,是否会返回相应错误参数,包含找不到此群还是此群已解散等信息。
    [addTeamButton setTitle:@"未找到该群" forState:UIControlStateDisabled];
    [addTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.addTeamButton = addTeamButton;
    if (self.viewModel.haveTeamData) {
        [addTeamButton addTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.tableView.tableHeaderView removeFromSuperview];
        if (self.viewModel.error.code == 803) {
            [addTeamButton setTitle:@"该群已解散" forState:UIControlStateNormal];
        } else {
            [addTeamButton setTitle:@"未找到该群" forState:UIControlStateNormal];
        }
        addTeamButton.enabled = NO;
    }
    [self.footerView addSubview:addTeamButton];
    
    [addTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
        make.height.mas_equalTo(40);
    }];
}

@end
