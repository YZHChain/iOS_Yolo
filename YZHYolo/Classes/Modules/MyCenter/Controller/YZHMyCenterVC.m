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
static NSString* const KCellIdentifier = @"centerCellIdentifier";
@interface YZHMyCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)YZHMyCenterHeaderView* headerView;

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
}

- (void)setupView
{
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView ym_addHeaderWithRefreshHandler:^{
    }];

}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHMyCenterCell* cell = [tableView dequeueReusableCellWithIdentifier:KCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [YZHRouter openURL:kYZHRouterMyInformation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 15;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView* tableViewFooter = [[UIView alloc] init];

    return tableViewFooter;
}


//- tableview
#pragma mark - 5.Event Response


#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHMyCenterCell" bundle:nil] forCellReuseIdentifier: KCellIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (YZHMyCenterHeaderView *)headerView{
    
    if (_headerView == nil) {
        // 头尽量不写死 TODO:
        _headerView = [YZHMyCenterHeaderView yzh_viewWithFrame:CGRectMake(0, 0, YZHVIEW_WIDTH, 170)];
    }
    return _headerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
