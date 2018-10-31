//
//  YZHMyInformationMyPlaceVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationMyPlaceVC.h"

#import "YZHMyInformationMyPlaceCell.h"
#import "YZHLocationManager.h"
#import "YZHMyinformationMyplaceModel.h"

typedef enum : NSUInteger {
    YZHSelectMyPlaceTypeCountries = 0,
    YZHSelectMyPlaceTypeProvinces = 1,
    YZHSelectMyPlaceTypeCity = 2,
} YZHSelectMyPlaceType;

@interface YZHMyInformationMyPlaceVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHLocationWorldModel* viewModel;
@property (nonatomic, assign) NSInteger selectedCountrieIndex;
@property (nonatomic, assign) NSInteger selectedProvinceIndex;
@property (nonatomic, assign) YZHSelectMyPlaceType currentType;
@property (nonatomic, strong) YZHMyInformationMyPlaceCell* lastSelectedCell;
@property (nonatomic, strong) YZHMyInformationMyPlaceCell* locationCell;
@property (nonatomic, strong) NSMutableDictionary* nextLocationDic;
@property (nonatomic, assign) NSInteger selectedRow;

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
//    [self setupData];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //TODO: 第二版本.
    self.currentType = YZHSelectMyPlaceTypeCountries;
    self.selectedProvinceIndex = 0;
    self.selectedCountrieIndex = 0;
    self.selectedRow = NSIntegerMax;
    NSLog(@"当前选择%ld", self.selectedRow);
    //3.请求数据
    [self setupData];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置地址";
    self.hideNavigationBarLine = YES;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    item.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self.view addSubview:self.tableView];
    
    YZHLocationManager* manager = [YZHLocationManager shareManager];
    [manager getLocationWithSucceed:^{
        self.locationCell.positioningResultLabel.text = manager.currentLocation;
    } faildBlock:^{
        self.locationCell.positioningResultLabel.text = @"无法获取定位....";
    }];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    //读取地理位置 JSON 文件.
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"YZHLocation" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    if (data) {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        self.viewModel = [YZHLocationWorldModel YZH_objectWithKeyValues:result];
    } else {
        self.viewModel = nil;
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //TODO: 暂时预留两个版本
    if (section == 0) {
        return 1;
    } else {
        return self.viewModel.countries.count;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:
    YZHMyInformationMyPlaceCell* cell;
    cell = [YZHMyInformationMyPlaceCell tempTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        self.locationCell = cell;
    }
    
    if (indexPath.section == 1) {
        NSString* countrieName;
        BOOL hasNextLocation = NO;
        if (_currentType == 0) {
            countrieName = self.viewModel.countries[indexPath.row].name;
            if (self.viewModel.countries[indexPath.row].provinces.count > 0) {
                hasNextLocation = YES;
            }
        }
        cell.countriesLabel.text = countrieName;
        if (hasNextLocation) {
            cell.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
        } else {
            cell.guideImageView.image = nil;
        }
        [self.nextLocationDic setObject:@(hasNextLocation) forKey:indexPath];
        if (self.selectedRow == indexPath.row) {
            cell.selectStatusLabel.text = @"当前选择";
        } else {
            cell.selectStatusLabel.text = @"";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
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
    
    //TODO:
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YZHMyInformationMyPlaceCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL hasNextLocation = [[self.nextLocationDic objectForKey:indexPath] boolValue];
    if (indexPath.section == 1) {
        if (hasNextLocation) {
            self.selectedCountrieIndex = indexPath.row;
            // 先检查当前国家下是否存在省份,如果不存在则直接到具体城市
            BOOL hasProvinces = self.viewModel.countries[self.selectedCountrieIndex].provinces.firstObject.name.length ? YES : NO;
            if (hasProvinces) {
                YZHLocationCountrieModel* model = self.viewModel.countries[self.selectedCountrieIndex];
                [YZHRouter openURL:kYZHRouterMyPlaceCity info:@{@"countriesArray": model}];
            } else {
                self.selectedProvinceIndex = 0;
                YZHLocationProvinceModel* model = self.viewModel.countries[self.selectedCountrieIndex].provinces[self.selectedProvinceIndex];
                [YZHRouter openURL:kYZHRouterMyPlaceCity info:@{@"provincesArray": model}];
            }
        } else {
            self.selectedRow = indexPath.row;
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    
}

#pragma mark - 5.Event Response

- (void)saveSetting{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YZHView_Width, YZHView_Height - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

- (NSMutableDictionary *)nextLocationDic {
    
    if (!_nextLocationDic) {
        _nextLocationDic = [[NSMutableDictionary alloc] init];
    }
    return _nextLocationDic;
}

@end
