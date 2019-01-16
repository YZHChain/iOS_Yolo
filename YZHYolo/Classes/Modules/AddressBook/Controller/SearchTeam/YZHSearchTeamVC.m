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
#import "YZHSearchRecommendSectionView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YZHUserDataManage.h"
#import "YZHPasteSkipManage.h"

static int kYZHRecommendTeamPageSize = 20; // 默认每页个数
static NSString* kYZHSearchRecommendSectionView = @"YZHSearchRecommendSectionView";
@interface YZHSearchTeamVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, YZHSearchRecommendViewProtocol, YZHSearchTeamCellProtocol>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) YZHSearchListModel* searchModel;
@property (nonatomic, strong) YZHSearchListModel* recommendModel;
@property (nonatomic, strong) UIView *customNavBar;
@property (nonatomic, assign) int recommendPageNumber;
@property (nonatomic, assign) BOOL havaSearchModel;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, strong) NSString* lastKeyText;
@property (nonatomic, assign) int searchPageNumber;
@property (nonatomic, strong) YZHUserDataModel* userDataModel;

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
    
    self.fd_prefersNavigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style
- (void)setupNavBar {
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.title = @"公开群搜索";
    [self searchBar];
    [self.searchBar becomeFirstResponder];
    
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.isSearchStatus = NO;
    self.havaSearchModel = NO;
    self.searchPageNumber = 1;
    self.recommendPageNumber = 1;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {

    NSString* accid = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
    NSMutableArray* selectedTeamArray = self.userDataModel.teamLabel;
    NSDictionary* dic;
    if (selectedTeamArray.count) {
        dic = @{
                 @"pn": [NSNumber numberWithInt:self.recommendPageNumber],
                 @"accid": accid,
                 @"pageSize": [NSNumber numberWithInt:kYZHRecommendTeamPageSize],
                 @"teamLabel": [selectedTeamArray mj_JSONString]
                     };

    } else {
        dic = @{
                @"pn": [NSNumber numberWithInt:self.recommendPageNumber],
                @"accid": accid,
                @"pageSize": [NSNumber numberWithInt:kYZHRecommendTeamPageSize],
                };
    }
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    [[YZHNetworkService shareService] POSTGDLNetworkingResource:SERVER_SQUARE(PATH_TEAM_RECOMMENDEDGROUP) params:dic successCompletion:^(id obj) {
        [hud hideWithText:nil];
        self.recommendModel = [YZHSearchListModel YZH_objectWithKeyValues:obj];
        [self.tableView reloadData];
        
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

- (void)swtichRecommendTeamList {
    
    if (self.recommendPageNumber < self.recommendModel.pageTotal) {
        ++self.recommendPageNumber;
    } else {
        self.recommendPageNumber = 1;
    }
    
    [self setupData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearchStatus) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearchStatus) {
        if (section == 0) {
            return self.searchModel.searchArray.count;
        } else {
            return self.recommendModel.recommendArray.count;
        }
    } else {
        return self.recommendModel.recommendArray.count ? self.recommendModel.recommendArray.count : 0;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHSearchTeamCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    YZHSearchModel* model;
    if (self.isSearchStatus) {
        if (indexPath.section == 0) {
            model = self.searchModel.searchArray[indexPath.row];
        } else {
            model = self.recommendModel.recommendArray[indexPath.row];
        }
    } else {
        model = self.recommendModel.recommendArray[indexPath.row];
    }
    [cell refresh:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.isSearchStatus) {
        
        if (section == 0) {
            UITableViewHeaderFooterView* searchSectionView = [[UITableViewHeaderFooterView alloc] init];
            UILabel* label = [[UILabel alloc] init];
            label.font = [UIFont yzh_commonFontStyleFontSize:13];
            label.textColor = [UIColor yzh_sessionCellGray];
            if (self.havaSearchModel) {
                label.text = @"搜索到的群";
            } else {
                label.text = @"未找到相关群";
            }
            [searchSectionView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(13);
                make.height.mas_equalTo(15);
            }];
            searchSectionView.backgroundView = ({
                UIView* view = [[UIView alloc] initWithFrame:searchSectionView.bounds];
                view.backgroundColor = [UIColor yzh_backgroundThemeGray];
                view;
            });
            return searchSectionView;
        } else {
            YZHSearchRecommendSectionView* sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHSearchRecommendSectionView];
            sectionView.delegate = self;
            return sectionView;
        }
    } else {
        YZHSearchRecommendSectionView* sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHSearchRecommendSectionView];
        sectionView.delegate = self;
        return sectionView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHSearchModel* model;
    if (self.isSearchStatus) {
        if (indexPath.section == 0) {
            model = self.searchModel.searchArray[indexPath.row];
        } else {
            model = self.recommendModel.recommendArray[indexPath.row];
        }
    } else {
        model = self.recommendModel.recommendArray[indexPath.row];
    }
//    //进入群详情.
//    BOOL isTeamMerber = [[[NIMSDK sharedSDK] teamManager] isMyTeam:model.teamId];
//    if (isTeamMerber) {
//        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:model.teamId];
//        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
//        BOOL isTeamOwner = [userId isEqualToString:team.owner] ? YES : NO;
//        [YZHRouter openURL:kYZHRouterCommunityCard info:@{
//                                                          @"isTeamOwner": @(isTeamOwner),
//                                                          @"teamId": model.teamId,
//                                                          }];
//    } else {
//        [YZHRouter openURL:kYZHRouterCommunityCardIntro info:@{
//                                                               @"teamId": model.teamId,
//                                                               kYZHRouteSegue: kYZHRouteSegueModal,
//                                                               kYZHRouteSegueNewNavigation: @(YES)
//                                                               }];
//    }
    [YZHRouter openURL:kYZHRouterCommunityCardIntro info:@{
                                                           @"teamId": model.teamId ? model.teamId : @"",
                                                           kYZHRouteSegue: kYZHRouteSegueModal,
                                                           kYZHRouteSegueNewNavigation: @(YES)
                                                           }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar endEditing:YES];
}

#pragma mark - YZHSearchRecommendViewProtocol

- (void)onTouchSwitch:(UIButton *)sender {
    
    [self swtichRecommendTeamList];
}

- (void)onTouchSwitchRange:(UIButton *)sender {
    
    YZHUserDataManage* dataManage = [YZHUserDataManage sharedManager];
    @weakify(self)
    void(^selectedLabelSaveHandle)(NSMutableArray *) = ^(NSMutableArray *selectedTeamLabel) {
        @strongify(self)
        self.userDataModel.teamLabel = selectedTeamLabel;
        dataManage.currentUserData.teamLabel = self.userDataModel.teamLabel;
        [[YZHUserDataManage sharedManager] setCurrentUserData:dataManage.currentUserData];
        [self setupData];
    };
    NSMutableArray* selectedArray = self.userDataModel.teamLabel.count ? self.userDataModel.teamLabel : [[NSMutableArray alloc] init];
    [YZHRouter openURL:kYZHRouterCommunityCreateTeamTagSelected info:@{
                                                                       kYZHRouteSegue: kYZHRouteSegueModal,
                                                                       kYZHRouteSegueNewNavigation : @(YES),
                                                                       @"selectedLabelSaveHandle": selectedLabelSaveHandle,
                                                                       @"selectedLabelArray":selectedArray
                                                                       }];
}

#pragma mark - YZHSearchTeamCellProtocol

- (void)onTouchJoinTeam:(YZHSearchModel *)model {
    
    //可以先读取本地,如果没有在拉取.
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:model.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        @strongify(self)
        if (!error) {
            [self addTeamWith:team hud:hud];
        } else {
            if (error.code == 803) {
                [hud hideWithText:@"该群已解散"];
            } else {
                [hud hideWithText:@"未找到该群"];
            }
        }
    }];
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)addTeamWith:(NIMTeam* )team hud:(YZHProgressHUD *)hud {
    
//    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    BOOL isTeamMerber = [[[NIMSDK sharedSDK] teamManager] isMyTeam:team.teamId];
    if (!isTeamMerber) {
        NSString* title;
        switch (team.joinMode) {
            case NIMTeamJoinModeNoAuth:
                title = @"加入群聊成功";
                break;
            case NIMTeamJoinModeNeedAuth:
                title = @"已发起加入群聊申请";
                break;
            case NIMTeamJoinModeRejectAll:
                title = @"此群不允许其他人加入";
                break;
            default:
                break;
        }
        [[[NIMSDK sharedSDK] teamManager] applyToTeam:team.teamId message:@"通过群搜索加入" completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
            if (!error) {
//                if (applyStatus == NIMTeamApplyStatusAlreadyInTeam) {
//
//                } else if (applyStatus == NIMTeamApplyStatusWaitForPass) {
//
//                } else if (applyStatus == NIMTeamApplyStatusInvalid) {
//
//                }
                [hud hideWithText:title];
            } else {
                //TODO: 提示语
                if (error.code == 801) {
                    [hud hideWithText:@"群人数达到上限"];
                } else {
                    [hud hideWithText:@"申请入群失败"];
                }
            }
        }];
    } else {
        [hud hideWithText:@"你已是本群群成员"];
    }
    
}

- (void)searchTeamListWithKeyText:(NSString *)keyText {
    
    NSString* accid = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
    //如果搜索的是同一个关键字则页号 + 1; 否则默认从第一页开始.
    if (YZHIsString(_lastKeyText)) {
        
        if ([_lastKeyText isEqualToString:keyText]) {
            //TODO:
            if (self.searchPageNumber < self.searchModel.pageTotal) {
                ++ self.searchPageNumber;
            } else {
                self.searchPageNumber = 1;
            }
        } else {
            self.searchPageNumber = 1;
        }
    } else {
        self.searchPageNumber = 1;
    }
    NSDictionary* dic = @{
                          @"accid": accid,
                          @"kw": keyText,
                          @"pn": [NSNumber numberWithInt:self.searchPageNumber],
                          };
    _lastKeyText = keyText;
    YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
    [[YZHNetworkService shareService] POSTGDLNetworkingResource:SERVER_SQUARE(PATH_TEAM_SEARCHGROUP) params:dic successCompletion:^(id obj) {
        
        [hud hideWithText:nil];
        self.searchModel = [YZHSearchListModel YZH_objectWithKeyValues:obj];
        if (self.searchModel.searchArray.count) {
            self.havaSearchModel = YES;
        } else {
            self.havaSearchModel = NO;
        }
        self.isSearchStatus = YES;
        [self.tableView reloadData];
        
    } failureCompletion:^(NSError *error) {
        
        [hud hideWithText:error.domain];
        self.havaSearchModel = NO;
        self.isSearchStatus = YES;
        [self.tableView reloadData];
    }];
}

- (void)searchTeamURLWithKeyText:(NSString *)keyText {
    
    NSString* teamIdBase64 = [keyText componentsSeparatedByString:@"teamId="].lastObject;
    NSData* decodedData = [[NSData alloc] initWithBase64EncodedString:teamIdBase64 options:0];
    NSString* teamIdString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
    [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:teamIdString completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        [hud hideWithText:nil];
        if (!error) {
            self.searchModel = [[YZHSearchListModel alloc] init];
            YZHSearchModel* model = [[YZHSearchModel alloc] init];
            model.teamIcon = team.avatarUrl ? team.avatarUrl : @"team_cell_photoImage_default";
            model.teamId = team.teamId;
            model.teamName = team.teamName;
            self.searchModel.searchArray = [[NSMutableArray alloc] init];
            [self.searchModel.searchArray addObject:model];
            if (self.searchModel.searchArray.count) {
                self.havaSearchModel = YES;
            } else {
                self.havaSearchModel = NO;
            }
            self.isSearchStatus = YES;
            [self.tableView reloadData];
        } else {
            self.havaSearchModel = NO;
            self.isSearchStatus = YES;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        _tableView.frame = CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64);
        [_tableView registerNib:[UINib nibWithNibName:@"YZHSearchTeamCell" bundle:nil] forCellReuseIdentifier: kYZHCommonCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHSearchRecommendSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHSearchRecommendSectionView];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        
        UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width-80,33)];
        searchbar.placeholder = @"模糊搜索(群名)";
        searchbar.searchBarStyle = UISearchBarStyleDefault;
        searchbar.showsCancelButton = YES;
        //通过KVC拿到textField
        UITextField  *seachTextFild = [searchbar valueForKey:@"searchField"];
        seachTextFild.textColor = [UIColor yzh_fontShallowBlack];
        seachTextFild.font = [UIFont yzh_commonFontStyleFontSize:14];
        //修改光标颜色
        [seachTextFild setTintColor:[UIColor blueColor]];
        
        for (id cencelButton in [searchbar.subviews[0] subviews])
        {
            if([cencelButton isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cencelButton;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        searchbar.delegate = self;
        if (@available(iOS 9.0, *)) {
            [[searchbar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
        } else {
            // Fallback on earlier versions
        }
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
    if (YZHIsString(searchBar.text)) {
        self.isSearchStatus = YES;
//        if ([searchBar.text containsString:kYZHTeamURLHostKey] && [searchBar.text containsString:@"teamId"]) {
//            [self searchTeamURLWithKeyText:searchBar.text];
//        } else {
//            [self searchTeamListWithKeyText:searchBar.text];
//        }
        [self searchTeamListWithKeyText:searchBar.text];
        
    } else {
        self.isSearchStatus = NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!YZHIsString(searchBar.text)) {
        self.isSearchStatus = NO;
        [self.tableView reloadData];
    }
}

- (YZHUserDataModel *)userDataModel {
    
    if (!_userDataModel) {
        _userDataModel = [[YZHUserDataManage sharedManager] currentUserData];
    }
    return _userDataModel;
}

@end
