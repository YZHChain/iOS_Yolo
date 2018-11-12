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
#import "YZHProgressHUD.h"

@interface YZHAddFirendSearchVC ()<UITableViewDelegate, UITableViewDataSource>

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
    
    [self.view addSubview:self.reminderView];
    [self.view addSubview:self.tableView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)refreshData {
    
    if (self.searchStatus == YZHAddFirendSearchStatusSucceed) {
       __block NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:self.viewModel.userId];
        // 本地无数据
        if (!user) {
            YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
            [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[self.viewModel.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    self.viewModel.user = users.firstObject;
                    [self.viewModel configurationUserData];
                } else {
                    self.searchStatus = YZHAddFirendSearchStatusEmpty;
                }
                [hud hideWithText:error.domain];
            }];
        } else {
            self.viewModel.user = user;
            [self.viewModel configurationUserData];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchStatus == YZHAddFirendSearchStatusSucceed) {
        
        YZHPhoneContactCell* cell = [[NSBundle mainBundle] loadNibNamed:@"YZHPhoneContactCell" owner:nil options:nil].firstObject;
        //先判断是否为好友状态
        cell.searchModel = self.viewModel;
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
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchStatus == 0 && self.viewModel) {
       //跳转至用户详情页
       
    }
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (YZHAddFirendSearchModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[YZHAddFirendSearchModel alloc] init];
    }
    return _viewModel;
}



@end
