//
//  YZHCommunityListVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommunityListVC.h"

#import "NIMSessionListCell.h"
#import "NTESSessionUtil.h"

#import "YZHPublic.h"
#import "UIButton+YZHClickHandle.h"
#import "YZHExtensionFunctionView.h"
#import "JKRSearchController.h"
#import "YZHCommunitySearchVC.h"
#import "YZHRecentSessionExtManage.h"
#import "YZHPrivateChatVC.h"
#import "YZHCommunityChatVC.h"
#import "NIMAvatarImageView.h"
#import "YZHSessionListCell.h"
#import "YZHTeamListDefaultView.h"
#import "UIViewController+YZHTool.h"
#import "YZHPrivatelyChatListHeaderView.h"
#import "YZHTeamExtManage.h"
#import "YZHSessionListLockCell.h"
#import "YZHUserLoginManage.h"
#import "YZHLockCommunityListVC.h"
#import "YZHUserModelManage.h"
#import "YZHSearchView.h"
#import "AFNetworkReachabilityManager.h"
#import "YZHNetworkStatusView.h"
#import "YZHGuideViewManage.h"
#import "YZHCheckVersion.h"
#import "YZHMessageRemindManage.h"

typedef enum : NSUInteger {
    YZHTableViewShowTypeTags = 0,
    YZHTableViewShowTypeDefault,
} YZHTableViewShowType;

static YZHTableViewShowType currentShowType = YZHTableViewShowTypeTags;
static NSString* const kYZHRecentSessionsKey = @"recentSessions";
static NSString* const kYZHDefaultRecentSessionsKey = @"TeamRecentSession";
static NSString* const kYZHDefaultCellIdentifie = @"defaultCellIdentifie";
static NSString* const kYZHTagCellIdentifie = @"tagCellIdentifie";
static NSString* const kYZHLockCellIdentifie = @"lockCellIdentifie";
static NSString* const kYZHLockDefaultCellIdentifie = @"lockDefaultCellIdentifie";

@interface YZHCommunityListVC ()<NIMTeamManagerDelegate, MGSwipeTableCellDelegate>

@property (nonatomic, strong) YZHExtensionFunctionView* extensionView;

@property (nonatomic, strong) UITableView* tagsTableView;

@property (nonatomic, strong) YZHRecentSessionExtManage* recentSessionExtManage;

@property (nonatomic, strong) YZHTeamListDefaultView* defaultView;

@property (nonatomic, strong) NSMutableDictionary* headerViewDictionary;

@property (nonatomic, assign) BOOL teamLock;

@property (nonatomic, strong) YZHSearchView* searchView;
@property (nonatomic, strong) YZHSearchView* tagSearchView;
@property (nonatomic, strong) YZHNetworkStatusView* networkView;

@end

@implementation YZHCommunityListVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    
//    [[YZHCheckVersion shareInstance] checkoutTeamCurrentVersion];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //4.设置通知
    [self setupNotification];
    
    [self setupListeningNetworkStatus];
    
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    
    YZHGuideViewManage* manage = [[YZHGuideViewManage alloc] init];
    [manage startGuideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    //TODO:
    self.navigationItem.title = @"社群";
    
    @weakify(self)
    UIButton* leftButton = [UIButton yzh_setBarButtonItemWithStateNormalImageName:@"addBook_cover_leftBarButtonItem_catogory" stateSelectedImageName:@"addBook_cover_leftBarButtonItem_default" tapCallBlock:^(UIButton *sender) {
        @strongify(self)
        [self clickLeftBarSwitchType:sender];
    }];
    UIButton* rightButton = [UIButton yzh_setBarButtonItemWithImageName:@"addBook_cover_rightBarButtonItem_addFirend" tapCallBlock:^(UIButton *sender) {
        @strongify(self)
        [self clickRightBarShowExtensionFunction:sender];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)clickLeftBarSwitchType:(UIButton *)sender{
    // 按钮与选择状态切换, 只有两种状态取反即可。
    sender.selected = !sender.isSelected;
    currentShowType = !currentShowType;
    //显示扩展功能.
    if (currentShowType == YZHTableViewShowTypeTags) {
        self.tableView.hidden = YES;
        self.tagsTableView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.tagsTableView.hidden = YES;
    }
}

- (void)clickRightBarShowExtensionFunction:(UIButton *)sender{
    
    [self.extensionView showExtensionFunctionView];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    [self.tableView setTableHeaderView:self.searchView];
    [self.tableView registerClass:[YZHSessionListCell class] forCellReuseIdentifier:kYZHDefaultCellIdentifie];
    [self.tableView registerClass:[YZHSessionListLockCell class] forCellReuseIdentifier:kYZHLockCellIdentifie];
    
    // 添加分类标签列表
    [self.view addSubview:self.tagsTableView];
    [self.tagsTableView setTableHeaderView:self.tagSearchView];

    [self.tableView layoutIfNeeded];
    [self.tagsTableView layoutIfNeeded];
    //默认上锁
    self.teamLock = YES;
    self.tableView.hidden = YES;
    self.tagsTableView.hidden = NO;
    [self refreshTeamListView];
}

- (void)refreshTeamListView {
    
    if (self.recentSessions.count) {
        [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
        if (self.recentSessionExtManage.teamCurrentSessionTags.firstObject.count || self.recentSessionExtManage.TeamRecentSession.count) {
            [self.tagsTableView reloadData];
            [self.tableView reloadData];
            [self.defaultView removeFromSuperview];
        }
    } else {
        [self.view addSubview:self.defaultView];
        self.defaultView.titleLabel.text = @"您的群列表已被清空，请使用上方的【搜索我的群】\n功能查找您的群 \n(群内有新信息时也会自动展示出来）";
        self.defaultView.findTeamButton.hidden = YES;
        BOOL teamAcount = [[[NIMSDK sharedSDK] teamManager] allMyTeams].count;
        if (!teamAcount) {
            [self.view addSubview:self.defaultView];
            self.defaultView.titleLabel.text = @"您还没有群, 广场有很多优质的群 \n快去看一下吧";
            self.defaultView.findTeamButton.hidden = NO;
        }
    }
}

#pragma mark -- setupNotification

- (void)setupNotification
{
    
}

- (void)setupListeningNetworkStatus {
    
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                [self refreshNetworkViewWithStatus:NO];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self refreshNetworkViewWithStatus:YES];
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self refreshNetworkViewWithStatus:YES];
                NSLog(@"WiFi");
                break;
            default:
                [self refreshNetworkViewWithStatus:YES];
                break;
        }
    }];
    [manager startMonitoring];//开始监听
}

// 网络正常
- (void)refreshNetworkViewWithStatus:(BOOL )status {
    
    if (status) {
        if (self.networkView.superview) {
            [self.networkView removeFromSuperview];
            self.tableView.y = 0;
            self.tagsTableView.y = 0;
            self.defaultView.y = 0;
        } else {
            
        }
    } else {
        if (self.networkView.superview) {
            
        } else {
            [self.view addSubview:self.networkView];
            self.tableView.y = self.networkView.height;
            self.tagsTableView.y = self.networkView.height;
            self.defaultView.y = self.networkView.height;
        }
    }
}


#pragma mark - 5.Event Response

- (void)onTouchSearch:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterTeamChatSearch info:@{kYZHRouteSegue: kYZHRouteSegueModal ,kYZHRouteSegueNewNavigation : @(YES)}];
}

- (void)gotoLockTeamList {
    
    YZHLockCommunityListVC* lockListVC = [[YZHLockCommunityListVC alloc] initWithRecentSessionExtManage:self.recentSessionExtManage];
    if(![self.navigationController.topViewController isKindOfClass:[lockListVC class]]) {
        [self.navigationController pushViewController:lockListVC animated:YES];
    }
}
//TODO:
- (void)clickLockTeam {
    
    @weakify(self)
    [YZHAlertManage showTextAlertTitle:@"输入阅读密码解锁查看" message:nil textFieldPlaceholder:nil  actionButtons:@[@"取消", @"确认"] actionHandler:^(UIAlertController *alertController, UITextField *textField, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            @strongify(self)
            YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
            if (YZHIsString(textField.text)) {
                if ([textField.text isEqual:userInfoExt.privateSetting.groupPassword]) {
                    self.teamLock = NO;
                    [self gotoLockTeamList];
                    [self.tableView reloadData];
                    [self.tagsTableView reloadData];
                } else {
                    [YZHAlertManage showAlertMessage:@"阅读密码不正确, 请重新输入"];
                }
            } else {
                if (YZHIsString(userInfoExt.privateSetting.groupPassword)) {
                    [YZHAlertManage showAlertMessage:@"阅读密码不正确, 请重新输入"];
                } else {
                    self.teamLock = NO;
                    [self gotoLockTeamList];
                    [self.tableView reloadData];
                    [self.tagsTableView reloadData];
                }
            }
        }
    }];
}

- (void)onTouchfindTeam:(UIButton *)sender{
    //TODO: 跳转到广场 第一次跳转时
    UITabBarController* tabbarController = self.tabBarController;
    [tabbarController setSelectedViewController:tabbarController.viewControllers[3]];
}

- (void)configurationDefaultCell:(YZHSessionListCell *)cell recent:(NIMRecentSession *)recent{
    
    cell.delegate = self;
    MGSwipeButton* tipButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"team_sessionList_cellEdit_tip"] backgroundColor:YZHColorWithRGB(207, 211, 217)];
    MGSwipeButton* lockButton = [MGSwipeButton buttonWithTitle:@"群信息" backgroundColor:[UIColor yzh_fontThemeBlue]];
    cell.leftButtons = @[tipButton, lockButton];
    cell.leftSwipeSettings.transition = MGSwipeStateSwipingLeftToRight;
    cell.leftSwipeSettings.enableSwipeBounces = NO;
    [tipButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        //
        return YES;
    }];
    [lockButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        //跳转至群信息
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        BOOL isTeamOwner = NO;
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:recent.session.sessionId];
        if ([userId isEqualToString:team.owner]) {
            isTeamOwner = YES;
        }
        [YZHRouter openURL:kYZHRouterCommunityCard info:@{
                                                          @"isTeamOwner":@(isTeamOwner),
                                                          @"teamId":recent.session.sessionId
                                                          }];
        return YES;
    }];
    
    MGSwipeButton* deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor yzh_buttonBackgroundPinkRed]];
    [deleteButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        //删除掉此列表
//        [self.recentSessions removeObject:recent];
        [[[NIMSDK sharedSDK] conversationManager] deleteRecentSession:recent];
//        //TODO: 有空了在单独封装一个新增,接口.
        [self refresh];
        return YES;
    }];
    
    MGSwipeButton* classButton = [MGSwipeButton buttonWithTitle:@"设置分类" backgroundColor:YZHColorWithRGB(207, 211, 217)];
    [classButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [YZHRouter openURL:kYZHRouterCommunitySetTeamTag info:@{
                                                                @"teamId": recent.session.sessionId,
                                                                kYZHRouteSegue: kYZHRouteSegueModal,
                                                                kYZHRouteSegueNewNavigation: @(YES)
                                                                }];
        return YES;
    }];
    cell.rightButtons = @[deleteButton, classButton];
    cell.rightSwipeSettings.transition = MGSwipeStateSwipingRightToLeft;
    cell.rightSwipeSettings.enableSwipeBounces = NO;
}

- (void)configurationLockCell:(YZHSessionListLockCell *)cell recent:(NIMRecentSession *)recent {
    
    cell.delegate = self;
    MGSwipeButton* tipButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"team_sessionList_cellEdit_tip"] backgroundColor:YZHColorWithRGB(207, 211, 217)];
    NSString* title = self.teamLock ? @"解锁": @"上锁";
    MGSwipeButton* lockButton = [MGSwipeButton buttonWithTitle:title backgroundColor:[UIColor yzh_fontThemeBlue]];
    cell.leftButtons = @[tipButton, lockButton];
    cell.leftSwipeSettings.transition = MGSwipeStateSwipingLeftToRight;
    cell.leftSwipeSettings.enableSwipeBounces = NO;
    [tipButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        //
        return YES;
    }];
    @weakify(self)
    [lockButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        //解散上锁群.
        @strongify(self)
        if (self.teamLock) {
            [self clickLockTeam];
        } else {
            self.teamLock = YES;
            [self.tableView reloadData];
            [self.tagsTableView reloadData];
        }
        return YES;
    }];
    
    MGSwipeButton* deleteButton = [MGSwipeButton buttonWithTitle:@"移除所有群" backgroundColor:[UIColor yzh_buttonBackgroundPinkRed]];
    
    [deleteButton setCallback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        //解散上锁群.
        [YZHAlertManage showAlertMessage:@"此功能暂未开放, 请到群信息设置移除"];
        return YES;
    }];
    cell.rightButtons = @[deleteButton];
    cell.rightSwipeSettings.transition = MGSwipeStateSwipingRightToLeft;
    cell.rightSwipeSettings.enableSwipeBounces = NO;
}

#pragma mark -- Private Methods

- (void)refresh
{
    if (self.recentSessions.count) {
        [self.tableView reloadData];
        [self.tagsTableView reloadData];
//        [self.defaultView removeFromSuperview];
    } else {
//        [self.view addSubview:self.defaultView];
    }
}

- (void)customSortRecents:(NSMutableArray *)recentSessions
{
    for (NSInteger i = 0; i < recentSessions.count; i++) {
        NIMRecentSession* recentSession = recentSessions[i];
        if (![[[NIMSDK sharedSDK] teamManager] isMyTeam:recentSession.session.sessionId]) {
            NSLog(@"删除");
            [recentSessions removeObject:recentSession];
            i--;
        }
    }
    // 这里只需要遍历一次即可.然后等收到群通知时,在进行编译.
    for (NSInteger i = 0 ; i < recentSessions.count; i++) {
        NIMRecentSession* recentSession = recentSessions[i];
        BOOL isSessionTypeTeam = NO;
        if (recentSession.session.sessionType == NIMSessionTypeTeam) {
            isSessionTypeTeam = YES;
        }
        if (!isSessionTypeTeam) {
            [recentSessions removeObjectAtIndex:i];
            i--;
        }
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[recentSessions copy]];
    [array sortUsingComparator:^NSComparisonResult(NIMRecentSession *obj1, NIMRecentSession *obj2) {
        NSInteger score1 = [NTESSessionUtil recentSessionIsMark:obj1 type:NTESRecentSessionMarkTypeTop]? 10 : 0;
        NSInteger score2 = [NTESSessionUtil recentSessionIsMark:obj2 type:NTESRecentSessionMarkTypeTop]? 10 : 0;
        if (obj1.lastMessage.timestamp > obj2.lastMessage.timestamp)
        {
            score1 += 1;
        }
        else if (obj1.lastMessage.timestamp < obj2.lastMessage.timestamp)
        {
            score2 += 1;
        }
        if (score1 == score2)
        {
            return NSOrderedSame;
        }
        return score1 > score2? NSOrderedAscending : NSOrderedDescending;
    }];
    [self setValue:array forKey:kYZHRecentSessionsKey];
}

#pragma mark -- TableViewCell Interaction Function

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
//    if ([[[NIMSDK sharedSDK] teamManager] isMyTeam:recent.session.sessionId]) {
        YZHCommunityChatVC* teamchatVC = [[YZHCommunityChatVC alloc] initWitRecentSession:recent];
        [self.navigationController pushViewController:teamchatVC animated:YES];
//    } else {
//        NSLog(@"不在此群");
//    }
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeTeam) {
        [self onSelectedRecent:recent atIndexPath:indexPath];
    }
}
//TODO:
- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSAttributedString *content;
    content = [super contentForRecentSession:recent];
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
    [self checkNeedAtTip:recent content:attContent];
    return attContent;
    
}

- (void)checkNeedAtTip:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if ([NTESSessionUtil recentSessionIsMark:recent type:NTESRecentSessionMarkTypeAt]) {
        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有人@你] " attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [content insertAttributedString:atTip atIndex:0];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([tableView isEqual:self.tableView]) {
        return self.recentSessionExtManage.teamDefaultTags.count ? 1 : 0;
    } else {
        return self.recentSessionExtManage.tagsTeamRecentSession.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tagsTableView] && self.recentSessionExtManage.tagsTeamRecentSession.count) {
        //TODO: 先读缓存 会出问题, 待优化
        YZHPrivatelyChatListHeaderView* headerView = [self.headerViewDictionary objectForKey:@(section)];
        if (headerView) {
            //如果此行为上锁群则直接返回1.
            if ([self.recentSessionExtManage checkoutContainLockTeamRecentSessions:self.recentSessionExtManage.tagsTeamRecentSession[section]]) {
                return 1;
            }
            if (headerView.currentStatusType == YZHListHeaderStatusTypeDefault) {
                NSInteger row = [self.recentSessionExtManage.tagsTeamRecentSession[section] count] < 3 ? [self.recentSessionExtManage.tagsTeamRecentSession[section] count] : 3;
                return row;
            } else if (headerView.currentStatusType == YZHListHeaderStatusTypeShow) {
                NSInteger row = [self.recentSessionExtManage.tagsTeamRecentSession[section] count];
                return row;
            } else {
                headerView.currentStatusType = YZHListHeaderStatusTypeClose;
                return 0;
            }
        } else {
            // 判断是否是上锁.如果是上锁群则只返回一个.
            // 判断一个分区内回话是否属于上锁.
            if ([self.recentSessionExtManage checkoutContainLockTeamRecentSessions:self.recentSessionExtManage.tagsTeamRecentSession[section]]) {
                return 1;
            } else {
                return [self.recentSessionExtManage.tagsTeamRecentSession[section] count];
            }
        }

    } else {
        //如果有上锁群则 + 1
        if (self.recentSessionExtManage.lockTeamRecentSession.count) {
            return self.recentSessionExtManage.TeamRecentSession.count + 1;
        } else {
            return self.recentSessionExtManage.TeamRecentSession.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.tableView]) {
        NIMRecentSession *recent;
        //有上锁与无上锁逻辑
        if (self.recentSessionExtManage.lockTeamRecentSession.count) {
            if (indexPath.row < self.recentSessionExtManage.topTeamCount) {
                recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row];
            } else if (indexPath.row == self.recentSessionExtManage.topTeamCount) {
                
                YZHSessionListLockCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHLockCellIdentifie forIndexPath:indexPath];
                if (!cell) {
                    cell = [[YZHSessionListLockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYZHLockCellIdentifie];
                }
                [cell refreshTeamLockRecentSeesions:self.recentSessionExtManage.lockTeamRecentSession isLock:self.teamLock];
                [self configurationLockCell:cell recent:recent];
                
                return cell;
            } else {
                recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row - 1];
            }
        } else {
            recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row];
        }
        YZHSessionListCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHDefaultCellIdentifie forIndexPath:indexPath];
        if (!cell) {
            cell = [[YZHSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYZHDefaultCellIdentifie];
        }
        cell.nameLabel.text = [self nameForRecentSession:recent];
        [cell.avatarImageView setAvatarBySession:recent.session];
        
        [cell.nameLabel sizeToFit];
        cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
        [cell.messageLabel sizeToFit];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
        [cell.timeLabel sizeToFit];
        [cell refresh:recent];
        //默认列表左右滑动
        [self configurationDefaultCell:cell recent:recent];
        cell.leftAdornImageView.hidden = NO;
        if ([self.recentSessionExtManage checkoutContainTopTeamRecentSession:recent]) {
            cell.backgroundColor = YZHColorWithRGB(247, 247, 247);
        } else {
            cell.backgroundColor = YZHColorWithRGB(255, 255, 255);
        }
        
        return cell;
    } else { //标签列表
        NIMRecentSession *recent = self.recentSessionExtManage.tagsTeamRecentSession[indexPath.section][indexPath.row];
        //检测是否为上锁
        if ([self.recentSessionExtManage checkoutContainLockTeamRecentSessions:self.recentSessionExtManage.tagsTeamRecentSession[indexPath.section]]) {
            YZHSessionListLockCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHLockCellIdentifie forIndexPath:indexPath];
            if (!cell) {
                cell = [[YZHSessionListLockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYZHLockCellIdentifie];
            }
            [cell refreshTeamLockRecentSeesions:self.recentSessionExtManage.tagsTeamRecentSession[indexPath.section] isLock:self.teamLock];
            [self configurationLockCell:cell recent:recent];
            
            return cell;
        } else {
            //分类列表展示.
            YZHSessionListCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHTagCellIdentifie forIndexPath:indexPath];
            if (!cell) {
                cell = [[YZHSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kYZHTagCellIdentifie];
                
            }
            cell.nameLabel.text = [self nameForRecentSession:recent];
            [cell.avatarImageView setAvatarBySession:recent.session];
            
            [cell.nameLabel sizeToFit];
            cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
            [cell.messageLabel sizeToFit];
            cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
            [cell.timeLabel sizeToFit];
            [cell refresh:recent];
            if ([self.recentSessionExtManage checkoutContainTopOrLockTeamRecentSession:recent]) {
                cell.backgroundColor = YZHColorWithRGB(247, 247, 247);
            } else {
                cell.backgroundColor = YZHColorWithRGB(255, 255, 255);
            }
            [self configurationDefaultCell:cell recent:recent];
            return cell;
        }
    }
}

-(void) swipeTableCellWillBeginSwiping:(nonnull MGSwipeTableCell *) cell {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.recentSessions.count) {
        if ([self.tableView isEqual:tableView]) {
            //暂时不考虑上锁群.
            NIMRecentSession* recent;
            //有上锁与无上锁跳转逻辑
            if (self.recentSessionExtManage.lockTeamRecentSession.count) {
                if (indexPath.row < self.recentSessionExtManage.topTeamCount) {
                    recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row];
                    [self onSelectedRecent:recent atIndexPath:indexPath];
                } else if (indexPath.row == self.recentSessionExtManage.topTeamCount) {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    //处理打开上锁群逻辑
                    if (self.teamLock) {
                        //密码弹框
                        [self clickLockTeam];
                    } else {
                        //跳转至上锁群列表
                        [self gotoLockTeamList];
                    }
                } else {
                    recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row - 1];
                    [self onSelectedRecent:recent atIndexPath:indexPath];
                }
            } else {
                recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row];
                [self onSelectedRecent:recent atIndexPath:indexPath];
            }
        } else {
             if ([self.recentSessionExtManage checkoutContainLockTeamRecentSessions:self.recentSessionExtManage.tagsTeamRecentSession[indexPath.section]]) {
                 [tableView deselectRowAtIndexPath:indexPath animated:YES];
                 //处理打开上锁群逻辑
                 if (self.teamLock) {
                     //密码弹框
                     [self clickLockTeam];
                 } else {
                     //跳转至上锁群列表
                     [self gotoLockTeamList];
                 }
             } else {
                 NIMRecentSession *recentSession = self.recentSessionExtManage.tagsTeamRecentSession[indexPath.section][indexPath.row];
                 [self onSelectedRecent:recentSession atIndexPath:indexPath];
             }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tableView]) {
        if (section == 0) {
            return 1;
        }
        return 0;
    } else {
        
        return 40;
    }
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //发现标签有更新之后,直接不要读缓存.TODO
    YZHPrivatelyChatListHeaderView* headerView;
    NIMRecentSession* recentSession = [self.recentSessionExtManage.tagsTeamRecentSession[section] firstObject];
    if (![tableView isEqual:self.tableView] && [self.recentSessionExtManage checkoutContainLockTeamRecentSessions:self.recentSessionExtManage.tagsTeamRecentSession[section]]) {
        headerView = [[YZHPrivatelyChatListHeaderView alloc] init];
        [headerView.guideImageView removeFromSuperview];
        headerView.tagNameLabel.text = @"上锁群";
        [headerView.tagNameLabel sizeToFit];
        
        return headerView;
    }
    if (![tableView isEqual:self.tableView]) {
        headerView = [self.headerViewDictionary objectForKey:@(section)];
        if (!headerView)
        {
            headerView = [[YZHPrivatelyChatListHeaderView alloc] init];
            headerView.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_default"];
            [headerView.guideImageView sizeToFit];
            headerView.section = section;
            headerView.currentStatusType = YZHTableViewShowTypeDefault;
            __weak typeof(self) weakSelf = self;
            //跳转方法可能由问题,最好直接使用 @protocol 的方式来处理.
            headerView.callBlock = ^(NSInteger currentSection) {
                [weakSelf selectedTableViewForHeaderInSection:currentSection];
            };
            // 缓存
            [self.headerViewDictionary setObject:headerView forKey:@(section)];
        }
    }
    YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
    if (section == 0)
    {
        NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
        BOOL isMarkTop = recentSession.localExt[markTypeTopkey];
        //防止置顶被取消之后,分区头未清空掉.
        if (isMarkTop) {
            headerView.tagNameLabel.text = @"置顶";
            headerView.backgroundColor = YZHColorWithRGB(247, 247, 247);
        } else {
            headerView.tagNameLabel.text = teamExt.team_tagName ? teamExt.team_tagName : @"其他分类";
            headerView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        headerView.tagNameLabel.text = teamExt.team_tagName ? teamExt.team_tagName : @"其他分类";
    }
    [headerView.tagNameLabel sizeToFit];
    headerView.unReadCountLabel.text = @"";
    [headerView.unReadCountLabel sizeToFit];
    return headerView;
}

- (void)selectedTableViewForHeaderInSection:(NSInteger)section {
    
    YZHPrivatelyChatListHeaderView* headerView = [self.headerViewDictionary objectForKey:@(section)];
    
    NSInteger integer = headerView.currentStatusType;
    integer = ((++integer) > 2 ? 0 : integer);
    headerView.currentStatusType = integer;
    [headerView refreshStatus];
    
    switch (headerView.currentStatusType) {
        case YZHListHeaderStatusTypeDefault:
            headerView.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_default"];
            break;
        case YZHListHeaderStatusTypeShow:
            headerView.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_show"];
            break;
        case YZHListHeaderStatusTypeClose:
            headerView.guideImageView.image = [UIImage imageNamed:@"team_createTeam_selectedTag_default"];
            break;
        default:
            break;
    }
    [headerView.guideImageView sizeToFit];
    NSIndexSet *indexSet= [[NSIndexSet alloc] initWithIndex: section];
    //暂时先这样处理, 避免崩溃:https://stackoverflow.com/questions/10134841/assertion-failure-in-uitableview-endcellanimationswithcontext
    if (section == 0) {
        [self.tagsTableView reloadData];
    } else {
        @try {
            [self.tagsTableView beginUpdates];
            [self.tagsTableView reloadSections:indexSet withRowAnimation: UITableViewRowAnimationNone];
            [self.tagsTableView endUpdates];
        }
        @catch (NSException *exception) {
            NSLog(@"%s\n%@", __FUNCTION__, exception);
        }
        @finally {
            [self.tagsTableView reloadData];
        }
    }
    
}
// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (![tableView isEqual:self.tableView]) {
        return 10;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableViewDelegate

#pragma mark - NIMLoginManagerDelegate

#pragma mark - NIMEventSubscribeManagerDelegate

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    }else{
        return self.recentSessions.count;
    }
}

#pragma mark - NIMConversationManagerDelegate

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self.recentSessions addObject:recentSession];
    //TODO:
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}
//TODO:
- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    
    for (NIMRecentSession *recent in self.recentSessions)
    {
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId])
        {
            [self.recentSessions removeObject:recent];
            break;
        }
    }
    NSInteger insert = [self findInsertPlace:recentSession];
    [self.recentSessions insertObject:recentSession atIndex:insert];
    //TODO:
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    //清理本地数据
//    NSInteger index = [self.recentSessions indexOfObject:recentSession];
//    NSLog(@"找到的要清理社群的下标%ld", index);
//    if (index >= 0 && index <= self.recentSessions.count) {
//        [self.recentSessions removeObjectAtIndex:index];
//    } else {
//
//    }
    [self.recentSessions removeObject:recentSession];
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    if (self.autoRemoveRemoteSession)
    {
        [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                                                          completion:nil];
    }
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

- (void)allMessagesDeleted{
    
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

- (void)allMessagesRead
{
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    [self customSortRecents:self.recentSessions];
    
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refresh];
}

#pragma mark - TeamDelegate

- (void)onTeamMemberChanged:(NIMTeam *)team {
    
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

/**
 *  群组增加回调
 *
 *  @param team 添加的群组
 */
- (void)onTeamAdded:(NIMTeam *)team {
    
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

/**
 *  群组更新回调
 *
 *  @param team 更新的群组
 */
- (void)onTeamUpdated:(NIMTeam *)team {
    
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    
    [self refreshTeamListView];
    [self refresh];
}

/**
 *  群组移除回调
 *
 *  @param team 被移除的群组
 */
- (void)onTeamRemoved:(NIMTeam *)team {
    
    [self.recentSessionExtManage screeningAllTeamRecentSession:[self.recentSessions mutableCopy]];
    [self refreshTeamListView];
    [self refresh];
}

#pragma mark - GET & SET

-(UITableView *)tagsTableView {
    
    if (!_tagsTableView) {
        _tagsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tagsTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.height);
        _tagsTableView.delegate         = self;
        _tagsTableView.dataSource       = self;
        [_tagsTableView registerClass:[YZHSessionListCell class] forCellReuseIdentifier:kYZHTagCellIdentifie];
        [_tagsTableView registerClass:[YZHSessionListLockCell class] forCellReuseIdentifier:kYZHLockCellIdentifie];
        _tagsTableView.tableFooterView  = [[UIView alloc] init];
        _tagsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tagsTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tagsTableView.hidden = YES;
        _tagsTableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    }
    return _tagsTableView;
}

- (YZHExtensionFunctionView *)extensionView {
    
    if (!_extensionView) {
        _extensionView = [YZHExtensionFunctionView yzh_viewWithFrame:CGRectMake(0, 0, 154, 188)];
    }
    return _extensionView;
}

- (YZHRecentSessionExtManage *)recentSessionExtManage {
    
    if (!_recentSessionExtManage) {
        _recentSessionExtManage = [[YZHRecentSessionExtManage alloc] init];
    }
    return _recentSessionExtManage;
}

- (BOOL)hasCommunity {
    
    if ([[NIMSDK sharedSDK].teamManager allMyTeams].count) {
        return YES;
    } else {
        return NO;
    }
}

- (YZHTeamListDefaultView *)defaultView {
    
    if (!_defaultView) {
        _defaultView = [YZHTeamListDefaultView yzh_viewWithFrame:self.view.bounds];
        [_defaultView.findTeamButton addTarget:self action:@selector(onTouchfindTeam:) forControlEvents:UIControlEventTouchUpInside];
        [_defaultView.searchView.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_defaultView.searchView.searchButton setTitle:@"搜索我的群" forState:UIControlStateNormal];
        [_defaultView.searchView.searchButton setTitle:@"搜索我的群" forState:UIControlStateSelected];
    }
    return _defaultView;
}

- (NSMutableDictionary *)headerViewDictionary {
    
    if (!_headerViewDictionary) {
        _headerViewDictionary = [[NSMutableDictionary alloc] init];
    }
    return _headerViewDictionary;
}

- (YZHSearchView *)searchView {
    
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"YZHSearchView" owner:nil options:nil].lastObject;
        [_searchView.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_searchView.searchButton setTitle:@"搜索我的群" forState:UIControlStateNormal];
        [_searchView.searchButton setTitle:@"搜索我的群" forState:UIControlStateSelected];
        _searchView.autoresizingMask = NO;
    }
    return _searchView;
}

- (YZHSearchView *)tagSearchView {
    
    if (!_tagSearchView) {
        _tagSearchView = [[NSBundle mainBundle] loadNibNamed:@"YZHSearchView" owner:nil options:nil].lastObject;
        [_tagSearchView.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_tagSearchView.searchButton setTitle:@"搜索我的群" forState:UIControlStateNormal];
        [_tagSearchView.searchButton setTitle:@"搜索我的群" forState:UIControlStateSelected];
        _tagSearchView.autoresizingMask = NO;
    }
    return _tagSearchView;
}

- (YZHNetworkStatusView *)networkView {
    
    if (!_networkView) {
        _networkView = [YZHNetworkStatusView yzh_viewWithFrame:CGRectMake(0, 0, self.tableView.width, 35)];
        _networkView.autoresizingMask = NO;
        _networkView.frame = CGRectMake(0, 0, self.tableView.width, 35);
    }
    return _networkView;
}

@end
