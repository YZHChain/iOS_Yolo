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
#import <AddressBook/AddressBook.h>
#import "PPGetAddressBook.h"
#import "YZHAddBookPhoneContactModel.h"
#import "YZHPublic.h"
#import "YZHAddBookSectionView.h"

static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
@interface YZHAddBookPhoneContactVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHPhoneContactDefaultView* defaultView;
@property (nonatomic, assign) BOOL hasPhonePermissions;
@property (nonatomic, strong) YZHPhoneContactRequestModel* contactModel;

@end

@implementation YZHAddBookPhoneContactVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestReadPhoneAddbookAuthority];
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
    
    self.navigationItem.title = @"手机联系人";
    
//    if (self.hasPhonePermissions == NO) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"获取" style:UIBarButtonItemStylePlain target:self action:@selector(readPhoneContact:)];
//    }

}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
}

#pragma mark - 3.Request Data

- (void)setupData {

    if (self.hasPhonePermissions) {
        
        [self readPhoneAddressBook];
        [self.view addSubview:self.tableView];
    } else {
        [self.view addSubview:self.defaultView];
    }
}

- (void)readPhoneAddressBook {
    
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        [self.contactModel updataPhoneContactDataWithNameKeys:nameKeys addressBookDict:addressBookDict];
        [self requestNetworking];
    } authorizationFailure:^{
        //读取失败
    }];
    
    
}

- (void)requestNetworking {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_FRIENDS_MOBILEFRIENDS params:self.contactModel.params successCompletion:^(id obj) {
        [hud hideWithText:nil];
        if (obj) {
            NSArray* contactArray = [obj mj_JSONObject];
            [self.contactModel sortPhoneContacts:contactArray];
            if (!self.tableView.superview) {
                [self.view addSubview:self.tableView];
            }
            if (self.defaultView.superview) {
                [self.defaultView removeFromSuperview];
            }
            //获取到数据之后,删除获取按钮.
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView reloadData];
        }
    } failureCompletion:^(NSError *error) {
        
        [hud hideWithText:error.domain];
    }];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.contactModel.sortedGroupTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray* contactContents = self.contactModel.phoneContactList[section];
    return contactContents.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray* contactContents = self.contactModel.phoneContactList[indexPath.section];
    YZHAddBookPhoneContactModel* model = contactContents[indexPath.row];
    //根据 Model 状态还选择 Cell 类型,分两种一种是 Labelm,一种是 Button
    YZHPhoneContactCell* cell = [YZHPhoneContactCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:model.status];
    cell.contactModel = model;
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
     YZHAddBookSectionView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHAddBookSectionViewIdentifier];
    headerView.titleLabel.text = self.contactModel.sortedGroupTitles[section];
    
    return headerView;
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

    [self requestReadPhoneAddbookAuthority];
    if (self.hasPhonePermissions) {
        [self readPhoneAddressBook];
    } else {
        // TODO:兼容性待测试 跳转至设置
        [YZHAlertManage showAlertTitle:@"您未对 Yolo 开启通讯录读取权限" message:@"请前往设置页面授权 Yolo 通讯录读取权限" actionButtons:@[@"取消", @"去设置"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
            }
        }];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)requestReadPhoneAddbookAuthority {
    // 判断当前的授权状态是否是用户还未选择的状态
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRef bookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
                self.hasPhonePermissions = YES;
            }
            else
            {
                self.hasPhonePermissions = NO;
            }
        });
    } else {
        //用户已授权.
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            self.hasPhonePermissions = YES;
        } else {
            // 未授权
            self.hasPhonePermissions = NO;
        }
    }
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
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
    }
    return _tableView;
}

- (YZHPhoneContactDefaultView *)defaultView {
    
    if (!_defaultView) {
        _defaultView = [YZHPhoneContactDefaultView yzh_viewWithFrame:self.view.bounds];
    }
    return _defaultView;
}

- (YZHPhoneContactRequestModel *)contactModel {
    
    if (!_contactModel) {
        _contactModel = [[YZHPhoneContactRequestModel alloc] init];
    }
    return _contactModel;
}

@end
