//
//  YZHMyInformationMyPlaceVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationMyPlaceVC.h"

#import "YZHMyInformationMyPlaceCell.h"
static NSString* const kPositioningCellIdentifier = @"positioningCellIdentifier";
static NSString* const kCountriesCellIdentifier =  @"countriesCellIdentifier";
@interface YZHMyInformationMyPlaceVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView* tableView;

@end

@implementation YZHMyInformationMyPlaceVC

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //TODO: 不知道什么原因, Bar 还是隐藏的。暂时先通过这里解决。。
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置地址";
    self.showNavigationBar = YES;
    self.hideNavigationBarLine = YES;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    //    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 ) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHMyInformationMyPlaceCell* cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPositioningCellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kCountriesCellIdentifier];
    }
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHMyInformationMyPlaceCell" owner:nil options:nil][indexPath.section];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] init];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 13)];
    label.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        label.text = @"定位到的位置";
    } else {
        label.text = @"选择";
    }
    [view addSubview:label];
    
    
    return view;
}


#pragma mark - 5.Event Response

- (void)saveSetting{
    
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, YZHVIEW_WIDTH, YZHVIEW_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

@end
