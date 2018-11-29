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

@interface YZHTeamCardIntroVC()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHTeamCardHeaderView* headerView;
@property (nonatomic, strong) YZHTeamCardIntroModel* viewModel;
@property (nonatomic, strong) UITableViewHeaderFooterView* footerView;

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
    self.navigationItem.title = @"群信息";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchClose)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
//    self.tableView.frame = CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    
    [self.view addSubview:self.tableView];

}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {

    self.viewModel = [[YZHTeamCardIntroModel alloc] initWithTeamId:_teamId];
    
    [self.tableView setTableHeaderView:self.headerView];
    [self.headerView refreshWithModel:self.viewModel.headerModel];
    
    [self.tableView reloadData];
    [self configurationFooterView];
    
    self.tableView.tableFooterView = self.footerView;
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHTeamCardIntro* cell;
    
    cell.textLabel.text = @"群成员";
    if (indexPath.row == 0) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntro" owner:nil options:nil].firstObject;
        cell.titleLabel.text = @"群成员";
        cell.subtitleLabel.text = [NSString stringWithFormat:@"%ld人",self.viewModel.teamModel.memberNumber];
    } else {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntro" owner:nil options:nil].lastObject;
        cell.titleLabel.text = @"群主";
        cell.nameLabel.text = self.viewModel.teamOwnerName;
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
}

#pragma mark - 5.Event Response

- (void)onTouchClose{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTeam:(UIButton* )sender {
    
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    [[[NIMSDK sharedSDK] teamManager] addUsers:@[userId] toTeam:_teamId postscript:@"通过二维码申请入群" completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        if (!error) {
            [hud hideWithText:@"已成功加入社群"];
        } else {
            [hud hideWithText:@"申请入群失败,请重试"];
        }
    }];
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
    [addTeamButton setTitle:@"加入群聊" forState:UIControlStateNormal];
    addTeamButton.layer.cornerRadius = 4;
    addTeamButton.layer.masksToBounds = YES;
    [addTeamButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:20]];
    [addTeamButton yzh_setBackgroundColor:[UIColor yzh_buttonBackgroundPinkRed] forState:UIControlStateNormal];
    [addTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [addTeamButton addTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
//    [addTeamButton addTarget:self action:@selector(exitTeam:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:addTeamButton];
    
    [addTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
        make.height.mas_equalTo(40);
    }];
}

@end
