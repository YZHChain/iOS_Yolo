//
//  YZHCommunitySearchVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommunitySearchVC.h"

#import "YZHUserLoginManage.h"
#import "YZHSearchModel.h"
#import "YZHSearchTeamCell.h"
#import "YZHSearchRecommendSectionView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YZHUserDataManage.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "YZHCommunityChatVC.h"
#import "YZHSearchLabelSelectedView.h"
#import "YZHUserModelManage.h"

static int kYZHRecommendTeamPageSize = 20; // 默认每页个数
static NSString* kYZHSearchRecommendSectionView = @"YZHSearchRecommendSectionView";
@interface YZHCommunitySearchVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,YZHSearchRecommendViewProtocol, YZHSearchTeamCellProtocol, YZHSearchLabelSelectedProtocol>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) YZHSearchListModel* searchManage;
@property (nonatomic, strong) YZHSearchListModel* recommendModel;
@property (nonatomic, strong) UIView *customNavBar;
@property (nonatomic, assign) int recommendPageNumber;
@property (nonatomic, assign) BOOL havaSearchModel;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, strong) NSString* lastKeyText;
@property (nonatomic, assign) int searchPageNumber;
@property (nonatomic, strong) YZHUserDataModel* userDataModel;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) NSMutableArray* teamTagArray;

@end

@implementation YZHCommunitySearchVC
#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    NSString* accid = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
    NSMutableArray* selectedTeamArray = self.userDataModel.teamLabel;
    NSDictionary* dic;
    if (selectedTeamArray.count) {
        dic = @{
                @"pn": [NSNumber numberWithInt:self.recommendPageNumber],
                @"accid": accid,
                @"pageSize": [NSNumber numberWithInt:kYZHRecommendTeamPageSize],
                @"teamLabel": [selectedTeamArray mj_JSONString]
                };
        
    } else {
        dic = @{
                @"pn": [NSNumber numberWithInt:self.recommendPageNumber],
                @"accid": accid,
                @"pageSize": [NSNumber numberWithInt:kYZHRecommendTeamPageSize],
                };
    }
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    [[YZHNetworkService shareService] POSTGDLNetworkingResource:PATH_TEAM_RECOMMENDEDGROUP params:dic successCompletion:^(id obj) {
        [hud hideWithText:nil];
        self.recommendModel = [YZHSearchListModel YZH_objectWithKeyValues:obj];
        [self.tableView reloadData];
        
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

- (void)swtichRecommendTeamList {
    
    if (self.recommendPageNumber < self.recommendModel.pageTotal) {
        ++self.recommendPageNumber;
    } else {
        self.recommendPageNumber = 1;
    }
    
    [self setupData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.searchManage.searchRecentSession.count;
    } else {
        return self.recommendModel.recommendArray.count;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [self searchTableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self recommendTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell* )recommendTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHSearchTeamCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    YZHSearchModel* model;
    model = self.recommendModel.recommendArray[indexPath.row];
    [cell refresh:model];
    
    return cell;
}

- (UITableViewCell* )searchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"cellId";
    NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //            [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    NIMRecentSession *recent = self.searchManage.searchRecentSession[indexPath.row];
    cell.nameLabel.text = [self nameForRecentSession:recent];
    [cell.avatarImageView setAvatarBySession:recent.session];
    [cell.nameLabel sizeToFit];
    cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
    [cell.messageLabel sizeToFit];
    cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
    [cell.timeLabel sizeToFit];
    
    [cell refresh:recent];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        YZHSearchLabelSelectedView* labelView = [[YZHSearchLabelSelectedView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, 50)];
        CGFloat height =  [labelView refreshLabelButtonWithLabelArray:self.teamTagArray];
        return height + 60;
    } else {
        return 40;
    }
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UITableViewHeaderFooterView* searchSectionView = [[UITableViewHeaderFooterView alloc] init];
        UILabel* label = [[UILabel alloc] init];
        label.font = [UIFont yzh_commonFontStyleFontSize:13];
        label.textColor = [UIColor yzh_sessionCellGray];
        if (self.havaSearchModel) {
            label.text = @"搜索到的群";
        } else {
            label.text = @"未找到相关群";
        }
        [searchSectionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(15);
        }];
        searchSectionView.backgroundView = ({
            UIView* view = [[UIView alloc] initWithFrame:searchSectionView.bounds];
            view.backgroundColor = [UIColor yzh_backgroundThemeGray];
            view;
        });
        
        YZHSearchLabelSelectedView* labelView = [[YZHSearchLabelSelectedView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, 50)];
        [searchSectionView addSubview:labelView];
        CGFloat height =  [labelView refreshLabelButtonWithLabelArray:self.teamTagArray];
        [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(label.mas_bottom).mas_equalTo(3);
            make.height.mas_equalTo(height + 40);
        }];
        labelView.delegate = self;
        
        return searchSectionView;
    } else {
        YZHSearchRecommendSectionView* sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHSearchRecommendSectionView];
        sectionView.delegate = self;
        return sectionView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearchStatus) {
        if (indexPath.section == 0) {
            [self searchTableView:tableView didSelectRowAtIndexPath:indexPath];
        } else {
            [self recommendTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    } else {
        [self recommendTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)searchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NIMRecentSession *recentSession;
    
    recentSession = self.searchManage.searchRecentSession[indexPath.row];
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
}

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

- (void)recommendTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZHSearchModel* model = self.recommendModel.recommendArray[indexPath.row];
    //进入群详情.
    BOOL isTeamMerber = [[[NIMSDK sharedSDK] teamManager] isMyTeam:model.teamId];
    if (isTeamMerber) {
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:model.teamId];
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        BOOL isTeamOwner = [userId isEqualToString:team.owner] ? YES : NO;
        [YZHRouter openURL:kYZHRouterCommunityCard info:@{
                                                          @"isTeamOwner": @(isTeamOwner),
                                                          @"teamId": model.teamId,
                                                          }];
    } else {
        [YZHRouter openURL:kYZHRouterCommunityCardIntro info:@{
                                                               @"teamId": model.teamId,
                                                               kYZHRouteSegue: kYZHRouteSegueModal,
                                                               kYZHRouteSegueNewNavigation: @(YES)
                                                               }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar endEditing:YES];
}

#pragma mark - YZHSearchRecommendViewProtocol

- (void)onTouchSwitch:(UIButton *)sender {
    
    [self swtichRecommendTeamList];
}

- (void)onTouchSwitchRange:(UIButton *)sender {
    
    @weakify(self)
    void(^selectedLabelSaveHandle)(NSMutableArray *) = ^(NSMutableArray *selectedTeamLabel) {
        @strongify(self)
        self.userDataModel.teamLabel = selectedTeamLabel;
        [[YZHUserDataManage sharedManager] setCurrentUserData:self.userDataModel];
        [self setupData];
    };
    NSMutableArray* selectedArray = self.userDataModel.teamLabel.count ? self.userDataModel.teamLabel : [[NSMutableArray alloc] init];
    [YZHRouter openURL:kYZHRouterCommunityCreateTeamTagSelected info:@{
                                                                       kYZHRouteSegue: kYZHRouteSegueModal,
                                                                       kYZHRouteSegueNewNavigation : @(YES),
                                                                       @"selectedLabelSaveHandle": selectedLabelSaveHandle,
                                                                       @"selectedLabelArray":selectedArray
                                                                       }];
}

#pragma mark - YZHSearchTeamCellProtocol

- (void)onTouchJoinTeam:(YZHSearchModel *)model {
    
    //可以先读取本地,如果没有在拉取.
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:model.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
        @strongify(self)
        if (!error) {
            [self addTeamWith:team hud:hud];
        } else {
            [hud hideWithText:@"此群已解散"];
        }
    }];
}

- (void)selectedTagLabel:(UIButton *)tagLabel {
    
//    NSMutableString* mutableKeyText = [[NSMutableString alloc] init];
//    if (YZHIsString(self.textField.text)) {
//        [mutableKeyText appendString:self.textField.text];
//        [mutableKeyText appendString:tagLabel.titleLabel.text];
//    } else {
//        mutableKeyText = tagLabel.titleLabel.text.mutableCopy;
//    }
//    self.textField.text = mutableKeyText;
//    [self searchTeamListWithKeyText:mutableKeyText];
    self.textField.text = tagLabel.titleLabel.text;
    [self.searchBar endEditing:YES];
    [self.searchManage searchTeamTag:self.textField.text];
    self.isSearchStatus = YES;
    self.havaSearchModel = self.searchManage.searchRecentSession.count;
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    if (YZHIsString(searchBar.text)) {
        self.isSearchStatus = YES;
        [self searchTeamListWithKeyText:searchBar.text];
    } else {
        self.isSearchStatus = NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!YZHIsString(searchBar.text)) {
        self.isSearchStatus = NO;
        
        [self.searchManage.searchRecentSession removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)addTeamWith:(NIMTeam* )team hud:(YZHProgressHUD *)hud {
    
    //    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    BOOL isTeamMerber = [[[NIMSDK sharedSDK] teamManager] isMyTeam:team.teamId];
    if (!isTeamMerber) {
        NSString* title;
        switch (team.joinMode) {
            case NIMTeamJoinModeNoAuth:
                title = @"加入群聊成功";
                break;
            case NIMTeamJoinModeNeedAuth:
                title = @"已发起加入群聊申请";
                break;
            case NIMTeamJoinModeRejectAll:
                title = @"此群不允许其他人加入";
                break;
            default:
                break;
        }
        [[[NIMSDK sharedSDK] teamManager] applyToTeam:team.teamId message:@"通过群搜索加入" completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
            if (!error) {
                //                if (applyStatus == NIMTeamApplyStatusAlreadyInTeam) {
                //
                //                } else if (applyStatus == NIMTeamApplyStatusWaitForPass) {
                //
                //                } else if (applyStatus == NIMTeamApplyStatusInvalid) {
                //
                //                }
                [hud hideWithText:title];
            } else {
                //TODO: 提示语
                [hud hideWithText:@"加入群聊失败, 请稍后重试"];
            }
        }];
    } else {
        [hud hideWithText:@"你已是本群群成员"];
    }
    
}

- (void)searchTeamListWithKeyText:(NSString *)keyText {
    
    if (YZHIsString(keyText)) {
        [self.searchManage searchTeamKeyText:keyText];
        self.isSearchStatus = YES;
        self.havaSearchModel = self.searchManage.searchRecentSession.count;
        [self.tableView reloadData];
    } else {
        self.isSearchStatus = NO;
        self.havaSearchModel = NO;
        [self.tableView reloadData];
    }
}

- (void)setupNotification {
    
}

#pragma mark NIMCell

- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
    }else{
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        return team.teamName;
    }
}

- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSString *content = [self messageContent:recent.lastMessage];
    return [[NSAttributedString alloc] initWithString:content ?: @""];
}

- (NSString *)messageContent:(NIMMessage*)lastMessage{
    NSString *text = @"";
    switch (lastMessage.messageType) {
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
        case NIMMessageTypeLocation:
            text = @"[位置]";
            break;
        case NIMMessageTypeNotification:{
            return [self notificationMessageContent:lastMessage];
        }
        case NIMMessageTypeFile:
            text = @"[文件]";
            break;
        case NIMMessageTypeTip:
            text = lastMessage.text;
            break;
        case NIMMessageTypeRobot:
            //            text = [self robotMessageContent:lastMessage];
            break;
        case NIMMessageTypeCustom:
            //TODO:增加自定义消息解析.识别不同自定义消息格式
            
            text = @"自定义消息";
            break;
        default:
            text = @"[未知消息]";
    }
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip)
    {
        return text;
    }
    else
    {
        NSString *from = lastMessage.from;
        if (lastMessage.messageType == NIMMessageTypeRobot)
        {
            NIMRobotObject *object = (NIMRobotObject *)lastMessage.messageObject;
            if (object.isFromRobot)
            {
                from = object.robotId;
            }
        }
        NSString *nickName = [NIMKitUtil showNick:from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage{
    NIMNotificationObject *object = (NIMNotificationObject *)lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[网络通话]";
        }
        return @"[视频聊天]";
    }
    if (object.notificationType == NIMNotificationTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:lastMessage.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            return @"[讨论组信息更新]";
        }else{
            return @"[群信息更新]";
        }
    }
    return @"[未知消息]";
}

- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent{
    
    return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        //        _tableView.frame = CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64);
        [_tableView registerNib:[UINib nibWithNibName:@"YZHSearchTeamCell" bundle:nil] forCellReuseIdentifier: kYZHCommonCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHSearchRecommendSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHSearchRecommendSectionView];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    }
    return _tableView;
}
- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        
        UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width-80,33)];
        searchbar.placeholder = @"搜索";
        searchbar.searchBarStyle = UISearchBarStyleDefault;
        searchbar.showsCancelButton = YES;
        //通过KVC拿到textField
        UITextField  *seachTextFild = [searchbar valueForKey:@"searchField"];
        seachTextFild.textColor = [UIColor yzh_fontShallowBlack];
        seachTextFild.font = [UIFont yzh_commonFontStyleFontSize:14];
        self.textField = seachTextFild;
        //修改光标颜色
        [seachTextFild setTintColor:[UIColor blueColor]];
        
        for (id cencelButton in [searchbar.subviews[0] subviews])
        {
            if([cencelButton isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cencelButton;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        searchbar.delegate = self;
        self.navigationItem.titleView = searchbar;
        
        _searchBar = searchbar;
    }
    return _searchBar;
}

- (YZHSearchListModel *)searchManage {
    
    if (!_searchManage) {
        _searchManage = [[YZHSearchListModel alloc] init];
    }
    return _searchManage;
}

- (NSMutableArray *)teamTagArray {
    
    if (!_teamTagArray) {
        YZHUserInfoExtManage* userInfo = [YZHUserInfoExtManage currentUserInfoExt];
        _teamTagArray = [[NSMutableArray alloc] init];
        for (YZHUserGroupTagModel* model in userInfo.groupTags.mutableCopy) {
            [_teamTagArray addObject:model.tagName];
        }
        if (_teamTagArray.count) {
            [_teamTagArray addObject:@"无标签群"];
        }
    }
    return _teamTagArray;
}

@end
