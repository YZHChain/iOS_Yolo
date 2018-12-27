//
//  YZHTeamMemberDetailsVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/24.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberDetailsVC.h"

#import "YZHAddBookUserIDCell.h"
#import "YZHAddBookSettingCell.h"
#import "YZHAddBookSetTagVC.h"
#import "YZHAddFirendSubtitleCell.h"
#import "YZHPrivateChatVC.h"
#import "YZHUserModelManage.h"
#import "YZHProgressHUD.h"
#import "UIButton+YZHTool.h"
#import "YZHTeamExtManage.h"
#import "YZHTeamInfoExtManage.h"
#import "CYPhotoPreviewer.h"
#import "YZHTeamMemberFooterView.h"
#import "YZHTeamMmemberDefaultFooterView.h"

@interface YZHTeamMemberDetailsVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate, YZHAddBookUserIDCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddBookDetailsModel* userDetailsModel;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExtManage;
@property (nonatomic, strong) YZHTeamExtManage* teamExt;
@property (nonatomic, strong) YZHTeamInfoExtManage* teamInfoExt;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) YZHTeamMemberFooterView* footerView;
@property (nonatomic, strong) YZHTeamMmemberDefaultFooterView* tipFooterView;

@end

@implementation YZHTeamMemberDetailsVC


#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNIMConfig];
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

- (void)setUpNIMConfig {
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"详情资料";
    
//    [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId] == YES
    if (![[NIMSDK sharedSDK].loginManager.currentAccount isEqualToString:self.userId]) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(clickRightItemGotoSetting) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] forState:UIControlStateNormal];
        [rightButton sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
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
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)reloadView {
    
    NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId];
    BOOL isTeamManage = [team.owner isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount];
    BOOL allowAddAndChat = YES;
    if (YZHIsString(self.teamInfoExt.addAndChat)) {
        if ([self.teamInfoExt.addAndChat isEqualToString:@"0"]) {
            allowAddAndChat = NO;
        }
    }
    if (allowAddAndChat || isTeamManage) {
        //群主可直接
        if (self.teamExt.team_hide_info && !isTeamManage) {
            [self hideTeamMemberDetails];
        } else {
            [self showTeamMemberDetails];
        }
    } else {
        if (isTeamManage) {
            if (self.teamExt.team_hide_info) {
                [self hideTeamMemberDetails];
            } else {
                [self showTeamMemberDetails];
            }
        } else {
            [self hideTeamMemberDetails];
        }
    }
}

- (void)refreshFooterView {
    
    [self.tableView setTableFooterView:self.footerView];
    BOOL isMyFriend = [[[NIMSDK sharedSDK] userManager] isMyFriend:self.userId];
    if (isMyFriend) {
        [self.footerView.addFriendButton removeFromSuperview];
    } else {
        if (self.userInfoExtManage.privateSetting.allowAdd) {
            [self.footerView addSubview:self.footerView.addFriendButton];
        } else {
            [self.footerView removeFromSuperview];
        }
    }
    
    @weakify(self)
    _footerView.addFriendBlock = ^(UIButton *sender) {
        @strongify(self)
        [self addFriend];
    };
    _footerView.senderMessageBlock = ^(UIButton *sender) {
        @strongify(self)
        [self senderMessage];
    };
}

- (void)showTeamMemberDetails {
    
    self.tableView.hidden = NO;
    //这块需要做点儿调整,专门对群组在配置一个 Model.
    self.userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
    [self refreshFooterView];
    [self.tableView reloadData];
    [self.tipLabel removeFromSuperview];
}

- (void)hideTeamMemberDetails {
    
    self.tableView.hidden = YES;
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(80);
    }];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.teamInfoExt = [[YZHTeamInfoExtManage alloc] initTeamExtWithTeamId:self.teamId];
    self.teamExt = [YZHTeamExtManage targetTeamExtWithTeamId:self.teamId targetId:self.userId];
    self.userInfoExtManage = [YZHUserInfoExtManage targetUserInfoExtWithUserId:self.userId];
    self.userDetailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:self.userId];
    BOOL isMyfriend = [[NIMSDK sharedSDK].userManager  isMyFriend:self.userId];
    if (!isMyfriend) {
        [self fetchUserData];
    } else {
        [self reloadView];
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
            [self refreshError:error];
        }
        [hud hideWithText:nil];
    }];
}

- (void)refreshError:(NSError *)error {
    
    [self.footerView removeFromSuperview];
    [self.tableView reloadData];
    [self.tableView setTableFooterView:self.tipFooterView];
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

- (void)addFriend {
    
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
                [self setupNavBar];
            }else{
                
                [hud hideWithText:failedText];
            }
        }];
    }
}

- (void)senderMessage {
    
    //TODO: 需要区分,是否是群进来的, 如果是群进来, 并且处于非好友状态则需要给这个回话添加一个标记, 表示其是临时会话.
    NIMSession *session = [NIMSession session:self.userId type:NIMSessionTypeP2P];
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:session];
    [self.navigationController pushViewController:privateChatVC animated:YES];
}

- (void)clickRightItemGotoSetting {
    
    [YZHRouter openURL:kYZHRouterAddressBookSetting info:@{
                                                           @"userId": self.userId
                                                           }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
        _tipLabel.textColor = [UIColor yzh_fontShallowBlack];
        _tipLabel.text = @"用户信息不可见";
    }
    return _tipLabel;
}

- (YZHTeamMemberFooterView *)footerView {
    
    if (!_footerView) {
        _footerView = [YZHTeamMemberFooterView yzh_viewWithFrame:CGRectMake(0, 0, self.tableView.width, 250)];
        _footerView.autoresizingMask = NO;
        [self.tableView addSubview:_footerView];
    }
    return _footerView;
}

- (YZHTeamMmemberDefaultFooterView *)tipFooterView {
    
    if (!_tipFooterView) {
        _tipFooterView = [YZHTeamMmemberDefaultFooterView yzh_viewWithFrame:CGRectMake(0, 0, self.tableView.width, 250)];
        _tipFooterView.autoresizingMask = NO;
        [self.tableView addSubview:_tipFooterView];
    }
    return _tipFooterView;
}

@end
