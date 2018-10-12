//
//  YZHMyInformationVC.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationVC.h"

#import "YZHMyInformationModel.h"
#import "YZHMyInformationCell.h"
#import "YZHMyInformationPhotoVC.h"

static NSString* const kPhoneCellIdentifier = @"imformationPhoneCellIdentifier";
static NSString* const kPhotoCellIdentifier = @"imformationPhotoCellIdentifier";
static NSString* const kNicknameCellIdentifier = @"imformationNicknameCellIdentifier";
static NSString* const kGenderCellIdentifier = @"imformationGenderCellIdentifier";
static NSString* const kQRCodeCellIdentifier = @"imformationQRCodeCellIdentifier";
static NSArray* cellIdentifierArray;
@interface YZHMyInformationVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)YZHMyInformationListModel* viewModel;

@end

@implementation YZHMyInformationVC

#pragma mark - 1.View Controller Life Cycle

+ (void)initialize{
    
    cellIdentifierArray = @[kPhoneCellIdentifier, kPhotoCellIdentifier, kNicknameCellIdentifier, kGenderCellIdentifier, kQRCodeCellIdentifier];
}

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
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    if (self.supportNavigation) {
//        self.navigationController.navigationBar.hidden = YES;
//    }
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"个人信息";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadView
{
    [self.tableView reloadData];
}

#pragma mark - 3.Request Data

- (void)setupData
{
    [[YZHNetworkService shareService] GETNetworkingResource:PATH_REGISTERED_MYINFORMATION params:nil successCompletion:^(id obj) {
        
        self.viewModel = [YZHMyInformationListModel YZH_objectWithKeyValues:obj];
        [self reloadView];
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
    
    YZHMyInformationModel* model = self.viewModel.list[indexPath.section].content[indexPath.row];
    YZHMyInformationCell* cell = [YZHMyInformationCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:model.cellType];
    [cell setViewModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHMyInformationModel* model = self.viewModel.list[indexPath.section].content[indexPath.row];
    
    [YZHRouter openURL:model.route];
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorColor = [UIColor yzh_separatorLightGray];
    }
    return _tableView;
}

- (YZHMyInformationListModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[YZHMyInformationListModel alloc] init];
    }
    return _viewModel;
}

@end
