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

static NSString* const kaddFirendCellIdentifier = @"addFirendCellIdentifier";
@interface YZHAddBookAddFirendVC ()<UITableViewDelegate, UITableViewDataSource, JKRSearchControllerhResultsUpdating, JKRSearchControllerDelegate, JKRSearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHFirendContentModel* model;
@property (nonatomic, strong) JKRSearchController* searchController;
@property (nonatomic, weak) YZHAddFirendSearchVC* searchResultVC;

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
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHAddBookAddFirendCell" bundle:nil] forCellReuseIdentifier:kaddFirendCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.rowHeight = kYZHCellHeight;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
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
    
    return 10;
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
    } else {
        [YZHRouter openURL:model.route];
    }
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - JKRSearchControllerhResultsUpdating

- (void)updateSearchResultsForSearchController:(JKRSearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (YZHIsString(searchText)) {
        
    } else {
        self.searchResultVC.searchStatus = YZHAddFirendSearchStatusNotImput;
        [self.searchResultVC.tableView reloadData];
    }
}

#pragma mark - JKRSearchControllerDelegate
- (void)willPresentSearchController:(JKRSearchController *)searchController {
    
    self.searchResultVC.searchStatus = YZHAddFirendSearchStatusNotImput;
    [self.searchResultVC.tableView reloadData];
}

- (void)didPresentSearchController:(JKRSearchController *)searchController {
    NSLog(@"didPresentSearchController, %@", searchController);
}

#pragma mark - JKRSearchBarDelegate
// 点击搜索时。
- (void)searchBarTextFieldShouldReturn:(JKRSearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (YZHIsString(searchText)) {
        [searchBar endEditing:YES];
        NSDictionary* dic = @{
                              @"searchUser": searchText
                              };
        YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:self.searchResultVC.tableView text:nil];
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:PATH_FRIENDS_SEARCHUSER params:dic successCompletion:^(NSObject* obj) {
            @strongify(self)
            //后台能不能别瞎返回状态码???????
            if (!obj.yzh_apiEmptyValue) {
                self.searchResultVC.viewModel = [YZHAddFirendSearchModel YZH_objectWithKeyValues:obj];
                self.searchResultVC.searchStatus = YZHAddFirendSearchStatusSucceed;
                [hud hideWithText:nil];
                [self.searchResultVC refreshData];
            } else {
                self.searchResultVC.searchStatus = YZHAddFirendSearchStatusEmpty;
                [self.searchResultVC.tableView reloadData];
                [hud hideWithText:nil];
            }
        } failureCompletion:^(NSError *error) {
            
            //相关状态展示
            [hud hideWithText:error.domain];
        }];
    }
    
}

#pragma mark - 7.GET & SET

- (YZHFirendContentModel *)model {
    
    if (_model == nil) {
        _model = [[YZHFirendContentModel alloc] init];
    }
    return _model;
}

- (JKRSearchController *)searchController {
    
    if (!_searchController) {
        YZHAddFirendSearchVC* addFirendSearchVC = [[YZHAddFirendSearchVC alloc] init];
        _searchResultVC = addFirendSearchVC;
        _searchController = [[JKRSearchController alloc] initWithSearchResultsController:addFirendSearchVC];
        _searchController.searchBar.placeholder = @"搜索 YOLO ID,手机号";
        _searchController.hidesNavigationBarDuringPresentation = YES;
        // 代理方法都是设计业务, 可以单独抽取出来.
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.delegate = self;
    }
    return _searchController;
}

@end

