//
//  YZHPrivatelyChatSearchVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivatelyChatSearchVC.h"

#import "YZHUserLoginManage.h"
#import "YZHSearchModel.h"
#import "YZHSearchTeamCell.h"
#import "YZHSearchRecommendSectionView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YZHUserDataManage.h"
#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "YZHPrivateChatVC.h"
#import "YZHAddBookFriendsCell.h"
#import "YZHCommandSectionView.h"
#import "YZHCommandTipView.h"
#import "YZHUserCardAttachment.h"
#import "YZHTeamCardAttachment.h"
#import "YZHAddFirendAttachment.h"
#import "YZHRequstAddFirendAttachment.h"
#import "YZHSpeedyResponseAttachment.h"

static NSString* kYZHFriendsCellIdentifier = @"YZHFriendsCellIdentifier";
@interface YZHPrivatelyChatSearchVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) YZHSearchListModel* searchManage;
@property (nonatomic, assign) int recommendPageNumber;
@property (nonatomic, assign) BOOL havaSearchModel;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, strong) NSString* lastKeyText;
@property (nonatomic, assign) int searchPageNumber;
@property (nonatomic, strong) YZHUserDataModel* userDataModel;
@property (nonatomic, strong) YZHCommandTipView* tipView;

@end

@implementation YZHPrivatelyChatSearchVC

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
    self.navigationController.title = @"私聊搜索";
    [self searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tipView];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearchStatus) {
        NSInteger section = 0;
        section = self.searchManage.searchRecentSession.count ? ++section : section;
        section = self.searchManage.searchFirends.count ? ++section : section;
        return section;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearchStatus) {
        switch (section) {
            case 0:
                return self.searchManage.searchRecentSession.count ? self.searchManage.searchRecentSession.count : self.searchManage.searchFirends.count;
                break;
            case 1:
                return self.searchManage.searchFirends.count;
                break;
            default:
                return 0;
                break;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchStatus) {
        if (indexPath.section == 0) {
            if (self.searchManage.searchRecentSession.count) {
               return [self searchTableView:tableView cellForRowAtIndexPath:indexPath];
            } else {
               return [self firendTableView:tableView cellForRowAtIndexPath:indexPath];
            }
        } else {
           return [self firendTableView:tableView cellForRowAtIndexPath:indexPath];
        }
    } else {
        return nil;
    }
}

- (UITableViewCell* )firendTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHContactMemberModel* memberModel =  [self.searchManage.searchFirends objectAtIndex:indexPath.row];
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHFriendsCellIdentifier forIndexPath:indexPath];
    [cell refreshUser:memberModel];
    
    return cell;
}

- (UITableViewCell* )searchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString * cellId = @"cellId";
        NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearchStatus) {
        switch (indexPath.section) {
            case 0:
                return self.searchManage.searchRecentSession.count ? 65 : 55;
                break;
            case 1:
                return 55;
                break;
            default:
                return 65;
                break;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHCommandSectionView* sectionView = [YZHCommandSectionView yzh_viewWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    NSString* titleText;
    if (self.isSearchStatus) {
        if (section == 0) {
            if (self.searchManage.searchRecentSession.count) {
                titleText = @"查找到的聊天";
            } else {
                titleText = @"查找到的好友";
            }
        } else {
            titleText = @"查找到的好友";
        }
        sectionView.titleLabel.text = titleText;
        return sectionView;
    } else {
        return nil;
    }
    return nil;
}
// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.isSearchStatus) {
        if (indexPath.section == 0) {
            if (self.searchManage.searchRecentSession.count) {
                 [self searchTableView:tableView didSelectRowAtIndexPath:indexPath];
            } else {
                 [self friendTableView:tableView didSelectRowAtIndexPath:indexPath];
            }
        } else {
            [self friendTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    } else {
        
    }
}

- (void)searchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NIMRecentSession *recentSession;

    recentSession = self.searchManage.searchRecentSession[indexPath.row];
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
}

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

- (void)friendTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHContactMemberModel* memberModel =  [self.searchManage.searchFirends objectAtIndex:indexPath.row];
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": memberModel.info.infoId}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar endEditing:YES];
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
        [self searchTeamListWithKeyText:searchBar.text];
        self.isSearchStatus = YES;
    } else {
        self.isSearchStatus = NO;
        [self.tableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!YZHIsString(searchBar.text)) {
        self.isSearchStatus = NO;
        [self.searchManage.searchRecentSession removeAllObjects];
        [self.searchManage.searchFirends removeAllObjects];
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        self.tipView.hidden = NO;
        self.tipView.titleLabel.text = @"输入昵称关键字搜索聊天或好友";
    }
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)searchTeamListWithKeyText:(NSString *)keyText {
    
    if (YZHIsString(keyText)) {
        [self.searchManage searchPrivateKeyText:keyText];
        [self.searchManage searchFirendKeyText:keyText];
        self.isSearchStatus = YES;
        [self.tableView reloadData];
        if (self.searchManage.searchRecentSession.count || self.searchManage.searchFirends.count) {
            self.tipView.hidden = YES;
            self.tableView.hidden = NO;
        } else {
            self.tipView.hidden = NO;
            self.tipView.titleLabel.text = @"未找到相关聊天或好友";
            self.tableView.hidden = YES;
        }
    } else {
        self.isSearchStatus = NO;
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
            text = @"发了一段语音";
            break;
        case NIMMessageTypeImage:
            text = @"发了一张图片";
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
        case NIMMessageTypeCustom:{
            //TODO:增加自定义消息解析.识别不同自定义消息格式
            NIMCustomObject *customObject = (NIMCustomObject*)lastMessage.messageObject;
            YZHUserCardAttachment* attachment = (YZHUserCardAttachment *)customObject.attachment;
            if ([attachment isKindOfClass:[YZHUserCardAttachment class]]) {
                text = @"发了一张名片";
            } else if ([attachment isKindOfClass:[YZHTeamCardAttachment class]]) {
                text = @"发了一张名片";
            } else if ([attachment isKindOfClass:[YZHAddFirendAttachment class]]) {
                text = @"请求添加友好";
            } else if ([attachment isKindOfClass:[YZHRequstAddFirendAttachment class]]) {
                text = @"请求添加好友";
            } else if ([attachment isKindOfClass:[YZHSpeedyResponseAttachment class]]) {
                text = @"快捷回执消息";
            } else {
                text = @"自定义消息";
            }
        }
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
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier:kYZHFriendsCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHCommandSectionView" bundle:nil] forCellReuseIdentifier:kYZHCommonHeaderIdentifier];
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
        searchbar.placeholder = @"模糊搜索";
        searchbar.searchBarStyle = UISearchBarStyleDefault;
        searchbar.showsCancelButton = YES;
        //通过KVC拿到textField
        UITextField  *seachTextFild = [searchbar valueForKey:@"searchField"];
        seachTextFild.textColor = [UIColor yzh_fontShallowBlack];
        seachTextFild.font = [UIFont yzh_commonFontStyleFontSize:14];
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
        if (@available(iOS 9.0, *)) {
            [[searchbar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
        } else {
            // Fallback on earlier versions
        }
        
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

- (YZHCommandTipView *)tipView {
    
    if (!_tipView) {
        _tipView = [YZHCommandTipView yzh_viewWithFrame:self.view.bounds];
        _tipView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tipView.titleLabel.text = @"输入昵称关键字搜索聊天或好友";
        UITapGestureRecognizer* tipViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchTipView:)];
        [_tipView addGestureRecognizer:tipViewGesture];
    }
    return _tipView;
}

- (void)onTouchTipView:(UIGestureRecognizer *)sender {
    
    [self.searchBar endEditing:YES];
}

- (YZHUserDataModel *)userDataModel {
    
    if (!_userDataModel) {
        _userDataModel = [[YZHUserDataManage sharedManager] currentUserData];
    }
    return _userDataModel;
}

@end
