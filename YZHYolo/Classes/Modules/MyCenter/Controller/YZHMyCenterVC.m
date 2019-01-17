//
//  YZHMyCenterVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyCenterVC.h"

#import "YZHMyCenterHeaderView.h"
#import "YZHMyCenterCell.h"
#import "UIScrollView+YZHRefresh.h"
#import "YZHMyCenterModel.h"
#import "YZHUserLoginManage.h"
#import "YZHUserDetailsModel.h"

static NSString* const kCellIdentifier = @"centerCellIdentifier";
@interface YZHMyCenterVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHMyCenterHeaderView* headerView;
@property (nonatomic, strong) YZHMyCenterListModel* viewModel;
@property (nonatomic, strong) YZHUserDetailsModel* userModel;

@end

@implementation YZHMyCenterVC

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
    //4.设置 NIM 委托
    [self setupNIMDelegate];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"我";
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    [self.view addSubview:self.tableView];
    //导航栏
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.headerView.userModel = self.userModel;
    [self.headerView yzh_addGradientLayerView];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
//    NSString* yolo_no = [YZHUserLoginManage sharedManager].currentLoginData.userId;
//    [[YZHNetworkService shareService] GETNetworkingResource:SERVER_YYLM_INTEGRAL(@"/balance") params:@{
//                                                                                                                                  @"userId":yolo_no ? yolo_no : @"",
//                                                                                                                                  } successCompletion:^(id obj) {
//
//                                                                                                                                      NSLog(@"成功咯");
//                                                                                                                                  } failureCompletion:^(NSError *error) {
//                                                  NSLog(@"成功咯");
//                                                                                                                                  }];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.viewModel.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.list[section].content.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHMyCenterModel* model = self.viewModel.list[indexPath.section].content[indexPath.row];
    YZHMyCenterCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZHMyCenterModel* model = self.viewModel.list[indexPath.section].content[indexPath.row];
    
    [YZHRouter openURL:model.route];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* tableViewHeaderView = [[UIView alloc] init];
    
    return tableViewHeaderView;
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


#pragma mark - 6. NIM delegate

- (void)setupNIMDelegate
{
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)onUserInfoChanged:(NIMUser *)user {

    if ([user.userId isEqualToString:[[[NIMSDK sharedSDK] loginManager] currentAccount]]) {
        [self userInformationUpdateUser:user];
    }
}
// 更新
- (void)userInformationUpdateUser:(NIMUser *)user {
    //TODO:回头来看有点别扭.....有时间优化下 Model
    self.userModel.userIMData = user;
    self.headerView.userModel = self.userModel;
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YZHView_Width, YZHView_Height - YZHTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHMyCenterCell" bundle:nil] forCellReuseIdentifier: kCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorColor = [UIColor yzh_tableViewSeparatorLightGray];
        [_tableView.tableHeaderView setUserInteractionEnabled:YES];
        
    }
    return _tableView;
}

- (YZHMyCenterHeaderView *)headerView{
    
    if (_headerView == nil) {
        
        _headerView = [YZHMyCenterHeaderView yzh_viewWithFrame:CGRectMake(0, 0, YZHView_Width, 150)];
        _headerView.executeHeaderBlock = ^(UIButton *sender) {
            [YZHRouter openURL:kYZHRouterMyInformation];
        };
        _headerView.executeQRCodeBlock = ^(UIButton *sender) {
            [YZHRouter openURL:kYZHRouterMyInformationMyQRCode];
        };
    }
    return _headerView;
}

- (YZHMyCenterListModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[YZHMyCenterListModel alloc] init];
    }
    return _viewModel;
}

- (YZHUserDetailsModel* )userModel {
    
    if (!_userModel) {
        NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
        _userModel = [[YZHUserDetailsModel alloc] init];
        _userModel.userIMData = user;
    }
    return _userModel;
}

@end
