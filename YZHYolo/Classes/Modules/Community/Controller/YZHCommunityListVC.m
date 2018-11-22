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

typedef enum : NSUInteger {
    YZHTableViewShowTypeDefault = 0,
    YZHTableViewShowTypeTags,
} YZHTableViewShowType;

static YZHTableViewShowType currentShowType = YZHTableViewShowTypeDefault;
static NSString* const kYZHRecentSessionsKey = @"recentSessions";
@interface YZHCommunityListVC ()<NIMTeamManagerDelegate, MGSwipeTableCellDelegate>

@property (nonatomic, strong) YZHExtensionFunctionView* extensionView;

@property (nonatomic, strong) UITableView* tagsTableView;

@property (nonatomic, strong) JKRSearchController* searchController;

@property (nonatomic, strong) JKRSearchController* tagSearchController;

@property (nonatomic, strong) YZHRecentSessionExtManage* recentSessionExtManage;

@end

@implementation YZHCommunityListVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //4.设置通知
    [self setupNotification];
    
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    
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
    self.navigationItem.title = @"社群";
    
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

- (void)setupView
{
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
    } else {
        
    }
}

#pragma mark -- setupNotification

- (void)setupNotification
{
    
}

#pragma mark -- Private Methods

- (void)refresh
{
    [self.tableView reloadData];
    [self.tagsTableView reloadData];
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

#pragma mark -- TableViewCell Interaction Function

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWithSession:recent.session];
    
    YZHCommunityChatVC* teamchatVC = [[YZHCommunityChatVC alloc] init];
    teamchatVC.teamId = recent.session.sessionId;
    [self.navigationController pushViewController:teamchatVC animated:YES];
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeTeam) {
        [self onSelectedRecent:recent atIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.recentSessions.count) {
        return 1;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.recentSessions.count) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else {
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self hasCommunity]) {
        static NSString * cellId = @"cellId";
        YZHSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[YZHSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//            [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
        }
        NIMRecentSession *recent = self.recentSessions[indexPath.row];
        cell.nameLabel.text = [self nameForRecentSession:recent];
        [cell.avatarImageView setAvatarBySession:recent.session];
        
        [cell.nameLabel sizeToFit];
        cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
        [cell.messageLabel sizeToFit];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
        [cell.timeLabel sizeToFit];
        
        [cell refresh:recent];
        
        cell.delegate = self;
        MGSwipeButton* tipButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"team_sessionList_cellEdit_tip"] backgroundColor:[UIColor yzh_fontThemeBlue]];
        MGSwipeButton* lockButton = [MGSwipeButton buttonWithTitle:@"解锁" backgroundColor:YZHColorWithRGB(207, 211, 217)];
        cell.leftButtons = @[tipButton, lockButton];
        cell.leftSwipeSettings.transition = MGSwipeTransitionRotate3D;
        
        MGSwipeButton* deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor yzh_buttonBackgroundPinkRed]];
        
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
        
        cell.leftAdornImageView.hidden = NO;
        
        return cell;
    } else {
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        
        return cell;
    }
}

-(void) swipeTableCellWillBeginSwiping:(nonnull MGSwipeTableCell *) cell {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.recentSessions.count) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 20;
    } else {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    return view;
}

#pragma mark - UITableViewDelegate

#pragma mark - NIMLoginManagerDelegate

#pragma mark - NIMEventSubscribeManagerDelegate

#pragma mark - NIMConversationManagerDelegate

#pragma mark - TeamDelegate

- (void)onTeamMemberChanged:(NIMTeam *)team {
    
    
}

#pragma mark - GET & SET

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

- (YZHExtensionFunctionView *)extensionView {
    
    if (!_extensionView) {
        _extensionView = [YZHExtensionFunctionView yzh_viewWithFrame:CGRectMake(0, 0, 154, 188)];
    }
    return _extensionView;
}

- (JKRSearchController *)searchController {
    
    if (!_searchController) {
        YZHCommunitySearchVC* communitySearchVC = [[YZHCommunitySearchVC alloc] init];
        _searchController = [[JKRSearchController alloc] initWithSearchResultsController:communitySearchVC];
        _searchController.searchBar.placeholder = @"搜索";
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
        YZHCommunitySearchVC* communitySearchVC = [[YZHCommunitySearchVC alloc] init];
        _tagSearchController = [[JKRSearchController alloc] initWithSearchResultsController:communitySearchVC];
        _tagSearchController.searchBar.placeholder = @"搜索";
        _tagSearchController.hidesNavigationBarDuringPresentation = YES;
        // 代理方法都是设计业务, 可以单独抽取出来.
        //        _tagSearchController.searchResultsUpdater = self;
        //        _tagSearchController.searchBar.delegate = self;
        //        _tagSearchController.delegate = self;
    }
    return _tagSearchController;
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

@end
