//
//  YZHAddBookAddFirendVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendVC.h"

#import "YZHAddBookAddFirendCell.h"
#import "YZHAddBookFirendModel.h"
#import "JKRSearchController.h"
#import "YZHAddFirendSearchVC.h"
#import "YZHPublic.h"
#import "YZHSearchView.h"

static NSString* const kaddFirendCellIdentifier = @"addFirendCellIdentifier";
@interface YZHAddBookAddFirendVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHFirendContentModel* model;
@property (nonatomic, strong) JKRSearchController* searchController;
@property (nonatomic, weak) YZHAddFirendSearchVC* searchResultVC;
@property (nonatomic, strong) YZHSearchView* searchView;

@end

@implementation YZHAddBookAddFirendVC

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
    self.navigationItem.title = @"添加好友";
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:self.searchView];
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
//    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.list.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddBookAddFirendCell* cell = [tableView dequeueReusableCellWithIdentifier:kaddFirendCellIdentifier forIndexPath:indexPath];
    YZHAddBookFirendModel* firendModel = self.model.list[indexPath.row];
    cell.model = firendModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}
// 添加分段尾,为了隐藏最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHAddBookFirendModel* model = self.model.list[indexPath.row];
//    if (indexPath.row == 1) {
//        [YZHRouter openURL:model.route info:@{kYZHRouteSegue: kYZHRouteSegueModal ,kYZHRouteSegueNewNavigation : @(YES)}];
//    } else {
//        [YZHRouter openURL:model.route];
//    }
    if ([model.title isEqualToString:@"扫一扫"]) {
        [YZHRouter openURL:model.route info:@{kYZHRouteSegue: kYZHRouteSegueModal ,kYZHRouteSegueNewNavigation : @(YES)}];
    } else if ([model.title isEqualToString:@"搜索进群"]) {
        [YZHRouter openURL:model.route info:@{kYZHRouteSegue: kYZHRouteSegueModal ,kYZHRouteSegueNewNavigation : @(YES)}];
    } else {
        [YZHRouter openURL:model.route];
    }
}

#pragma mark - 5.Event Response

- (void)onTouchSearch:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirendSearch info:@{kYZHRouteSegue: kYZHRouteSegueModal ,kYZHRouteSegueNewNavigation : @(YES)}];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}


#pragma mark - 7.GET & SET

- (YZHFirendContentModel *)model {
    
    if (_model == nil) {
        _model = [[YZHFirendContentModel alloc] init];
    }
    return _model;
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookAddFirendCell" bundle:nil] forCellReuseIdentifier:kaddFirendCellIdentifier];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = kYZHCellHeight;
    }
    return _tableView;
}

- (YZHSearchView *)searchView {
    
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"YZHSearchView" owner:nil options:nil].lastObject;
        [_searchView.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_searchView.searchButton setTitle:@"搜索 YOLO ID 号" forState:UIControlStateNormal];
        [_searchView.searchButton setTitle:@"搜索 YOLO ID 号" forState:UIControlStateSelected];
        [self.tableView addSubview:_searchView];
    }
    return _searchView;
}

@end

