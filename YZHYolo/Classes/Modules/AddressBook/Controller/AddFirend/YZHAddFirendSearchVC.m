//
//  YZHAddFirendSearchVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddFirendSearchVC.h"

#import "YZHAddBookAddFirendCell.h"
#import "YZHPhoneContactCell.h"
#import "YZHAddFirendSearchRemindCell.h"
#import "YZHPublic.h"
#import "YZHAddBookDetailsVC.h"
#import "YZHBaseNavigationController.h"

@interface YZHAddFirendSearchVC ()<UITableViewDelegate, UITableViewDataSource, YZHPhoneContactCellProtocol, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField* textField;

@end

@implementation YZHAddFirendSearchVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"用户搜索";
 
    [self searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.reminderView];
    [self.view addSubview:self.tableView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)refreshData {
    
    if (self.searchStatus == YZHAddFirendSearchStatusSucceed) {
        if (self.viewModel.isMySelf) {
            // 弹框提示
            [YZHAlertManage showAlertMessage:@"你不能添加自己到通讯录"];
        } else {
            __block NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:self.viewModel.userId];
            BOOL myFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.viewModel.userId];
            // 确保读取到最新数据.
            if (!myFriend) {
                YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
                @weakify(self)
                [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[self.viewModel.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                    @strongify(self)
                    if (!error) {
                        self.viewModel.user = users.firstObject;
                        [self.viewModel configurationUserData];
                    } else {
                        @strongify(self)
                        self.searchStatus = YZHAddFirendSearchStatusEmpty;
                    }
                    [hud hideWithText:nil];
                    [self.tableView reloadData];
                }];
            } else {
                self.viewModel.user = user;
                [self.viewModel configurationUserData];
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchStatus == YZHAddFirendSearchStatusSucceed) {
        
        YZHPhoneContactCell* cell = [[NSBundle mainBundle] loadNibNamed:@"YZHPhoneContactCell" owner:nil options:nil].firstObject;
        //先判断是否为好友状态
        cell.searchModel = self.viewModel;
        cell.delegate = self;
        return cell;
    } else {
       YZHAddFirendSearchRemindCell* cell = [YZHAddFirendSearchRemindCell yzh_viewWithFrame:CGRectZero];
        NSString* titleString;
        // 找不到人与未输入
        if (self.searchStatus == YZHAddFirendSearchStatusEmpty) {
            titleString = @"未找到该用户";
        } else {
            titleString = @"请输入准确的YOLO号或手机号查找";
        }
        cell.titleLabel.text = titleString;
        NSLog(@"刷新列表状态%ld", self.searchStatus);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* info = @{
                           @"userId": self.viewModel.userId
                           };
    //这里要到我们的用户详情页里
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:info];
}

- (void)onSelectedCellAddFirendButtonWithModel:(id)model {
    
    YZHAddFirendSearchModel* contactModel = model;
    if (contactModel.allowAdd) {
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = contactModel.userId;
        if (contactModel.needVerfy) {
//            request.operation = NIMUserOperationRequest;
//            //快速添加文案.
//            request.message = @"通过手机号或Yolo号搜索,请求添加好友";
//            request.operation = NIMUserOperationRequest;
            [YZHRouter openURL:kYZHRouterAddressBookAddFirendSendVerify info:@{
                                                                               @"userId": request.userId ? request.userId : @"",
                                                                               kYZHRouteSegue: kYZHRouteSegueModal,
                                                  kYZHRouteSegueNewNavigation: @(YES)                            }];
            return;
        } else {
            request.operation = NIMUserOperationAdd;
        }
        NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
        NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败,请重试" : @"请求失败,请重试";
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [hud hideWithText:successText];
            }else{
                [hud hideWithText:failedText];
            }
        }];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    if (YZHIsString(searchBar.text)) {
        [self searchTeamListWithKeyText:searchBar.text];
    } else {
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!YZHIsString(searchBar.text)) {
        
        self.searchStatus = YZHAddFirendSearchStatusNotImput;
        [self.tableView reloadData];
    }
}

#pragma mark - 5.Event Response

- (void)searchTeamListWithKeyText:(NSString*)keyText {
    
    if (YZHIsString(keyText)) {
        NSDictionary* dic = @{
                              @"searchUser": keyText
                              };
        YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
        @weakify(self)
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_FRIENDS_SEARCHUSER) params:dic successCompletion:^(NSObject* obj) {
            @strongify(self)
            [hud hideWithText:nil];
            //后台能不能别瞎返回状态码???????
            if (!obj.yzh_apiEmptyValue) {
                self.searchStatus = YZHAddFirendSearchStatusSucceed;
                self.viewModel = [YZHAddFirendSearchModel YZH_objectWithKeyValues:obj];
                [self refreshData];
                [self.tableView reloadData];
            } else {
                self.searchStatus = YZHAddFirendSearchStatusEmpty;
                [self.tableView reloadData];
                
                [hud hideWithText:nil];
            }
        } failureCompletion:^(NSError *error) {
            
            //相关状态展示
            [hud hideWithText:error.domain];
        }];
    }
}

#pragma mark - 6.Private Methods

#pragma mark - 7.GET & SET

- (YZHAddFirendSearchModel *)viewModel {

    if (!_viewModel) {
        _viewModel = [[YZHAddFirendSearchModel alloc] init];
    }
    return _viewModel;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        
        UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width-80,33)];
        searchbar.placeholder = @"搜索 YOLO ID";
        searchbar.searchBarStyle = UISearchBarStyleDefault;
        searchbar.showsCancelButton = YES;
        //通过KVC拿到textField
        UITextField  *seachTextFild = [searchbar valueForKey:@"searchField"];
        seachTextFild.textColor = [UIColor yzh_fontShallowBlack];
        seachTextFild.font = [UIFont yzh_commonFontStyleFontSize:14];
        //修改光标颜色
        [seachTextFild setTintColor:[UIColor blueColor]];
        
        self.textField = seachTextFild;
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

@end
