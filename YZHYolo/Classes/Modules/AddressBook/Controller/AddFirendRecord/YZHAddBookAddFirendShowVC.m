//
//  YZHAddBookAddFirendShowVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendShowVC.h"

#import "YZHAddBookUserIDCell.h"
#import "YZHAddBookSettingCell.h"
#import "YZHAddFriendShowFooterView.h"
#import "YZHAddBookSetTagVC.h"
#import "YZHBaseNavigationController.h"
#import "YZHAddFirendSubtitleCell.h"
#import "YZHPrivateChatVC.h"
#import "YZHProgressHUD.h"
#import "YZHAddBookAddFirendRecordCell.h"
#import "UIButton+YZHTool.h"
#import "YZHUserModelManage.h"

@interface YZHAddBookAddFirendShowVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddFriendShowFooterView* userAskFooterView;
@property (nonatomic, assign) BOOL isMyFriend;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExtManage;

@end

@implementation YZHAddBookAddFirendShowVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self NIMConfig];
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
    [self refresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)NIMConfig {
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"详情资料";
    
    // 不是自己,并且是我的好友时,才会有更多选项
    if ([[[[NIMSDK sharedSDK] loginManager] currentAccount] isEqualToString:self.userId] == NO && [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId] == YES) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(clickRightItemGotoSetting) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItemGotoSetting)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.userAskFooterView.agreeButton addTarget:self action:@selector(handleAddFirendMessage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refresh {
    
    [self setupData];
    [self reloadView];
}

//根据当前好友关系, 消息状态与类型来展示当前页面下的按钮状态。
- (void)reloadView {
    
    [self setupNavBar];
    self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
    if (!self.isMyFriend) {
        if (self.addFriendNotification.handleStatus == 0) {
            if (self.messageTimeout == NO) {
                [self notFriendButtonStatus]; //addFriendReply
            } else {
                [self notFriendMessageTimeoutButtonStatus]; //
            }
        } else {
           //TODO同意过,但是又被删掉了. 如何显示。 直接在外层进行处理, 不会进入到这个逻辑. 处理过的消息直接进入消息详情里.
            [self.userAskFooterView.agreeButton setTitle:@"加为好友" forState:UIControlStateNormal];
            [self.userAskFooterView.agreeButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.userAskFooterView.agreeButton setTitleColor:YZHColorRGBAWithRGBA(62, 58, 57, 1) forState:UIControlStateNormal];
            self.userAskFooterView.agreeButton.tag = 2;
        }
    } else {
        // 当前是好友状态.
        [self isFriendButtonStatus];
    }
    //暂时不考虑, 添加好友状态.
    //如果是自己的个人详情,则。
    if ([[[[NIMSDK sharedSDK] loginManager] currentAccount] isEqualToString:self.userId]) {
        //清空表尾
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    //TODO: 计算高度.
    self.tableView.tableFooterView = self.userAskFooterView;
    [self.tableView reloadData];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    //先判断此用户为自己好友.否则需要到 IM 去拉取最新状态
    self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
    _userDetailsModel = [[YZHAddBookAddFirendShowModel alloc] initDetailsModelWithUserId:self.userId addMessage:self.addMessage
                                                                                isMySend:self.isMySend];
    if (_isMyFriend) {
    } else {
        //拉取最新
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        @weakify(self)
        [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[_userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            @strongify(self)
            if (!error) {
                [self reloadView];
            }
            [hud hideWithText:nil];
        }];
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.userDetailsModel.viewModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.userDetailsModel.viewModel[section].count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHAddBookDetailModel* model = self.userDetailsModel.viewModel[indexPath.section][indexPath.row];
    if (model.canSkip) {
        
        [YZHRouter openURL:model.router info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES),
                                               @"userDetailsModel": self.userDetailsModel
                                               }];
    }
}

#pragma mark - 5.Event Response

- (void)handleAddFirendMessage:(UIButton* )sender {
    
    switch (sender.tag) {
        case 0:
            [self addFriendReply];
            break;
        case 1:
            [self sendMessage];
            break;
        case 2:
            [self addFriendRequst];
            break;
        default:
            [self sendMessage];
            break;
    }

}

- (void)clickRightItemGotoSetting {
    
    [YZHRouter openURL:kYZHRouterAddressBookSetting info:@{
                                                           @"userId": self.userId
                                                           }];
}

#pragma mark - 6.Private Methods

//非好友, 收到对方消息自己未操作过, 消息在有效期。
- (void)notFriendButtonStatus {
    
    [self.userAskFooterView.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.userAskFooterView.agreeButton yzh_setBackgroundColor:YZHColorRGBAWithRGBA(42, 107, 250, 1) forState:UIControlStateNormal];
    self.userAskFooterView.agreeButton.tag = 0;
}

- (void)addFriendReply {
    
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = self.addFriendNotification.sourceID;
    request.operation = NIMUserOperationVerify;
    @weakify(self)
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    [[[NIMSDK sharedSDK] userManager] requestFriend:request
                                         completion:^(NSError *error) {
                                             @strongify(self)
                                             if (!error) {
                                                 [hud hideWithText:@"验证成功"];
                                                 self.addFriendNotification.handleStatus = YZHNotificationHandleTypeOk;
                                                 [self reloadView];
                                             }
                                             else
                                             {
                                                 [hud hideWithText:@"验证失败"];
                                             }
                                         }];
}

//已经是好友, 按钮展示状态, 相当于是自己没有开启好友验证, 直接收到对方添加好友的自己已经同意消息。
- (void)isFriendButtonStatus {
    
    [self.userAskFooterView.agreeButton setTitle:@"发消息" forState:UIControlStateNormal];
    [self.userAskFooterView.agreeButton yzh_setBackgroundColor:YZHColorRGBAWithRGBA(42, 107, 250, 1) forState:UIControlStateNormal];
    self.userAskFooterView.agreeButton.tag = 1;
}

- (void)sendMessage {
    
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:session];
    [self.navigationController pushViewController:privateChatVC animated:YES];
}
//非好友, 收到对方消息自己未操作过, 并且消息已超时 45天。
- (void)notFriendMessageTimeoutButtonStatus {
    
    //按钮还需要根据对方用户的隐私设置来显示.TODO 这里直接通过这种方式读取到的 TargetUser 不是最新的.
    if (self.userInfoExtManage.privateSetting.allowAdd) {
        [self.userAskFooterView.agreeButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [self.userAskFooterView.agreeButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.userAskFooterView.agreeButton setTitleColor:YZHColorRGBAWithRGBA(62, 58, 57, 1) forState:UIControlStateNormal];
        self.userAskFooterView.agreeButton.tag = 2;
    }
}
//TODO: 封装
- (void)addFriendRequst {
    
    BOOL needAddVerify = self.userInfoExtManage.privateSetting.addVerift;
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId = self.userId;
    if (needAddVerify) {
        //跳转至填写验证消息
        [YZHRouter openURL:kYZHRouterAddressBookAddFirendSendVerify info:@{
                                                                           kYZHRouteSegue:kYZHRouteSegueModal,
                                                                           @"userId": self.userId
                                                                           }];
    } else {
        request.operation = NIMUserOperationAdd;
        NSString *successText =  @"添加成功";
        NSString *failedText = @"添加失败,请重试";
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

#pragma mark - NIMUserManagerDelegate

- (void)onFriendChanged:(NIMUser *)user {

    if ([self.userId isEqualToString:user.userId]) {
        [self refresh];
    }
}

- (void)onUserInfoChanged:(NIMUser *)user {

    if ([self.userId isEqualToString:user.userId]) {
        [self refresh];
    }
}

#pragma mark - 7.GET & SET

- (YZHAddFriendShowFooterView *)userAskFooterView {
    
    if (!_userAskFooterView) {
        _userAskFooterView = [[NSBundle mainBundle] loadNibNamed:@"YZHAddFriendShowFooterView" owner:nil options:nil].lastObject;
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
