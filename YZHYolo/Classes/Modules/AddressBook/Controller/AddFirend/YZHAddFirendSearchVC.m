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

@interface YZHAddFirendSearchVC ()<UITableViewDelegate, UITableViewDataSource, YZHPhoneContactCellProtocol>

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
    self.navigationItem.title = @"";
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
            // 本地无数据
            if (!user.userInfo) {
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
                    [self.tableView reloadData];
                    [hud hideWithText:error.domain];
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
    
    if (self.searchStatus == YZHAddFirendSearchStatusSucceed) {
        //跳转至用户详情页
    }
    if (self.searchStatus == 0 && self.viewModel.allowAdd) {
       //跳转至用户详情页
//        [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{
//                                                               @"userId":self.viewModel.userId
//                                                               }];
        
//        YZHAddBookDetailsVC* detailsVC = [[YZHAddBookDetailsVC alloc] init];
//        detailsVC.userId = self.viewModel.userId;
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:detailsVC animated:YES completion:^{
//
//        }];
    }
    YZHAddBookDetailsVC* detailsVC = [[YZHAddBookDetailsVC alloc] init];
    detailsVC.userId = self.viewModel.userId;
    NSLog(@"当前跟控制器%@",[UIApplication sharedApplication].keyWindow.rootViewController);
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:detailsVC animated:YES completion:^{
        
    }];
//    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:detailsVC animated:YES];
}

- (void)onSelectedCellButtonWithModel:(id)model {
    
    YZHAddFirendSearchModel* contactModel = model;
    if (contactModel.allowAdd) {
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = contactModel.userId;
        if (contactModel.needVerfy) {
            request.operation = NIMUserOperationRequest;
            //快速添加文案.
            request.message = @"请求添加";
            request.operation = NIMUserOperationRequest;
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

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

#pragma mark - 7.GET & SET

- (YZHAddFirendSearchModel *)viewModel {

    if (!_viewModel) {
        _viewModel = [[YZHAddFirendSearchModel alloc] init];
    }
    return _viewModel;
}

@end
