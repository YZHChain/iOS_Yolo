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
    [self setupData];
    //4.设置通知
    [self setupNotification];
    
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
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self reloadView];
}

- (void)reloadView {
    self.isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
    if (!self.isMyFriend) {
        if (self.addFriendNotification.handleStatus == 0) {
            if (self.messageTimeout == NO) {
                [self.userAskFooterView.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
                self.userAskFooterView.agreeButton.tag = 0;
            } else {
                //TODO:
                [self.userAskFooterView.agreeButton setTitle:@"加为好友" forState:UIControlStateNormal];
                [self.userAskFooterView.agreeButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.userAskFooterView.agreeButton setTitleColor:YZHColorRGBAWithRGBA(62, 58, 57, 1) forState:UIControlStateNormal];
                self.userAskFooterView.agreeButton.tag = 2;
            }
        } else {
           //TODO同意过,但是又被删掉了. 如何显示
            [self.userAskFooterView.agreeButton setTitle:@"加为好友" forState:UIControlStateNormal];
            [self.userAskFooterView.agreeButton yzh_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.userAskFooterView.agreeButton setTitleColor:YZHColorRGBAWithRGBA(62, 58, 57, 1) forState:UIControlStateNormal];
            self.userAskFooterView.agreeButton.tag = 2;
        }
    } else {
        // 当前是好友状态.
        [self.userAskFooterView.agreeButton setTitle:@"发消息" forState:UIControlStateNormal];
        self.userAskFooterView.agreeButton.tag = 1;
    }
    //TODO: 计算高度.
    self.tableView.tableFooterView = self.userAskFooterView;
    
    [self.userAskFooterView.agreeButton addTarget:self action:@selector(handleAddFirendMessage:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    [self.tableView reloadData];
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
            
            break;
    }

}

- (void)addFriendReply {
    
    if (self.messageTimeout) {
        // 请求对方添加好友.
    } else {
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
}

- (void)sendMessage {
    
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:session];
    [self.navigationController pushViewController:privateChatVC animated:YES];
}

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
            self.userAskFooterView.agreeButton.enabled = NO;
        }else{
            
            [hud hideWithText:failedText];
        }
    }];
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (YZHAddFriendShowFooterView *)userAskFooterView {
    
    if (!_userAskFooterView) {
        _userAskFooterView = [[NSBundle mainBundle] loadNibNamed:@"YZHAddFriendShowFooterView" owner:nil options:nil].lastObject;
    }
    return _userAskFooterView;
}

- (YZHAddBookAddFirendShowModel *)userDetailsModel {
    
    if (!_userDetailsModel) {
        _userDetailsModel = [[YZHAddBookAddFirendShowModel alloc] initDetailsModelWithUserId:self.userId addMessage:self.addMessage
                                                                                    isMySend:self.isMySend];
    }
    return _userDetailsModel;
}

- (YZHUserInfoExtManage *)userInfoExtManage {
    
    if (!_userInfoExtManage) {
        _userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:self.userId];
    }
    return _userInfoExtManage;
}


@end
