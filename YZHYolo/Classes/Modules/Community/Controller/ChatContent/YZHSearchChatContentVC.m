//
//  YZHSearchChatContentVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchChatContentVC.h"

#import "NIMSessionListCell.h"
#import "YZHSearchModel.h"
#import "NIMKitUtil.h"
#import "NIMAvatarImageView.h"
#import "YZHPrivateChatVC.h"
#import "YZHCommandTipView.h"
#import "YZHSearchChatContentModel.h"
#import "YZHCommandSectionView.h"
#import "YZHTextChatContentCell.h"
#import "UIImageView+YZHImage.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMKitInfo.h"
#import "YZHCommunityChatVC.h"
#import "YZHUserCardAttachment.h"
#import "YZHTeamCardAttachment.h"
#import "YZHAddFirendAttachment.h"
#import "YZHRequstAddFirendAttachment.h"
#import "YZHSpeedyResponseAttachment.h"

@interface YZHSearchChatContentVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, assign) BOOL havaSearchModel;
@property (nonatomic, strong) YZHCommandTipView* tipView;
@property (nonatomic, strong) YZHSearchChatContentModel* searchManage;
@property (nonatomic, assign) NIMSessionType* sessionType;

@end

@implementation YZHSearchChatContentVC


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
    self.navigationController.title = @"聊天内容搜索";
    self.navigationItem.leftBarButtonItem = nil;
    [self searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tipView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.isSearchStatus) {
        if (self.havaSearchModel) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isSearchStatus) {
        if (self.havaSearchModel) {
            return self.searchManage.searchTextMessages.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NIMMessage* message = self.searchManage.searchTextMessages[indexPath.row];
    CGFloat width = tableView.width - 65 - 15;
    CGFloat height = [self getLabelHeightWithText:message.text width:width uiFont:[UIFont yzh_commonFontStyleFontSize:13]];
    if (height <= 24) {
        return 65;
    } else {
        return 65 + height - 24 + 10;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHTextChatContentCell * cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier];
    NIMMessage* message = self.searchManage.searchTextMessages[indexPath.row];
    cell.contentLabel.text = message.text;
    
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.session = self.session;
    NIMKitInfo* userInfo;
    if (self.session.sessionType == NIMSessionTypeTeam) {
        userInfo = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
        if (userInfo.avatarUrlString) {
            [cell.avatarImageView yzh_setImageWithString:userInfo.avatarUrlString placeholder:@"team_cell_photoImage_default"];
        } else {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"team_cell_photoImage_default"]];
        }
    } else {
        userInfo = [[NIMKit sharedKit].provider infoByUser:message.from option:option];
        if (userInfo.avatarUrlString) {
            [cell.avatarImageView yzh_setImageWithString:userInfo.avatarUrlString placeholder:@"addBook_cover_cell_photo_default"];
        } else {
            [cell.avatarImageView setImage:[UIImage imageNamed:@"addBook_cover_cell_photo_default"]];
        }
    }
    cell.contentLabel.text = message.text;
    cell.dateLabel.text = [NIMKitUtil showTime:message.timestamp showDetail:NO];
    if (YZHIsString(userInfo.nickName)) {
        cell.nickNameLabel.text = userInfo.nickName;
    } else {
        cell.nickNameLabel.text = userInfo.showName;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHCommandSectionView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHCommonHeaderIdentifier];
    if (!view) {
        view = [YZHCommandSectionView yzh_viewWithFrame:CGRectZero];
    }
    view.titleLabel.text = @"搜索到的聊天内容";
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NIMMessage *message;
    
    message = self.searchManage.searchTextMessages[indexPath.row];
    NIMRecentSession* recentSession = [[[NIMSDK sharedSDK] conversationManager] recentSessionBySession:_session];
    if (self.session.sessionType == NIMSessionTypeTeam) {
        
        YZHCommunityChatVC* teamChatVC = [[YZHCommunityChatVC alloc] initWitRecentSession:recentSession];
        teamChatVC.assignMessage = message;
        [self.navigationController pushViewController:teamChatVC animated:YES];
    } else {
        YZHPrivateChatVC* privateChatVC = [[YZHPrivateChatVC alloc] initWitRecentSession:recentSession];
        privateChatVC.assignMessage = message;
        [self.navigationController pushViewController:privateChatVC animated:YES];
    }
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
        [self.searchManage.searchTextMessages removeAllObjects];
        self.havaSearchModel = NO;
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        self.tipView.hidden = NO;
        self.tipView.titleLabel.text = @"输入您要查找的聊天记录";
    }
}

#pragma mark - 5.Event Response

- (void)searchTeamListWithKeyText:(NSString *)keyText {
    
    if (YZHIsString(keyText)) {
        [self.searchManage searchPrivateContentKeyText:keyText];
        self.isSearchStatus = YES;
        if (self.searchManage.searchTextMessages.count) {
            self.havaSearchModel = YES;
            self.tipView.hidden = YES;
            self.tableView.hidden = NO;
        } else {
            self.havaSearchModel = NO;
            self.tipView.titleLabel.text = @"未找到相关聊天记录";
            self.tipView.hidden = NO;
            self.tableView.hidden = YES;
        }
        [self.tableView reloadData];
    } else {
        self.havaSearchModel = NO;
        self.isSearchStatus = NO;
        self.tipView.hidden = NO;
        self.tipView.titleLabel.text = @"输入您要查找的聊天记录";
        [self.tableView reloadData];
    }
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

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width uiFont: (UIFont*)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHTextChatContentCell" bundle:nil] forCellReuseIdentifier:kYZHCommonCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHCommandSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHCommonHeaderIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 65;
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
        if (@available(iOS 9.0, *)) {
            [[searchbar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
        } else {
            // Fallback on earlier versions
        }
        self.navigationItem.titleView = searchbar;
        
        _searchBar = searchbar;
    }
    return _searchBar;
}

- (YZHCommandTipView *)tipView {
    
    if (!_tipView) {
        _tipView = [YZHCommandTipView yzh_viewWithFrame:self.view.bounds];
        _tipView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tipView.titleLabel.text = @"输入您要查找的聊天记录";
        UITapGestureRecognizer* tipViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchTipView:)];
        [_tipView addGestureRecognizer:tipViewGesture];
    }
    return _tipView;
}

- (void)onTouchTipView:(UIGestureRecognizer *)sender {
    
    [self.searchBar endEditing:YES];
}

- (YZHSearchChatContentModel *)searchManage {
    
    if (!_searchManage) {
        _searchManage = [[YZHSearchChatContentModel alloc] initWithSession:_session allTextMessages: _allTextMessages];
    }
    return _searchManage;
}

@end
