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

static NSString* const kCellIdentifier = @"centerCellIdentifier";
@interface YZHMyCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)YZHMyCenterHeaderView* headerView;
@property(nonatomic, strong)YZHMyCenterListModel* viewModel;

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
    //4.设置通知
    [self setupNotification];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    [self setStatusBarBackgroundColor:[UIColor yzh_backgroundDarkBlue]];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"我的";
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    [[YZHNetworkService shareService] GETNetworkingResource:PATH_REGISTERED_MYCENTER params:nil successCompletion:^(id obj) {
        self.viewModel = [YZHMyCenterListModel YZH_objectWithKeyValues:obj];
        [self.tableView reloadData];
    } failureCompletion:^(NSError *error) {
        
    }];
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
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* tableViewHeaderView = [[UIView alloc] init];
    
    return tableViewHeaderView;
}
#pragma mark - 5.Event Response

- (void)clickTableViewHeader {
    [YZHRouter openURL:kYZHRouterMyInformation];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YZHVIEW_WIDTH, YZHVIEW_HEIGHT - YZHTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHMyCenterCell" bundle:nil] forCellReuseIdentifier: kCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 38, 0, 38);
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorColor = [UIColor yzh_separatorLightGray];
        [_tableView.tableHeaderView setUserInteractionEnabled:YES];
        
    }
    return _tableView;
}

- (YZHMyCenterHeaderView *)headerView{
    
    if (_headerView == nil) {
        
        _headerView = [YZHMyCenterHeaderView yzh_viewWithFrame:CGRectMake(0, 0, YZHVIEW_WIDTH, 170)];
        UIButton* btn = [[UIButton alloc] initWithFrame:_headerView.frame];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTableViewHeader) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
    }
    return _headerView;
}

@end
