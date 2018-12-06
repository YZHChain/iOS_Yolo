//
//  YZHSearchTeamVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchTeamVC.h"

#import "YZHUserLoginManage.h"
#import "YZHSearchModel.h"
#import "YZHSearchTeamCell.h"
@interface YZHSearchTeamVC ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) YZHSearchModel* searchModel;
@property (nonatomic, strong) YZHSearchModel* recommendModel;
@property (nonatomic, strong) UIView *customNavBar;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) BOOL havaSearchModel;

@end

@implementation YZHSearchTeamVC

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
//    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    if (self.navigationController) {
//
//        self.navigationController.navigationBarHidden = YES;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    if (self.navigationController) {
//        self.navigationController.navigationBarHidden = NO;
//    }
//}

#pragma mark - 2.SettingView and Style
- (void)setupNavBar {
    
    [self searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.pageNumber = 1;
    int pageSize = 20;
    NSString* accid = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
    NSDictionary* dic = @{
                          @"pn": [NSNumber numberWithInt:self.pageNumber],
                          @"accid": accid,
                          @"pageSize": [NSNumber numberWithInt:pageSize]
                          };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    [[YZHNetworkService shareService] POSTGDLNetworkingResource:PATH_TEAM_RECOMMENDEDGROUP params:dic successCompletion:^(id obj) {
        [hud hideWithText:nil];
        self.recommendModel = [YZHSearchModel YZH_objectWithKeyValues:obj];
        [self.tableView reloadData];
        
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger i = 0;
    if (self.searchModel.searchArray.count) {
        ++i;
    }
    if (self.recommendModel.recommendArray.count) {
        ++i;
    }
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.havaSearchModel) {
        if (section == 0) {
            return self.searchModel.searchArray.count;
        } else {
            return 3;
        }
    } else {
        return self.recommendModel.recommendArray.count ? 3 : 0;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHSearchTeamCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    if (self.havaSearchModel) {
        
    } else {
        YZHTTTTeamModel* model = self.recommendModel.recommendArray[indexPath.row];
        [cell refresh:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    [self.searchBar canResignFirstResponder];
    [self.searchBar endEditing:YES];
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods


#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHSearchTeamCell" bundle:nil] forCellReuseIdentifier: kYZHCommonCellIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        
        UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width-80,44)];
        searchbar.placeholder = @"模糊搜索(群名)";
        searchbar.searchBarStyle = UISearchBarStyleDefault;
        searchbar.showsCancelButton = YES;
        searchbar.tintColor = [UIColor yzh_sessionCellGray];
        searchbar.delegate = self;
        self.navigationItem.titleView = searchbar;
        
        _searchBar = searchbar;
    }
    return _searchBar;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    NSLog(@"搜索%@", searchBar.text);
}

@end
