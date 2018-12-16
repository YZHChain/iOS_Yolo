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
#import "YZHUserLoginManage.h"

static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
@interface YZHAddBookPhoneContactVC ()<UITableViewDelegate, UITableViewDataSource, YZHPhoneContactCellProtocol>

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
    //TODO:在进入这个页面时,应该异步去请求所有在平台内成员信息

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
    
    [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_PERSON(PATH_PERSON_MOBILEFRIENDS) params:self.contactModel.params successCompletion:^(id obj) {
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
            //TODO:可以在这里异步请求所有在当前平台的用户实时信息.可以防止通过手机联系人添加时跳过验证的步骤. 否则无法判断当前用户是否开启需要验证的权限.
            
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
    //根据 Model 状态还选择 Cell 类型,分两种一种是 Label,一种是 Button
    YZHPhoneContactCell* cell = [YZHPhoneContactCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:model.status];
    cell.contactModel = model;
    if (model.status == 0 || model.status == 2) {
        cell.delegate = self;
    } else {
        cell.delegate = nil;
    }
    
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
    
    NSArray* contactContents = self.contactModel.phoneContactList[indexPath.section];
    YZHAddBookPhoneContactModel* model = contactContents[indexPath.row];
    
    if (model.status != 2) {
        //跳转至用户详情页
        [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{
                                                               @"userId":model.accid
                                                               }];
    }
}

- (void)onSelectedCellButtonWithModel:(id)model {
    
    //TODO:
    YZHAddBookPhoneContactModel* contactModel = model;
    if (contactModel.status == 0) {
        //快速添加
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = contactModel.accid;
        //TODO:这里读取的需要验证,并不是最新的,需要和产品确认.
        if (contactModel.needVerfy) {
            //TODO:快速添加文案.
            request.message = @"通过手机联系人,请求添加好友";
            request.operation = NIMUserOperationRequest;
        } else {
            request.operation = NIMUserOperationAdd;
        }
        NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
        NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败,请重试" : @"请求失败,请重试";
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [hud hideWithText:successText];
            }else{
                [hud hideWithText:failedText];
            }
        }];
        
    } else if (contactModel.status == 2) {
        //邀请当前用户
        NSString* userId = [[YZHUserLoginManage sharedManager] currentLoginData].userId;
        NSDictionary* dic = @{
                              @"phoneNum": contactModel.phone,
                              @"userId": userId
                              };
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        [[YZHNetworkService shareService] POSTNetworkingResource:SERVER_LOGIN(PATH_PERSON_INVITE_SENDSMS) params:dic successCompletion:^(NSObject* obj) {
            //TODO: 邀请成功
            [hud hideWithText: obj.yzh_apiDetail];
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:error.domain];
        }];
       
    }
    
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
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
