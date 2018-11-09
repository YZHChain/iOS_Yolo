//
//  YZHMyplaceCityVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyplaceCityVC.h"

#import "YZHMyinformationMyplaceModel.h"
#import "YZHMyInformationMyPlaceCell.h"
#import "YZHUserModelManage.h"
#import "YZHProgressHUD.h"

static NSString* const kCountriesCellIdentifier =  @"selectedLocationCellIdentifier";
@interface YZHMyplaceCityVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHLocationCountrieModel* countriesModel;
@property (nonatomic, strong) YZHLocationProvinceModel* provincesModel;
@property (nonatomic, strong) YZHMyInformationMyPlaceCell* lastSelectedCell;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSMutableDictionary* nextLocationDic;

@end

@implementation YZHMyplaceCityVC

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

- (void)setupNavBar
{
    self.navigationItem.title = @"设置地址";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor yzh_separatorLightGray]} forState:UIControlStateDisabled];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{

    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.rowHeight = 40;
    
    self.selectedRow = MAXFLOAT;
    NSLog(@"当前选择行数%ld",self.selectedRow);
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.countriesModel.provinces.count ? self.countriesModel.provinces.count :  self.provincesModel.citys.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     YZHMyInformationMyPlaceCell* cell = [tableView dequeueReusableCellWithIdentifier:kCountriesCellIdentifier];
    if (cell == nil) {
          cell = [[NSBundle mainBundle] loadNibNamed:@"YZHMyInformationMyPlaceCell" owner:nil options:nil].lastObject;
    }
    // TODO:尽量提取
    NSString* countrieName;
    BOOL hasNextLocation = NO;
    if (self.countriesModel.provinces.count) {
        countrieName = self.countriesModel.provinces[indexPath.row].name;
        if (self.countriesModel.provinces[indexPath.row].citys.count > 0) {
            hasNextLocation = YES;
        }
    } else {
        countrieName = self.provincesModel.citys[indexPath.row].name;
    }
    if (hasNextLocation) {
        cell.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
    } else {
        cell.guideImageView.image = nil;
    }
    cell.countriesLabel.text = countrieName;
    [self.nextLocationDic setObject:@(hasNextLocation) forKey:indexPath];
    if (self.selectedRow == indexPath.row) {
        cell.selectStatusLabel.text = @"当前选择";
    } else {
        cell.selectStatusLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 34;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] init];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 13)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"选择";
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO:优化
    BOOL hasNextLocation = [[self.nextLocationDic objectForKey:indexPath] boolValue];
    NSInteger selectedRow = indexPath.row;
    self.viewModel.isFacilityLocation = NO;
    if (hasNextLocation) {
        self.viewModel.selectProvince = selectedRow;
        YZHLocationProvinceModel* model = self.countriesModel.provinces[selectedRow];
        [YZHRouter openURL:kYZHRouterMyPlaceCity info:@{@"provincesModel": model, @"viewModel": self.viewModel}];
    } else {
        self.selectedRow = indexPath.row;
        if (self.provincesModel.citys.count) {
        self.viewModel.selectCity = self.selectedRow;
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

#pragma mark - 5.Event Response

- (void)saveSetting{
    
    [self.viewModel updataUserPlaceData];
    

    NSString* usrInfoExtString = [self.viewModel.userInfoExt userInfoExtString];
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{
                                                       @(NIMUserInfoUpdateTagExt):usrInfoExtString
                                                       } completion:^(NSError * _Nullable error) {
                                                           if (!error) {
                                                               [hud hideWithText:nil];
                                                                   [YZHRouter openURL:kYZHRouterMyInformation info:@{kYZHRouteAnimated: @(NO), kYZHRouteBackIndex: kYZHRouteIndexRoot}];
                                                           } else {
                                                               [hud hideWithText:error.domain];
                                                           }
                                                       }];

    

}

#pragma mark - 6.Private Methods

- (void)setupNotification{
    
}

#pragma mark - 7.GET & SET

- (NSMutableDictionary *)nextLocationDic {
    
    if (!_nextLocationDic) {
        _nextLocationDic = [[NSMutableDictionary alloc] init];
    }
    return _nextLocationDic;
}

@end
