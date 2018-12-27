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
#import "YZHTeamExtManage.h"
#import "CYPhotoPreviewer.h"

@interface YZHAddBookDetailsVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate, YZHAddBookUserIDCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddBookUserAskFooterView* userAskFooterView;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExtManage;
@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, assign) BOOL needAddVerify;
@property (nonatomic, assign) BOOL isMySelf;

@end

@implementation YZHAddBookDetailsVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNIMConfig];

    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    
    [self setupData];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)setUpNIMConfig {
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"详情资料";
    // 不是自己,并且是我的好友时,才会有更多选项
    if (self.isMyFriend && !self.isMySelf) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(clickRightItemGotoSetting) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] forState:UIControlStateNormal];
        [rightButton sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.isSearch) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCandel:)];
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
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)reloadView
{
     [self userDeailsRefresh];
     [self setupNavBar];
}

#pragma mark - 3.Request Data

- (void)setupData
{
    _userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
    //从群聊进来, 并且非好友关系。
    if (self.isMyFriend) {
       [self reloadView];
    } else {
       [self fetchUserData];
    }
}
// 拉取用户最新数据, 并且刷新
- (void)fetchUserData {
    //先判断此用户为自己好友.否则需要到 IM 去拉取最新状态
    //拉取最新
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[_userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        @strongify(self)
        if (!error) {
            [self reloadView];
        } else {
//            if (error.code != 408) {
            [self refreshError:error];
//            }
        }
        [hud hideWithText:nil];
    }];
}

- (void)refreshError:(NSError *)error {
    
    [self userDeailsRefreshError:error];
}

- (void)userDeailsRefresh {
    
    if (!self.isMySelf) {
        self.userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
        [self.tableView setTableFooterView:self.userAskFooterView];
        @weakify(self)
        self.userAskFooterView.addFriendBlock = ^(UIButton *sender) {
            @strongify(self)
            [self addFriendRequst:sender];
        };
        self.userAskFooterView.senderMessageBlock = ^(UIButton *sender) {
            @strongify(self)
            [self senderMessage:sender];
        };
        // 判断是否为好友,
        self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
        if (self.isMyFriend) {
            self.userAskFooterView.addFriendButton.hidden = YES;
//            [self.userAskFooterView.addFriendButton removeFromSuperview];
            self.userAskFooterView.sendMessageButton.hidden = NO;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
            BOOL allowAdd = self.userInfoExtManage.privateSetting.allowAdd;
            //非好友时, 隐藏发消息
            self.userAskFooterView.sendMessageButton.hidden = YES;
            if (allowAdd) {
                self.userAskFooterView.addFriendButton.hidden = NO;
            } else {
                self.userAskFooterView.addFriendButton.hidden = YES;
            }
        }
        [self.tableView reloadData];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        _userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
        [self.tableView setTableFooterView:[[UIView alloc] init]];
        [self.tableView reloadData];
    }
}

- (void)userDeailsRefreshError:(NSError* )error {
    
    [self.tableView setTableFooterView:self.userAskFooterView];
    [self.userAskFooterView.sendMessageButton setTitle:@"未找到该用户" forState:UIControlStateNormal];
    self.userAskFooterView.sendMessageButton.enabled = NO;
    self.userAskFooterView.addFriendButton.hidden = YES;
    self.userAskFooterView.sendMessageButton.hidden = NO;
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
        cell.delegate = self;
        
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
    //点击头像
    if (indexPath.section == 0) {
        return;
    }
    
    YZHAddBookDetailModel* model = self.userDetailsModel.viewModel[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"聊天内容"]) {
        [YZHRouter openURL:model.router info:@{
                                                @"targetId": self.userId,
                                                @"isTeam": @(NO)
                                               }];
        
    } else {
        if (model.canSkip) {
            
            [YZHRouter openURL:model.router info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES),
                                                   @"userDetailsModel": self.userDetailsModel
                                                   }];
        }
    }

}

#pragma mark - protocol

- (void)onTouchPicImageView:(UIImageView *)imageView {
    
    CYPhotoPreviewer *previewer = [[CYPhotoPreviewer alloc] init];
    
    [previewer previewFromImageView:imageView inContainer:YZHAppWindow];
}

#pragma mark - 5.Event Response

- (void)clickRightItemGotoSetting {
    
    [YZHRouter openURL:kYZHRouterAddressBookSetting info:@{
                                                           @"userId": self.userId
                                                           }];
}

- (void)clickCandel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)senderMessage:(UIButton *)sender {
    
    //TODO: 需要区分,是否是群进来的, 如果是群进来, 并且处于非好友状态则需要给这个回话添加一个标记, 表示其是临时会话.
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:session];
    [self.navigationController pushViewController:privateChatVC animated:YES];
}

- (void)addFriendRequst:(UIButton *)sender {
    
    BOOL needAddVerify = self.userInfoExtManage.privateSetting.addVerify;
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = self.userId;
    if (needAddVerify) {
        //跳转至填写验证消息
        [YZHRouter openURL:kYZHRouterAddressBookAddFirendSendVerify info:@{
                                                                           
                                                                           @"userId": self.userId
                                                                           }];
    } else {
        request.operation = NIMUserOperationAdd;
        NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
        NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败" : @"请求失败";
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        @weakify(self)
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
            @strongify(self)
            if (!error) {
                //添加成功文案;
                [hud hideWithText:successText];
                [self reloadView];
            }else{
                [hud hideWithText:failedText];
            }
        }];
    }

}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - NIMUserManagerDelegate

- (void)onFriendChanged:(NIMUser *)user {
    
    if ([self.userId isEqualToString:user.userId]) {
        [self reloadView];
    }
}

- (void)onUserInfoChanged:(NIMUser *)user {
    
    if ([self.userId isEqualToString:user.userId]) {
        [self reloadView];
    }
}

#pragma mark - 7.GET & SET

- (YZHAddBookUserAskFooterView *)userAskFooterView {
    
    if (!_userAskFooterView) {
        _userAskFooterView = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookUserAskFooterView" owner:nil options:nil].lastObject;
        _userAskFooterView.frame = CGRectMake(0, 0, self.tableView.width, 250);
        _userAskFooterView.autoresizingMask = NO;
    }
    return _userAskFooterView;
}

- (YZHUserInfoExtManage *)userInfoExtManage {
    
    if (!_userInfoExtManage) {
        _userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:self.userId];
    }
    return _userInfoExtManage;
}

- (BOOL)isMySelf {
    
    if ([[[[NIMSDK sharedSDK] loginManager] currentAccount] isEqualToString:self.userId]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMyFriend {
    
    return [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
}

@end

