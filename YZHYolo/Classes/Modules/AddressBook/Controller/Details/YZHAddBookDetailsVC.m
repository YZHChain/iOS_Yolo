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

@interface YZHAddBookDetailsVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddBookUserAskFooterView* userAskFooterView;
@property (nonatomic, strong) UIButton* addFriendButton;
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
    if ([[[[NIMSDK sharedSDK] loginManager] currentAccount] isEqualToString:self.userId] == NO && [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId] == YES) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(clickRightItemGotoSetting) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.isSearch) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBar_background_image"] forBarMetrics:UIBarMetricsDefault];
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
    
    //TODO: 计算高度.
    self.tableView.tableFooterView = self.userAskFooterView;
    [self.userAskFooterView.sendMessageButton addTarget:self action:@selector(senderMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    //暂时不考虑, 添加好友状态.
    //如果是自己的个人详情,则。
    if (self.isMySelf) {
        //清空表尾
//        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    
    [self.tableView reloadData];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    _userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
    //从群聊进来, 并且非好友关系。
    if (self.isTeam && !self.isMyFriend) {
        [self fetchUserData];
    } else { //非群聊进入
        if (!self.isMySelf && !self.isMyFriend) {
            //先判断此用户为自己好友.否则需要到 IM 去拉取最新状态
            [self fetchUserData];
        } else {
            [self refresh];
        }
    }
}
// 拉取用户最新数据, 并且刷新
- (void)fetchUserData {
    //先判断此用户为自己好友.否则需要到 IM 去拉取最新状态
    _userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
    //拉取最新
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[_userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        @strongify(self)
        if (!error) {
            [self refresh];
        }
        [hud hideWithText:nil];
    }];
}

- (void)refresh {
    
    if (self.isTeam && !self.isMyFriend) { // 刷新从群聊页面进入的个人详情
        [self teamMemberDeailsRefresh];
    } else { //刷新从非群聊页面进入的个人详情
        [self userDeailsRefresh];
    }
}

- (void)teamMemberDeailsRefresh {
    
    YZHTeamExtManage* teamExt = [YZHTeamExtManage targetTeamExtWithTeamId:_teamId targetId:_userId];
    if (teamExt.team_add_friend) {
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
        self.addFriendButton = addFriendButton;
        
        [self.userAskFooterView addSubview:addFriendButton];
        self.tableView.tableFooterView = self.userAskFooterView;
    } else {
        [self.addFriendButton removeFromSuperview];
    }
    if (teamExt.team_p2p_chat) {
        
        self.userAskFooterView.sendMessageButton.hidden = NO;
        //区别临时聊天功能.
        
    } else {
        self.userAskFooterView.sendMessageButton.hidden = YES;
    }
}

- (void)userDeailsRefresh {
    
    if (!self.isMySelf) {
        [self setupNavBar];
        self.userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
        // 判断是否为好友,
        self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
        
        if (self.isMyFriend) {
            if (self.addFriendButton.superview) {
                [self.addFriendButton removeFromSuperview];
                self.tableView.tableFooterView = self.userAskFooterView;
            }
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
                self.addFriendButton = addFriendButton;
                
                [self.userAskFooterView addSubview:addFriendButton];
                self.tableView.tableFooterView = self.userAskFooterView;
            }
        }
        [self.tableView reloadData];
    } else {
        _userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
        [self.tableView reloadData];
    }
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
    if ([model.title isEqualToString:@"聊天内容"]) {
        [YZHRouter openURL:model.router info:@{
                                                @"targetId": self.userId,
                                               }];
        
    } else {
        if (model.canSkip) {
            
            [YZHRouter openURL:model.router info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES),
                                                   @"userDetailsModel": self.userDetailsModel
                                                   }];
        }
    }

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

}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
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

