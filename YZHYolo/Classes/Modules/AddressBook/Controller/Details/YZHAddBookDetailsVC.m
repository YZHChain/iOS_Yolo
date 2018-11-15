//
//  YZHAddBookDetailsVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookDetailsVC.h"

#import "YZHAddBookUserIDCell.h"
#import "YZHAddBookSettingCell.h"
#import "YZHAddBookUserAskFooterView.h"
#import "YZHAddBookSetTagVC.h"
#import "YZHBaseNavigationController.h"
#import "YZHAddFirendSubtitleCell.h"
#import "YZHPrivateChatVC.h"
#import "YZHUserModelManage.h"
#import "YZHProgressHUD.h"
#import "UIButton+YZHTool.h"

@interface YZHAddBookDetailsVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddBookUserAskFooterView* userAskFooterView;
@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExtManage;

@end

@implementation YZHAddBookDetailsVC
#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NIMConfig];
    
    [self setupData];
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)NIMConfig {
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"详情资料";
//    TODO:
    if ([[[[NIMSDK sharedSDK] loginManager] currentAccount] isEqualToString:self.userId] == NO && [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId] == YES) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(clickRightItemGotoSetting) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //TODO: 计算高度.
    self.tableView.tableFooterView = self.userAskFooterView;
    [self.userAskFooterView.sendMessageButton addTarget:self action:@selector(senderMessage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    if (!_userDetailsModel) {
        _userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
        @weakify(self)
        _userDetailsModel.updataBlock = ^{
            @strongify(self)
            [self refresh];
        };
    }
}

- (void)refresh {
    // 判断是否为好友,
    self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
    if (self.isMyFriend) {
        
    } else {
        BOOL allowAdd = self.userInfoExtManage.privateSetting.allowAdd;
        if (allowAdd) {
            UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeSystem];
            addFriendButton.size = self.userAskFooterView.sendMessageButton.size;
            addFriendButton.x = self.userAskFooterView.sendMessageButton.x;
            addFriendButton.y = self.userAskFooterView.sendMessageButton.bottom + 10;
            addFriendButton.layer.cornerRadius = 5;
            addFriendButton.layer.masksToBounds = YES;
            [addFriendButton addTarget:self action:@selector(addFriendRequst:) forControlEvents:UIControlEventTouchUpInside];
            [addFriendButton setTitle:@"加好友" forState:UIControlStateNormal];
            [addFriendButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:18]];
            [addFriendButton setTintColor:[UIColor yzh_fontShallowBlack]];
            [addFriendButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            addFriendButton.size = self.userAskFooterView.sendMessageButton.size;
            
            [self.userAskFooterView addSubview:addFriendButton];
            self.tableView.tableFooterView = self.userAskFooterView;
        }
    }
    //暂时不考虑, 添加好友状态.
    //如果是自己的个人详情,则。
    if ([[[[NIMSDK sharedSDK] loginManager] currentAccount] isEqualToString:self.userId]) {
        //清空表尾
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.userDetailsModel.viewModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.userDetailsModel.viewModel[section].count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id cellData = self.userDetailsModel.viewModel[indexPath.section][indexPath.row];
    // 配置Cell
    if (indexPath.section == 0) {
        static NSString* cellId = @"YZHAddBookUserIDCell";
        YZHAddBookUserIDCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookUserIDCell" owner:nil options:nil].lastObject;
        }
        cell.model = cellData;
        
        return cell;
    } else {
        YZHAddBookDetailModel* model = cellData;
        YZHAddBookSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:model.cellClass];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:model.cellClass owner:nil options:nil].lastObject;
        }
        cell.model = cellData;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id cellData = self.userDetailsModel.viewModel[indexPath.section][indexPath.row];
    YZHAddBookDetailModel* model = cellData;
    
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHAddBookDetailModel* model = self.userDetailsModel.viewModel[indexPath.section][indexPath.row];
    if (model.canSkip) {
        
        [YZHRouter openURL:model.router info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES),
                                               @"userDetailsModel": self.userDetailsModel
                                               }];
    }
}

#pragma mark - 5.Event Response

- (void)clickRightItemGotoSetting {
    
    [YZHRouter openURL:kYZHRouterAddressBookSetting info:@{
                                                           @"userId": self.userId
                                                           }];
}

- (void)senderMessage:(UIButton *)sender {
    
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:session];
    [self.navigationController pushViewController:privateChatVC animated:YES];
}

- (void)addFriendRequst:(UIButton *)sender {
    
    BOOL needAddVerify = self.userInfoExtManage.privateSetting.addVerift;
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = self.userId;
    if (needAddVerify) {
        //跳转至填写验证消息
        [YZHRouter openURL:kYZHRouterAddressBookAddFirendSendVerify info:@{
                                                                           
                                                                           @"userId": self.userId
                                                                           }];
    } else {
        request.operation = NIMUserOperationAdd;
    }
    NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
    NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败" : @"请求失败";
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
        @strongify(self)
        if (!error) {
            //添加成功文案;
            [hud hideWithText:successText];
            [self refresh];
        }else{
            
            [hud hideWithText:failedText];
        }
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (YZHAddBookUserAskFooterView *)userAskFooterView {
    
    if (!_userAskFooterView) {
        _userAskFooterView = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookUserAskFooterView" owner:nil options:nil].lastObject;
    }
    return _userAskFooterView;
}

- (YZHUserInfoExtManage *)userInfoExtManage {
    
    if (!_userInfoExtManage) {
        _userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:self.userId];
    }
    return _userInfoExtManage;
}

@end

