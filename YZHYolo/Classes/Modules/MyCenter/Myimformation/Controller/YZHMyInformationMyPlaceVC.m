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
#import "YZHUserModelManage.h"
#import "YZHProgressHUD.h"

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
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) YZHUserPlaceModel* userPlaceModel;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;
@property (nonatomic, assign) BOOL readLocationSucceed;//

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
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.selectedProvinceIndex = 0;
    self.selectedCountrieIndex = 0;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:1000 inSection:1000];
    //如数据为空则
    if (self.viewModel) {
        [self.tableView reloadData];
    } else {
        [self setupData];
    }
    
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置地址";
    self.hideNavigationBarLine = YES;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor yzh_separatorLightGray]} forState:UIControlStateDisabled];
    
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
        self.readLocationSucceed = YES;
    } faildBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.locationCell.positioningResultLabel.text = @"无法获取定位....";
            self.readLocationSucceed = NO;
        });
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
        //重新排序;
        [self.viewModel checkoutUserPlaceData];
    } else {
        self.viewModel = nil;
    }
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return self.viewModel.sortCountries.count;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:
    YZHMyInformationMyPlaceCell* cell;
    cell = [YZHMyInformationMyPlaceCell tempTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.readLocationSucceed && [self.selectedIndexPath isEqual:indexPath]) {
            
            cell.selectStatusLabel.text = @"当前选择";
          
            } else {
                cell.selectStatusLabel.text = @"";
            }
        self.locationCell = cell;
    }
    if (indexPath.section == 1) {
        NSString* countrieName;
        BOOL hasNextLocation = NO;
        if (_currentType == 0) {
            countrieName = self.viewModel.sortCountries[indexPath.row].name;
            if (self.viewModel.sortCountries[indexPath.row].provinces.count > 0) {
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
        if (self.selectedIndexPath == indexPath) {
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
    if (indexPath.section == 0) {
        if (self.readLocationSucceed) {
            self.selectedIndexPath = indexPath;
            self.viewModel.selectCountry = 0;
            self.viewModel.selectProvince = 0;
            self.viewModel.selectCity = 0;
            self.viewModel.isFacilityLocation = YES;
            self.viewModel.complete = self.locationCell.positioningResultLabel.text;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [tableView reloadData];
        }
    }
    //TODO可以直接通过校验数组方式来判断,去掉字典缓存的方式.
    BOOL hasNextLocation = [[self.nextLocationDic objectForKey:indexPath] boolValue];
    if (indexPath.section == 1) {
        if (hasNextLocation) {
            self.selectedCountrieIndex = indexPath.row;
            // 先检查当前国家下是否存在省份,如果不存在则直接到具体城市
            BOOL hasProvinces = self.viewModel.sortCountries[self.selectedCountrieIndex].provinces.count > 1 ? YES : NO;
            if (hasProvinces) {
                //有省份可选择
                if (self.selectedCountrieIndex > self.viewModel.userPlaceModel.selectCountry) {
                    //暂时标记保存,
                    self.viewModel.selectCountry = self.selectedCountrieIndex;
                } else if (self.selectedCountrieIndex == 0) {
                    //取原来的索引
                    self.viewModel.selectCountry = self.viewModel.userPlaceModel.selectCountry;
                } else {
                    //由于重新排序过,所以其向下偏移一位.需要减去否则其并不是真正的索引.
                    self.viewModel.selectCountry = self.selectedCountrieIndex - 1;
                }
                //保存标记
                self.viewModel.userPlaceModel.selectCountry = self.selectedCountrieIndex;
                //真正使用到的 Model 则是通过重新排序过的 ViewModel 并且使用当前列表所选择索引来找到.
                YZHLocationCountrieModel* model = self.viewModel.sortCountries[self.selectedCountrieIndex];
                self.navigationItem.rightBarButtonItem.enabled = NO;

                [YZHRouter openURL:kYZHRouterMyPlaceCity info:@{@"countriesModel": model, @"viewModel": self.viewModel}];
            } else {
                // 无省份选择则默认读取第一个,去选择城市
                self.selectedProvinceIndex = 0;
                if (self.selectedCountrieIndex > self.viewModel.userPlaceModel.selectCountry) {
                    //暂时标记保存,
                    self.viewModel.selectCountry = self.selectedCountrieIndex;
                } else if (self.selectedCountrieIndex == 0) {
                    //取原来的索引
                    self.viewModel.selectCountry = self.viewModel.userPlaceModel.selectCountry;
                } else {
                    //由于重新排序过,所以其向下偏移一位.需要减去否则其并不是真正的索引.
                    self.viewModel.selectCountry = self.selectedCountrieIndex - 1;
                }
                self.viewModel.selectProvince = self.selectedProvinceIndex;
                //真正使用到的 Model 则是通过重新排序过的 ViewModel 并且使用当前列表所选择索引来找到.
                YZHLocationProvinceModel* model = self.viewModel.sortCountries[self.selectedCountrieIndex].provinces[self.selectedProvinceIndex];
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [YZHRouter openURL:kYZHRouterMyPlaceCity info:@{@"provincesModel": model, @"viewModel": self.viewModel}];
            }
        } else {
            //只有国家
            self.selectedIndexPath = indexPath;
            self.selectedCountrieIndex = indexPath.row;
            //针对有做过选择的位置的,如果选择为第一个则
            if (YZHIsString(self.viewModel.userPlaceModel.complete) && !self.viewModel.userPlaceModel.isFacilityLocation) {
                if (self.selectedCountrieIndex == 0) {
                    
                }
            }
            if (self.selectedCountrieIndex > self.viewModel.userPlaceModel.selectCountry) {
                //暂时标记保存,
                self.viewModel.selectCountry = self.selectedCountrieIndex;
            } else if (self.selectedCountrieIndex == 0) {
                //取原来的索引
                self.viewModel.selectCountry = self.viewModel.userPlaceModel.selectCountry;
            } else {
                //由于重新排序过,所以其向下偏移一位.需要减去否则其并不是真正的索引.
                self.viewModel.selectCountry = self.selectedCountrieIndex - 1;
            }
            //标记当前选择的位置.
            self.viewModel.selectProvince = 0;
            self.viewModel.selectCity = 0;
            self.viewModel.isFacilityLocation = NO;
            self.viewModel.complete = self.viewModel.countries[self.viewModel.selectCountry].name;
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    
}

#pragma mark - 5.Event Response

- (void)saveSetting{

    //将数据保存到 UserInfoExt 里面;
    [self.viewModel updataUserPlaceData];
    NSString* usrInfoExtString = [self.viewModel.userInfoExt userInfoExtString];
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{
                                                       @(NIMUserInfoUpdateTagExt): usrInfoExtString
                                                       } completion:^(NSError * _Nullable error) {
                                                           if (!error) {
                                                               [hud hideWithText: nil];
                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                           } else {
                                                               [hud hideWithText: error.domain];
                                                           }
                                                       }];

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

- (YZHUserInfoExtManage *)userInfoExt {
    
    if (!_userInfoExt) {
        _userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    }
    return _userInfoExt;
}

- (YZHUserPlaceModel *)userPlaceModel {
    
    if (!_userPlaceModel) {
        _userPlaceModel = self.userInfoExt.place;
    }
    return _userPlaceModel;
}

@end
