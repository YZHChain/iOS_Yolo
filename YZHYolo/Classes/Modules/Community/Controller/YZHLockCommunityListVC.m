//
//  YZHLockCommunityListVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/30.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLockCommunityListVC.h"

#import "NIMSessionListCell.h"
#import "NTESSessionUtil.h"

#import "YZHPublic.h"
#import "UIButton+YZHClickHandle.h"
#import "YZHExtensionFunctionView.h"
#import "JKRSearchController.h"
#import "YZHCommunitySearchVC.h"
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

static NSString* const kYZHDefaultCellIdentifie = @"defaultCellIdentifie";
static NSString* const kYZHRecentSessionsKey = @"recentSessions";

@interface YZHLockCommunityListVC()<NIMTeamManagerDelegate, MGSwipeTableCellDelegate>

@end

@implementation YZHLockCommunityListVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithRecentSessionExtManage:(YZHRecentSessionExtManage *)recentSessionExtManage {
    
    self = [super init];
    if (self) {
        self.recentSessionExtManage = recentSessionExtManage;
        self.recentSessions = [recentSessionExtManage.lockTeamRecentSession mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
//    [self setupData];
    //4.设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"上锁群";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    [self.tableView registerClass:[YZHSessionListCell class] forCellReuseIdentifier:kYZHDefaultCellIdentifie];
    
    self.recentSessions = [self.recentSessionExtManage.lockTeamRecentSession mutableCopy];
    
    [self refresh];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recentSessions.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NIMRecentSession *recent = self.recentSessionExtManage.TeamRecentSession[indexPath.row];
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
    
    return cell;
    
//    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
}
// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)configurationDefaultCell:(YZHSessionListCell *)cell recent:(NIMRecentSession *)recent{
    
    cell.delegate = self;
    MGSwipeButton* tipButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"team_sessionList_cellEdit_tip"] backgroundColor:YZHColorWithRGB(207, 211, 217)];
    MGSwipeButton* lockButton = [MGSwipeButton buttonWithTitle:@"群信息" backgroundColor:[UIColor yzh_fontThemeBlue]];
    cell.leftButtons = @[tipButton, lockButton];
    cell.leftSwipeSettings.transition = MGSwipeStateSwipingLeftToRight;
    
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
        //        [self.recentSessionExtManage screeningTagSessionAllTeamRecentSession:[self.recentSessions mutableCopy]];
        //        [self.recentSessionExtManage sortTagTeamRecentSession];
        //        [self.recentSessionExtManage screeningDefaultSessionAllTeamRecentSession:[self.recentSessions mutableCopy]];
        //        [self customSortTeamRecents:self.recentSessionExtManage.TeamRecentSession];
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
}

#pragma mark - 5.Event Response


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)refresh{
    if (!self.recentSessionExtManage.lockTeamRecentSession.count) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)customSortRecents:(NSMutableArray *)recentSessions
{
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

#pragma mark -- TableViewDataSource

#pragma mark -- TableViewCell Interaction Function

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    if ([[[NIMSDK sharedSDK] teamManager] isMyTeam:recent.session.sessionId]) {
        YZHCommunityChatVC* teamchatVC = [[YZHCommunityChatVC alloc] initWitRecentSession:recent];
        [self.navigationController pushViewController:teamchatVC animated:YES];
    } else {
        NSLog(@"不在此群");
    }
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
    //        [self checkOnlineState:recent content:attContent];
    return attContent;
}

- (void)checkNeedAtTip:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if ([NTESSessionUtil recentSessionIsMark:recent type:NTESRecentSessionMarkTypeAt]) {
        NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:@"[有人@你] " attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [content insertAttributedString:atTip atIndex:0];
    }
}

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
    NSInteger insert = 0;
    //TODO:由于存在上锁群, 暂时先这样处理.
    if ([recentSession isKindOfClass: [NIMRecentSession class]]) {
        insert = [self findInsertPlace:recentSession];
    } else {
        return;
    }
    [self.recentSessions insertObject:recentSession atIndex:insert];
    //TODO:
    [self customSortRecents:self.recentSessions];
    [self refresh];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    //清理本地数据
    NSInteger index = [self.recentSessions indexOfObject:recentSession];
    [self.recentSessions removeObjectAtIndex:index];
    
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    if (self.autoRemoveRemoteSession)
    {
        [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                                                          completion:nil];
    }
    [self customSortRecents:self.recentSessions];
    [self refresh];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    [self customSortRecents:self.recentSessions];
    [self refresh];
}

- (void)allMessagesDeleted{
    
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    [self customSortRecents:self.recentSessions];
    [self refresh];
}

- (void)allMessagesRead
{
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    [self customSortRecents:self.recentSessions];
    [self refresh];
}

#pragma mark - TeamDelegate

- (void)onTeamMemberChanged:(NIMTeam *)team {
    
    [self refresh];
}

/**
 *  群组增加回调
 *
 *  @param team 添加的群组
 */
- (void)onTeamAdded:(NIMTeam *)team {
    
    [self refresh];
}

/**
 *  群组更新回调
 *
 *  @param team 更新的群组
 */
- (void)onTeamUpdated:(NIMTeam *)team {
    
    [self refresh];
}

/**
 *  群组移除回调
 *
 *  @param team 被移除的群组
 */
- (void)onTeamRemoved:(NIMTeam *)team {
    
    [self refresh];
}

#pragma mark - 7.GET & SET

@end
