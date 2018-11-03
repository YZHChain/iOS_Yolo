//
//  YZHPrivatelyChatListVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivatelyChatListVC.h"
#import "YZHPublic.h"

#import "NTESSessionUtil.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "NTESSessionPeekViewController.h"

#import "YZHRecentSessionExtManage.h"
#import "JKRSearchController.h"
#import "YZHExtensionFunctionView.h"
#import "YZHPrivatelyChatListHeaderView.h"
#import "YZHPrivatelyChatSearchVC.h"
#import "YZHPrivateChatVC.h"

typedef enum : NSUInteger {
    YZHTableViewShowTypeDefault = 0,
    YZHTableViewShowTypeTags,
} YZHTableViewShowType;

static YZHTableViewShowType currentShowType = YZHTableViewShowTypeDefault;
static NSString* const kYZHRecentSessionsKey = @"recentSessions";

@interface YZHPrivatelyChatListVC ()<NIMLoginManagerDelegate, NIMEventSubscribeManagerDelegate, UIViewControllerPreviewingDelegate, NIMUserManagerDelegate, NIMConversationManagerDelegate>

@property (nonatomic,assign) BOOL supportsForceTouch;

@property (nonatomic,strong) NSMutableDictionary *preview;

@property (nonatomic, strong) UITableView* tagsTableView;

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NIMRecentSession*>* >* tagsArray;

@property (nonatomic, strong) YZHRecentSessionExtManage* recentSessionExtManage;

@property (nonatomic, strong) NSMutableDictionary* headerViewDictionary;

@property (nonatomic, strong) YZHExtensionFunctionView* extensionView;

@property (nonatomic, strong) JKRSearchController* searchController;
@property (nonatomic, strong) JKRSearchController* tagSearchController;

@end

@implementation YZHPrivatelyChatListVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _preview = [[NSMutableDictionary alloc] init];
//        self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
        self.autoRemoveRemoteSession = YES;
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.设置 NIMSDK 委托
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    //4.设置通知
    [self setupNotification];
    
//    // 设置 3D Touch.
//    if (@available(iOS 9.0, *)) {
//        self.supportsForceTouch = [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
//    } else {
//        // Fallback on earlier versions
//    }
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"私聊";
    
    @weakify(self)
    UIButton* leftButton = [UIButton yzh_setBarButtonItemWithStateNormalImageName:@"addBook_cover_leftBarButtonItem_default" stateSelectedImageName:@"addBook_cover_leftBarButtonItem_catogory" tapCallBlock:^(UIButton *sender) {
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

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    // 添加分类标签列表
    [self.view addSubview:self.tagsTableView];
    
    if (self.recentSessions.count) {
        [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
        [self.recentSessionExtManage sortTagRecentSession];
        if (self.recentSessionExtManage.tagsRecentSession.firstObject.count) {
            [self.tagsTableView reloadData];
        }
    }
}

#pragma mark -- setupNotification

- (void)setupNotification {
    
//    extern NSString *const NIMKitTeamInfoHasUpdatedNotification;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamInfoHasUpdatedNotification:) name:NIMKitTeamInfoHasUpdatedNotification object:nil];
//
//    extern NSString *const NIMKitTeamMembersHasUpdatedNotification;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamMembersHasUpdatedNotification:) name:NIMKitTeamMembersHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:NIMKitUserInfoHasUpdatedNotification object:nil];
    
}
//TODO:
- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}

//- (void)onTeamInfoHasUpdatedNotification:(NSNotification *)notification{
//    [self refresh];
//}
//
//- (void)onTeamMembersHasUpdatedNotification:(NSNotification *)notification{
//    [self refresh];
//}

#pragma mark -- Private
- (void)refresh{
    
    [self.tableView reloadData];
    [self.tagsTableView reloadData];
}

- (void)customSortRecents:(NSMutableArray *)recentSessions
{
    // 这里只需要遍历一次即可.然后等收到群通知时,在进行编译.
    for (NSInteger i = 0 ; i < recentSessions.count; i++) {
        NIMRecentSession* recentSession = recentSessions[i];
        BOOL isSessionTypeP2P = NO;
        if (recentSession.session.sessionType == NIMSessionTypeP2P) {
            isSessionTypeP2P = YES;
        }
        if (!isSessionTypeP2P) {
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


- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}

// 置顶
- (void)onTopRecentAtIndexPath:(NIMRecentSession *)recent
                   atIndexPath:(NSIndexPath *)indexPath
                         isTop:(BOOL)isTop
{
    if (isTop)
    {
        [NTESSessionUtil removeRecentSessionMark:recent.session type:NTESRecentSessionMarkTypeTop];
    }
    else
    {
        [NTESSessionUtil addRecentSessionMark:recent.session type:NTESRecentSessionMarkTypeTop];
    }
    //TODO
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
    [self.recentSessionExtManage sortTagRecentSession];
    [self.tableView reloadData];
}

- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑";
    }
    return [super nameForRecentSession:recent];
}

#pragma mark -- TableViewCell Interaction Function

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:recent.session];
    [self.navigationController pushViewController:privateChatVC animated:YES];
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
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

- (void)checkOnlineState:(NIMRecentSession *)recent content:(NSMutableAttributedString *)content
{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        NSString *state  = [NTESSessionUtil onlineState:recent.session.sessionId detail:NO];
        if (state.length) {
            NSString *format = [NSString stringWithFormat:@"[%@] ",state];
            NSAttributedString *atTip = [[NSAttributedString alloc] initWithString:format attributes:nil];
            [content insertAttributedString:atTip atIndex:0];
        }
    }
}

#pragma mark - NIMLoginManagerDelegate
//- (void)onLogin:(NIMLoginStep)step{
//    [super onLogin:step];
//    switch (step) {
//        case NIMLoginStepLinkFailed:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)"];
//            break;
//        case NIMLoginStepLinking:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)"];
//            break;
//        case NIMLoginStepLinkOK:
//        case NIMLoginStepSyncOK:
//            self.titleLabel.text = SessionListTitle;
//            break;
//        case NIMLoginStepSyncing:
//            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)"];
//            break;
//        default:
//            break;
//    }
//    [self.titleLabel sizeToFit];
//    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
//    [self.header refreshWithType:ListHeaderTypeNetStauts value:@(step)];
//    [self refreshSubview];
//}

//- (void)onMultiLoginClientsChanged
//{
//    [self.header refreshWithType:ListHeaderTypeLoginClients value:[NIMSDK sharedSDK].loginManager.currentLoginClients];
//    [self refreshSubview];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([tableView isEqual:self.tagsTableView]) {
        if ([self.recentSessionExtManage.tagsRecentSession count]) {
            return self.recentSessionExtManage.tagsRecentSession.count;
        } else {
            return 0;
        }
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tagsTableView] && self.recentSessionExtManage.tagsRecentSession.count) {
        YZHPrivatelyChatListHeaderView* headerView = [self.headerViewDictionary objectForKey:@(section)];
        if (headerView) {
            if (headerView.currentStatusType == YZHListHeaderStatusTypeDefault) {
                NSInteger row = [self.recentSessionExtManage.tagsRecentSession[section] count] < 3 ? [self.recentSessionExtManage.tagsRecentSession[section] count] : 3;
                return row;
            } else if (headerView.currentStatusType == YZHListHeaderStatusTypeShow) {
                return [self.recentSessionExtManage.tagsRecentSession[section] count];
            } else {
                return 0;
            }
        }
        return [self.recentSessionExtManage.tagsRecentSession[section] count];
    } else {
        return self.recentSessions.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NIMSessionListCell* cell;
    NIMRecentSession *recentSession;
    if ([tableView isEqual:self.tableView]) {
       cell = (NIMSessionListCell* )[super tableView:tableView cellForRowAtIndexPath:indexPath];
        recentSession = self.recentSessions[indexPath.row];
    } else {
        static NSString * cellId = @"TagCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        recentSession = [self.recentSessionExtManage.tagsRecentSession[indexPath.section] objectAtIndex:indexPath.row];
        cell.nameLabel.text = [self nameForRecentSession:recentSession];
        [cell.avatarImageView setAvatarBySession:recentSession.session];
        [cell.nameLabel sizeToFit];
        cell.messageLabel.attributedText  = [self contentForRecentSession:recentSession];
        [cell.messageLabel sizeToFit];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recentSession];
        [cell.timeLabel sizeToFit];
        
        [cell refresh:recentSession];
        
    }
    //检查是否包含置顶标签
    NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
    BOOL isMarkTop = [[recentSession.localExt objectForKey:markTypeTopkey] boolValue];
    if (isMarkTop) {
        cell.contentView.backgroundColor = YZHColorWithRGB(247, 247, 247);
        cell.nameLabel.backgroundColor = YZHColorWithRGB(247, 247, 247);
        cell.timeLabel.backgroundColor = YZHColorWithRGB(247, 247, 247);
        cell.messageLabel.backgroundColor = YZHColorWithRGB(247, 247, 247);
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.backgroundColor = [UIColor whiteColor];
        cell.timeLabel.backgroundColor = [UIColor whiteColor];
        cell.messageLabel.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //发现标签有更新之后,直接不要读缓存.TODO
    YZHPrivatelyChatListHeaderView* headerView;
    NIMRecentSession* session = [self.self.recentSessionExtManage.tagsRecentSession[section] firstObject];
    if (![tableView isEqual:self.tableView]) {
        headerView = [self.headerViewDictionary objectForKey:@(section)];
        if (!headerView)
        {
            headerView = [[YZHPrivatelyChatListHeaderView alloc] init];
            headerView.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_setting_privacy"];
            [headerView.guideImageView sizeToFit];
            headerView.section = section;
            headerView.currentStatusType = YZHTableViewShowTypeDefault;
            __weak typeof(self) weakSelf = self;
            headerView.callBlock = ^(NSInteger currentSection) {
                [weakSelf selectedTableViewForHeaderInSection:currentSection];
            };
            // 缓存
            [self.headerViewDictionary setObject:headerView forKey:@(section)];
        }
    }
    if (section == 0)
    {
        NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
        BOOL isMarkTop = session.localExt[markTypeTopkey];
        //防止置顶被取消之后,分区头未清空掉.
        if (isMarkTop) {
            headerView.tagNameLabel.text = @"置顶";
            headerView.backgroundColor = YZHColorWithRGB(247, 247, 247);
        } else {
            headerView.tagNameLabel.text = session.localExt[@"tagName"] ? session.localExt[@"tagName"] : @"无好友标签";
            headerView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        headerView.tagNameLabel.text = session.localExt[@"tagName"] ? session.localExt[@"tagName"] : @"无好友标签";
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
            headerView.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_setting_privacy"];
            break;
        case YZHListHeaderStatusTypeShow:
            headerView.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_setting_privacy"];
            break;
        case YZHListHeaderStatusTypeClose:
            headerView.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
            break;
        default:
            break;
    }
    [headerView.guideImageView sizeToFit];
    NSIndexSet *indexSet= [[NSIndexSet alloc] initWithIndex: section];
    [self.tagsTableView reloadSections:indexSet withRowAnimation: UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (![tableView isEqual:self.tableView]) {
        return 40;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (![tableView isEqual:self.recentSessionExtManage.tagsRecentSession]) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMRecentSession *recentSession;
    if ([tableView isEqual:self.tableView]) {
        recentSession = self.recentSessions[indexPath.row];
    } else {
        recentSession = self.recentSessionExtManage.tagsRecentSession[indexPath.section][indexPath.row];
    }
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        if (@available(iOS 9.0, *)) {
            id<UIViewControllerPreviewing> preview = [self registerForPreviewingWithDelegate:self sourceView:cell];
            [self.preview setObject:preview forKey:@(indexPath.row)];
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.supportsForceTouch) {
        id<UIViewControllerPreviewing> preview = [self.preview objectForKey:@(indexPath.row)];
        if (@available(iOS 9.0, *)) {
            [self unregisterForPreviewingWithContext:preview];
        } else {
            // Fallback on earlier versions
        }
        [self.preview removeObjectForKey:@(indexPath.row)];
    }
}
//TODO:  3D Touch
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
    if (@available(iOS 9.0, *)) {
        UITableViewCell *touchCell = (UITableViewCell *)context.sourceView;
        if ([touchCell isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
            NIMRecentSession *recent = self.recentSessions[indexPath.row];
            NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];

            return nav;
        }
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    if (@available(iOS 9.0, *)) {
        UITableViewCell *touchCell = (UITableViewCell *)previewingContext.sourceView;
        if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//            NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//            NIMRecentSession *recent = self.recentSessions[indexPath.row];
            //TODO:
//            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
//            id addBookVC = NSClassFromString(@"YZHAddressBookVC");
//            id vc = [[addBookVC alloc] init];
//            [self.navigationController showViewController:vc sender:nil];
        }
    } else {
        // Fallback on earlier versions
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([tableView isEqual:weakSelf.tableView]) {
            NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
            [weakSelf onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
        } else {
            NIMRecentSession *recentSession = weakSelf.recentSessionExtManage.tagsRecentSession[indexPath.section][indexPath.row
                                                                                                                   ];
            [weakSelf onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
        }
        [tableView setEditing:NO animated:YES];
    }];
    
    NIMRecentSession *recentSession;
    if ([tableView isEqual:self.tableView]) {
        recentSession = weakSelf.recentSessions[indexPath.row];
    } else {
        recentSession = weakSelf.recentSessionExtManage.tagsRecentSession[indexPath.section][indexPath.row];
    }
    BOOL isTop = [NTESSessionUtil recentSessionIsMark:recentSession type:NTESRecentSessionMarkTypeTop];
    UITableViewRowAction *top = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:isTop?@"取消置顶":@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf onTopRecentAtIndexPath:recentSession atIndexPath:indexPath isTop:isTop];
        [tableView setEditing:NO animated:YES];
    }];
    
    return @[delete,top];
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    // All tasks are handled by blocks defined in editActionsForRowAtIndexPath, however iOS8 requires this method to enable editing
}


#pragma mark - NIMEventSubscribeManagerDelegate

//- (void)onRecvSubscribeEvents:(NSArray *)events
//{
//    NSMutableSet *ids = [[NSMutableSet alloc] init];
//    for (NIMSubscribeEvent *event in events) {
//        [ids addObject:event.from];
//    }
//
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        if (recent.session.sessionType == NIMSessionTypeP2P) {
//            NSString *from = recent.session.sessionId;
//            if ([ids containsObject:from]) {
//                [indexPaths addObject:indexPath];
//            }
//        }
//    }
//
//    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//}

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
    [self.recentSessionExtManage checkSessionUserTagWithRecentSession:recentSession];
    [self.recentSessions addObject:recentSession];
    //TODO:
//    self.recentSessions = [self customSortRecents:self.recentSessions];
    [self customSortRecents:self.recentSessions];
    //TODO: 有空了在单独封装一个新增,接口.
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
    [self refresh];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
//    [self.recentSessionExtManage checkSessionUserTagWithRecentSession:recentSession];
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
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
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
    //    self.recentSessions = [self customSortRecents:self.recentSessions];
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
    [self refresh];
}

- (void)messagesDeletedInSession:(NIMSession *)session{

    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    //    self.recentSessions = [self customSortRecents:self.recentSessions];
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
    [self refresh];
}

- (void)allMessagesDeleted{

    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    //    self.recentSessions = [self customSortRecents:self.recentSessions];
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
    [self refresh];
}

- (void)allMessagesRead
{
    [self setValue:[[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy] forKey:kYZHRecentSessionsKey];
    [self customSortRecents:self.recentSessions];
    [self.recentSessionExtManage screeningTagSessionAllRecentSession:self.recentSessions];
    [self refresh];
}

#pragma mark - Private
/*
- (void)refreshSubview{
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    if (@available(iOS 11.0, *))
    {
        self.header.top = self.view.safeAreaInsets.top;
        self.tableView.top = self.header.bottom;
        CGFloat offset = self.view.safeAreaInsets.bottom;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
    }
    else
    {
        self.tableView.top = self.header.height;
        self.header.bottom    = self.tableView.top + self.tableView.contentInset.top;
    }
    self.tableView.height = self.view.height - self.tableView.top;
    
    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .5f;
}

- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text =  SessionListTitle;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height + subLabel.height;
    
    subLabel.bottom = titleView.height;
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:subLabel];
    return titleView;
}
*/

#pragma mark -- SET GET

-(UITableView *)tagsTableView {
    
    if (!_tagsTableView) {
        _tagsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tagsTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.height);
        _tagsTableView.delegate         = self;
        _tagsTableView.dataSource       = self;
        _tagsTableView.tableFooterView  = [[UIView alloc] init];
        _tagsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tagsTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tagsTableView.hidden = YES;
        _tagsTableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tagsTableView.tableHeaderView = self.tagSearchController.searchBar;
    }
    return _tagsTableView;
}

- (NSMutableArray<NSMutableArray<NIMRecentSession *> *> *)tagsArray {
    
    if (!_tagsArray) {
        _tagsArray = self.recentSessionExtManage.tagsRecentSession;
    }
    return _tagsArray;
}

- (YZHRecentSessionExtManage *)recentSessionExtManage {
    
    if (!_recentSessionExtManage) {
        _recentSessionExtManage = [[YZHRecentSessionExtManage alloc] init];
    }
    return _recentSessionExtManage;
}

- (NSMutableDictionary *)headerViewDictionary {
    
    if (!_headerViewDictionary) {
        _headerViewDictionary = [[NSMutableDictionary alloc] init];
    }
    return _headerViewDictionary;
}

- (YZHExtensionFunctionView *)extensionView {
    
    if (!_extensionView) {
        _extensionView = [YZHExtensionFunctionView yzh_viewWithFrame:CGRectMake(0, 0, 154, 188)];
    }
    return _extensionView;
}

- (JKRSearchController *)searchController {
    
    if (!_searchController) {
        YZHPrivatelyChatSearchVC* chatSearchVC = [[YZHPrivatelyChatSearchVC alloc] init];
        _searchController = [[JKRSearchController alloc] initWithSearchResultsController:chatSearchVC];
        _searchController.searchBar.placeholder = @"搜索YOLO ID,手机号";
        _searchController.hidesNavigationBarDuringPresentation = YES;
        // 代理方法都是设计业务, 可以单独抽取出来.
        //        _searchController.searchResultsUpdater = self;
        //        _searchController.searchBar.delegate = self;
        //        _searchController.delegate = self;
    }
    return _searchController;
}

- (JKRSearchController *)tagSearchController {
    
    if (!_tagSearchController) {
        YZHPrivatelyChatSearchVC* chatSearchVC = [[YZHPrivatelyChatSearchVC alloc] init];
        _tagSearchController = [[JKRSearchController alloc] initWithSearchResultsController:chatSearchVC];
        _tagSearchController.searchBar.placeholder = @"搜索YOLO ID,手机号";
        _tagSearchController.hidesNavigationBarDuringPresentation = YES;
        // 代理方法都是设计业务, 可以单独抽取出来.
        //        _tagSearchController.searchResultsUpdater = self;
        //        _tagSearchController.searchBar.delegate = self;
        //        _tagSearchController.delegate = self;
    }
    return _tagSearchController;
}

@end