//
//  YZHAddBookPhoneContactVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookPhoneContactVC.h"

#import "YZHPhoneContactDefaultView.h"
#import "YZHPhoneContactCell.h"
@interface YZHAddBookPhoneContactVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHPhoneContactDefaultView* defaultView;
@property (nonatomic, assign) BOOL hasPhonePermissions;

@end

@implementation YZHAddBookPhoneContactVC

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.hasPhonePermissions = NO;
    
    self.navigationItem.title = @"手机联系人";
    //TODO
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backPreviousPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // TODO: 封装.
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    
    if (self.hasPhonePermissions == NO) {
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"获取" style:UIBarButtonItemStylePlain target:self action:@selector(readPhoneContact:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    }
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
}

- (void)reloadView {

    if (self.hasPhonePermissions) {
        [self.view addSubview:self.tableView];
    } else {
        [self.view addSubview:self.defaultView];
    }
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    if (self.hasPhonePermissions) {
        [self.view addSubview:self.tableView];
    } else {
        [self.view addSubview:self.defaultView];
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHPhoneContactCell* cell;
    if (indexPath.section == 0) {
        cell = [YZHPhoneContactCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:YZHPhoneContactCellTypeDating];
    } else {
        cell = [YZHPhoneContactCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:YZHPhoneContactCellTypeReview];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22;
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
}

#pragma mark - 5.Event Response

- (void)backPreviousPage {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)readPhoneContact:(UIBarButtonItem *)sender {
    
    [YZHRouter openURL:kYZHRouterMyInformation];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        //减掉导航栏高度.与 super View 保持一致.
        _tableView.height = _tableView.height - 64;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = 55;
    }
    return _tableView;
}

- (YZHPhoneContactDefaultView *)defaultView {
    
    if (!_defaultView) {
        _defaultView = [YZHPhoneContactDefaultView yzh_viewWithFrame:self.view.bounds];
    }
    return _defaultView;
}

@end
