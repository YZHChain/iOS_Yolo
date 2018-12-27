//
//  YZHCommunityChatVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommunityChatVC.h"

#import "YZHPrivateChatConfig.h"
#import "YZHUserCardAttachment.h"
#import "YZHTeamCardAttachment.h"
#import "YZHSessionMsgConverter.h"
#import "YZHSpeedyResponseAttachment.h"


#import "NTESSessionUtil.h"
#import "NTESSessionSnapchatContentView.h"

#import "NIMKitMediaFetcher.h"

#import "NIMContactSelectViewController.h"
#import "NIMNormalTeamCardViewController.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "NIMKitMediaFetcher.h"
#import "NIMSessionViewController.h"
#import "UIView+Toast.h"
#import "NIMMessageMaker.h"
#import "NIMKitInfoFetchOption.h"
#import "NTESVideoViewController.h"

#import "YZHPrivateChatConfig.h"
#import "YZHUserCardAttachment.h"
#import "YZHTeamCardAttachment.h"
#import "YZHAddFirendAttachment.h"
#import "YZHSessionMsgConverter.h"
#import "YZHRequstAddFirendAttachment.h"
#import "YZHSpeedyResponseAttachment.h"

#import "NTESSessionUtil.h"
#import "NTESTimerHolder.h"
//#import "NTESSnapchatAttachment.h"
#import "NTESGalleryViewController.h"
#import "NTESSessionSnapchatContentView.h"
#import "NTESSnapchatAttachment.h"
#import "UIActionSheet+YZHBlock.h"
#import "Reachability.h"
#import <CoreServices/UTCoreTypes.h>
#import "YZHUserModelManage.h"
#import "YZHCommunityAtMemberVC.h"

#import "YZHProgressHUD.h"
#import "YZHPrivateChatVC.h"
#import "YZHUnreadMessageView.h"
#import "YZHTeamNoticeShowView.h"
#import "YZHTeamNoticeModel.h"
#import "YZHAlertManage.h"
#import "YZHChatContentUtil.h"

@interface YZHCommunityChatVC ()<NIMInputActionDelegate, NIMTeamManagerDelegate, NIMInputDelegate>

@property (nonatomic, strong) YZHPrivateChatConfig *sessionConfig;

@property (nonatomic, strong) UIView *currentSingleSnapView;
@property (nonatomic, strong) NIMKitMediaFetcher *mediaFetcher;
@property (nonatomic, assign) NSInteger unreadNumber;
@property (nonatomic, strong) YZHUnreadMessageView* unreadMessageView;
@property (nonatomic, strong) YZHTeamNoticeShowView* noticeView;

@end

@implementation YZHCommunityChatVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWitRecentSession:(NIMRecentSession *)recentSession {
    
    self = [super initWitRecentSession:recentSession];
    if (self) {
        _unreadNumber = recentSession.unreadCount;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //1.设置导航栏
    [self setupNav];
    //2.设置view
    [self setupView];
    //3.请求数据
    [self setupData];
    //4.设置通知
    [self setupNotification];
    
    [[[NIMSDK sharedSDK] teamManager] addDelegate:self];
    
    if (self.assignMessage) {
        NSInteger number = [self.interactor findMessageIndex:self.assignMessage];
        
        if (number) {
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (id<NIMSessionConfig>)sessionConfig {
    if (_sessionConfig == nil) {
        _sessionConfig = [[YZHPrivateChatConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

- (void)dealloc {
  
    [[[NIMSDK sharedSDK] teamManager] removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNav
{
    self.navigationItem.title = [super sessionTitle];
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton addTarget:self action:@selector(gotoUserDetails:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setImage:[UIImage imageNamed:@"teamSession_rightItemBar_normal"] forState:UIControlStateNormal];
    [rightItemButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    //删除最近会话列表中有人@你的标记
    [NTESSessionUtil removeRecentSessionMark:self.session type:NTESRecentSessionMarkTypeAt];
    [self refreshTeamNoticeAndUnMessage];
}

- (void)refreshTeamNoticeAndUnMessage {
    //刷新群公告展示
    NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
    
    if (YZHIsString(team.announcement)) {
        NSDictionary* noticeDic = [team.announcement mj_JSONObject];
        NSString* announTitle = noticeDic[@"announcement"];
        if ([announTitle hasPrefix:@"@All "]) {
            announTitle = [announTitle componentsSeparatedByString:@" "].lastObject;
        }
        NSString* noticeEndTime = noticeDic[@"endTime"];
        //如果设置未设置结束时间,则始终展示, 否则需要判断当前时间与结束时间差.
        if (!YZHIsString(noticeEndTime) || [noticeEndTime isEqualToString:@"0"]) {
            self.noticeView = [[YZHTeamNoticeShowView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, 33)];
            [self.view addSubview:self.noticeView];
        } else {
            NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd HH:mm";
            
            NSDate* endTime = [fmt dateFromString:noticeEndTime];
            NSDate* currentTime = [NSDate date];
            NSTimeInterval currentTimeinter = [currentTime timeIntervalSince1970] * 1;
            NSTimeInterval endTimeInter = [endTime timeIntervalSince1970] * 1;
            NSTimeInterval timeDifference = endTimeInter - currentTimeinter;
            if (timeDifference > 0) {
                self.noticeView = [[YZHTeamNoticeShowView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, 33)];
                [self.view addSubview:self.noticeView];
            } else {
                [self.noticeView removeFromSuperview];
            }
        }
        
        self.noticeView.titleLabel.text = [NSString stringWithFormat:@"[群主]发布了新公告: %@",announTitle];
        self.noticeView.contentLabel.text = announTitle;
        
        [self.noticeView.showButton addTarget:self action:@selector(onTouchTeamShowNoticeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.noticeView.shadowButton addTarget:self action:@selector(onTouchTeamCloseNoticeView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(33);
            make.width.mas_equalTo(YZHScreen_Width);
        }];
        
        [self.noticeView.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        [self.noticeView.shadowButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        [self.noticeView.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(33);
        }];
        
        [self.noticeView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.right.mas_equalTo(-14);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];
        
        [self.noticeView.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        [self.noticeView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.noticeView.titleView.mas_bottom).mas_equalTo(0);
            make.height.mas_equalTo(83);
        }];
        
        [self.noticeView.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        [self.noticeView.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(19);
            make.right.mas_equalTo(-19);
            make.top.mas_equalTo(11);
            make.bottom.mas_equalTo(-11);
        }];
        self.noticeView.contentView.hidden = YES;
        self.noticeView.shadowView.hidden = YES;
    }
    
    if (self.unreadNumber > 20) {
        YZHUnreadMessageView* unreadView =  [[YZHUnreadMessageView alloc] initWithUnreadNumber:self.unreadNumber];
        self.unreadMessageView = unreadView;
        [self.unreadMessageView.readButton addTarget:self action:@selector(onTouchReadMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:unreadView];
        __block CGFloat topConstraint = 40;
        if (self.noticeView.superview) {
            topConstraint += self.noticeView.height;
        } else {
        }
        [unreadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(topConstraint);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(25);
        }];

        [unreadView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.height.mas_equalTo(13);
        }];
        
        [unreadView.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark -- ImputView
// 设置输入框
- (void)setupInputView
{
    if ([self shouldShowInputView])
    {
        self.sessionInputView = [[NIMInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,0) config:self.sessionConfig];
        self.sessionInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.sessionInputView setSession:self.session];
        [self.sessionInputView setInputDelegate:self];
        [self.sessionInputView setInputActionDelegate:self];
        [self.sessionInputView refreshStatus:NIMInputStatusText];
        [self.view addSubview:self.sessionInputView];
    }
}
//是否需要显示输入框 : 某些场景不需要显示输入框，如使用 3D touch 的场景预览会话界面内容
- (BOOL)shouldShowInputView
{
    BOOL should = YES;
    if ([self.sessionConfig respondsToSelector:@selector(disableInputView)]) {
        should = ![self.sessionConfig disableInputView];
    }
    return should;
}

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers
{
    __block NIMMessage* message = [NIMMessageMaker msgWithText:text];
    
    if (atUsers.count)
    {
        NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
        apnsOption.forcePush = YES;
        if ([atUsers.firstObject isEqualToString:kYZHTeamAtMemberAtAllKey]) {
            apnsOption.userIds = nil;
        } else {
            apnsOption.userIds = atUsers;
        }
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        
        NSString *me = [[NIMKit sharedKit].provider infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option].showName;
        apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你",me];
        message.apnsMemberOption = apnsOption;
        [self sendMessage:message];
    } else {
        [YZHChatContentUtil checkoutContentContentTeamId:text completion:^(NIMTeam * _Nonnull team) {
            if (team) {
                YZHTeamCardAttachment* teamCardAttachment = [[YZHTeamCardAttachment alloc] init];
                teamCardAttachment.groupName = team.teamName;
                teamCardAttachment.groupID = team.teamId;
                teamCardAttachment.groupSynopsis = team.intro;
                teamCardAttachment.groupUrl = [YZHChatContentUtil createTeamURLWithTeamId:team.teamId];
                teamCardAttachment.avatarUrl = team.avatarUrl ? team.avatarUrl : @"team_cell_photoImage_default";
                message = [YZHSessionMsgConverter msgWithTeamCard:teamCardAttachment];
                [self sendMessage:message];
            } else {
                [self sendMessage:message];
            }
        }];
    }
}

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers needResponed:(BOOL)needResponed {
    
    NIMMessage* message = [NIMMessageMaker msgWithText:text];
    if (needResponed) {
        //如果需要快捷回应时,则需要对消息进行封装成自定义消息
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
        NIMTeamMember* member = [[[NIMSDK sharedSDK] teamManager] teamMember:userId inTeam:self.session.sessionId];
        NSString* senderUserName;
        if (YZHIsString(member.nickname)) {
            senderUserName = member.nickname;
        } else {
            NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:userId];
            senderUserName = user.userInfo.nickName;
        }
        //跟去 @人数 数量,去掉 带 @Text  TODO: 拼接 @
        NSArray* array =  [text componentsSeparatedByString:@" "];
        NSMutableString* contentMutable = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < array.count; i++) {
            NSString* text = array[i];
            if (![text hasPrefix:@"@"] && text.length > 15 ) {
                [contentMutable appendString:text];
            }
        }
        YZHSpeedyResponseAttachment* attachment = [[YZHSpeedyResponseAttachment alloc] initWithTitleText:text senderUserId:userId teamNickName:team.teamName senderUserName:senderUserName];
        message = [YZHSessionMsgConverter msgWithSeepdyReponse:attachment text:text];
    }
    if (atUsers.count)
    {
        NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
        apnsOption.forcePush = YES;
        if ([atUsers.firstObject isEqualToString:kYZHTeamAtMemberAtAllKey]) {
            apnsOption.userIds = nil;
        } else {
            apnsOption.userIds = atUsers;
        }
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        
        NSString *me = [[NIMKit sharedKit].provider infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option].showName;
        apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你",me];
        message.apnsMemberOption = apnsOption;
    }
    [self sendMessage:message];
    
}

#pragma mark - NIMNormalTeamCardVCProtocol, NIMAdvancedTeamCardVCProtocol
//不太确定.
- (void)NIMNormalTeamCardVCDidSetTop:(BOOL)isTop {
    [self doTopSession:isTop];
}

- (void)NIMAdvancedTeamCardVCDidSetTop:(BOOL)isTop {
    [self doTopSession:isTop];
}
//TODO:
- (void)doTopSession:(BOOL)isTop {
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:self.session];
    if (isTop) {
        if (!recent) {
            //TODO SDK
            //            [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:self.session];
        }
        [NTESSessionUtil addRecentSessionMark:self.session type:NTESRecentSessionMarkTypeTop];
    } else {
        if (recent) {
            [NTESSessionUtil removeRecentSessionMark:self.session type:NTESRecentSessionMarkTypeTop];
        } else {}
    }
}

#pragma mark - NIMEventSubscribeManagerDelegate
//收到订阅消息, 不知道都包括哪些....
- (void)onRecvSubscribeEvents:(NSArray *)events
{
    for (NIMSubscribeEvent *event in events) {
        if ([event.from isEqualToString:self.session.sessionId]) {
            [self refreshSessionSubTitle:[NTESSessionUtil onlineState:self.session.sessionId detail:YES]];
        }
    }
}

#pragma mark - 消息发送时间截获

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
    
    [super sendMessage:message didCompleteWithError:error];
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

#pragma mark - 5.Event Response

- (void)onTouchReadMessage:(UIButton *)sender {
    //滚动到指定消息条数.
    if (self.unreadNumber <= 20) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:20 - self.unreadNumber inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        NSInteger messageCount = [self uiReadUnreadMessage: self.unreadNumber];
        NSLog(@"%ld 滚到到行数 %ld", messageCount, messageCount - self.unreadNumber);
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageCount - self.unreadNumber inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        // 上面的方法滚动不到指定行数, 暂时先这样处理。
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    // 移除
    self.unreadNumber = 0;
    [self.unreadMessageView removeFromSuperview];
    self.unreadMessageView = nil;
}

- (void)rollToAssignMessageRow:(NSInteger)messageRow {
    
    if (messageRow <= 20) {
       [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:20 - messageRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
       [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)gotoUserDetails:(UIBarButtonItem *)sender {
    
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    BOOL isTeamOwner = NO;
    NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
    if ([userId isEqualToString:team.owner]) {
        isTeamOwner = YES;
    }
    [YZHRouter openURL:kYZHRouterCommunityCard info:@{
                                                            @"isTeamOwner":@(isTeamOwner),
                                                            @"teamId":self.session.sessionId
                                                            }];
}

- (void)onTouchTeamShowNoticeView:(UIButton*)sender {

    self.noticeView.shadowView.hidden = NO;
    self.noticeView.contentView.hidden = NO;
    [self.noticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.noticeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
//        make.left.right.top.mas_equalTo(0);
    }];
//    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
}

- (void)onTouchTeamCloseNoticeView:(UIButton*)sender {
    
    self.noticeView.shadowView.hidden = YES;
    self.noticeView.contentView.hidden = YES;
    [self.noticeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(33);
    }];
//    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.mas_equalTo(0);
//        
//    }];
}

#pragma mark - Cell事件

- (BOOL)onTapAvatar:(NIMMessage *)message{
    //TODO目前两种,一种是好友,一种是临时 非好友,不知道非好友状态聊天对方 id 字段是否也是
    NSString* userId;
    if (message.isOutgoingMsg) {
        userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        //跳转用户资料.
        NSDictionary* info = @{
                               @"userId": userId,
                               };
        //这里要到我们的用户详情页里
        [YZHRouter openURL:kYZHRouterAddressBookDetails info:info];
    } else {
        userId = message.from;
        //跳转用户资料.
        NSDictionary* info = @{
                               @"userId": userId,
                               @"teamId": self.session.sessionId,
                               };
        //这里要到我们的群成员用户详情页里
        [YZHRouter openURL:kYZHRouterTeamMemberBookDetails info:info];
    }
    return YES;
}

- (BOOL)onLongPressAvatar:(NIMMessage *)message
{
    NSString *userId = [self messageSendSource:message];
//    if (YZHIsString(userId)) {
        if (self.session.sessionType == NIMSessionTypeTeam && ![userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount])
        {
            NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
            option.session = self.session;
            option.forbidaAlias = YES;
            
            NSString *nick = [[NIMKit sharedKit].provider infoByUser:userId option:option].showName;
            NSString *text = [NSString stringWithFormat:@"%@%@%@",NIMInputAtStartChar,nick,NIMInputAtEndChar];
            
            NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
            item.uid  = userId;
            item.name = nick;
            [self.sessionInputView.atCache addAtItem:item];
            
            [self.sessionInputView.toolBar insertText:text];
        }
        return YES;
//    }
}

- (NSString *)messageSendSource:(NIMMessage *)message
{
    NSString *from = nil;
    if (message.messageType == NIMMessageTypeRobot)
    {
        NIMRobotObject *object = (NIMRobotObject *)message.messageObject;
        if (object.isFromRobot)
        {
            from = object.robotId;
        }
    }
    if (!from)
    {
        from = message.from;
    }
    return from;
}

#pragma mark - Cell Actions

- (BOOL)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    //包括四种类型消息
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        } //暂时先将这三种类型独立在外层处理
    } else if ([eventName isEqualToString:NIMKitEventNameReceive]) {
        [self executeSpeedyResponseMessageModel:event.messageModel type:0];
        handled = YES;
    } else if ([eventName isEqualToString:NIMKitEventNameResponse]) {
        [self executeSpeedyResponseMessageModel:event.messageModel type:1];
        handled = YES;
    } else if ([eventName isEqualToString:NIMKitEventNameHandle]) {
        [self executeSpeedyResponseMessageModel:event.messageModel type:2];
        handled = YES;
    }
    //打开网页.跳转
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        [self openSafari:link];
        handled = YES;
    }
    else if([eventName isEqualToString:NIMDemoEventNameOpenSnapPicture])
    {
        NIMCustomObject *object = (NIMCustomObject *)event.messageModel.message.messageObject;
        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
        if(attachment.isFired){
            return handled;
        }
        UIView *sender = event.data;
        self.currentSingleSnapView = [NTESGalleryViewController alertSingleSnapViewWithMessage:object.message baseView:sender];
        handled = YES;
    }
    //    else if([eventName isEqualToString:NIMDemoEventNameCloseSnapPicture])
    //    {
    //        //点击很快的时候可能会触发两次查看，所以这里不管有没有查看过 先强直销毁掉
    //        NIMCustomObject *object = event.messageModel.message.messageObject;
    //        UIView *senderView = event.data;
    //        [senderView dismissPresentedView:YES complete:nil];
    //
    //        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
    //        if(attachment.isFired){
    //            return handled;
    //        }
    //        attachment.isFired  = YES;
    //        NIMMessage *message = object.message;
    //        if ([NTESBundleSetting sharedConfig].autoRemoveSnapMessage) {
    //            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
    //            [self uiDeleteMessage:message];
    //        }else{
    //            [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:nil];
    //            [self uiUpdateMessage:message];
    //        }
    //        [[NSFileManager defaultManager] removeItemAtPath:attachment.filepath error:nil];
    //        self.currentSingleSnapView = nil;
    //        handled = YES;
    //    }
    else if([eventName isEqualToString:NIMKitEventNameTapRobotLink])
    {
        NSString *link = event.data;
        [self openSafari:link];
        handled = YES;
    }
    //    else if ([eventName isEqualToString:NIMKitEventNameTapAudio]) {
    //        [super.interactor mediaAudioPressed:event.messageModel];
    //        handle = YES;
    //    }
    if (!handled) {
        NSAssert(0, @"invalid event");
    }
    return handled;
}

// 图片展示,
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = (NIMImageObject *)message.messageObject;
    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    item.itemId         = [message messageId];
    item.size           = [object size];
    
    NIMSession *session = [self isMemberOfClass:[YZHPrivateChatVC class]]? self.session : nil;
    
    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:session];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showVideo:(NIMMessage *)message {
    
    [YZHAlertManage showAlertMessage:@"暂不支持播放视频"];
    
}

//处理自定义消息事件
- (void)showCustom:(NIMMessage *)message
{
    //判断当前消息是否属于添加好友的消息.
    NIMCustomObject* customObject = (NIMCustomObject *)message.messageObject;
    id attachment = customObject.attachment;
    //处理添加好友点击事件.
    if ([attachment isKindOfClass:[YZHAddFirendAttachment class]]) {
        YZHAddFirendAttachment* addFirendAttachment = (YZHAddFirendAttachment *)attachment;
        NSString* fromAccount = addFirendAttachment.fromAccount;
        //判断当前是否为好友,不是则执行添加好友,并且发出一条消息.否认提示等
        if (![[NIMSDK sharedSDK].userManager isMyFriend:fromAccount]) {
        }
    } else if ([attachment isKindOfClass:[YZHSpeedyResponseAttachment class]]) { // 处理快捷相应消息
        
    }
    //普通的自定义消息点击事件可以在这里做哦~
}
// 0 为收到, 1 为回复, 2 为处理完成
- (void)executeSpeedyResponseMessageModel:(NIMMessageModel *)messageModel type:(NSInteger)type {
    
    NIMCustomObject *customObject = (NIMCustomObject*)messageModel.message.messageObject;
    YZHSpeedyResponseAttachment *attachment = (YZHSpeedyResponseAttachment *)customObject.attachment;
    NSString* userId = attachment.account;
    if (type == 0) {
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        option.forbidaAlias = YES;
        
        NSString *nick = [[NIMKit sharedKit].provider infoByUser:userId option:option].showName;
        [self onSendText:[NSString stringWithFormat:@"@\%@ 收到", nick] atUsers:@[messageModel.message.from]];
        
//        NIMCustomObject *customObject = (NIMCustomObject*)messageModel.message.messageObject;
//        YZHSpeedyResponseAttachment *attachment = (YZHSpeedyResponseAttachment *)customObject.attachment;
//        
//        attachment.canGet = YES;
//        attachment.content = @"哈哈哈哈哈,你完蛋了";
//        [[[NIMSDK sharedSDK] conversationManager] updateMessage:messageModel.message forSession:self.session completion:^(NSError * _Nullable error) {
//            if (!error) {
//                [self.tableView reloadData];
//            } else {
//                
//            }
//        }];
    } else if (type == 1) {
        
        [self onLongPressAvatar:messageModel.message];
        
    } else {
        NSLog(@"处理完成");
        NSArray* array =  [attachment.content componentsSeparatedByString:@" "];
        NSMutableString* contentMutable = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < array.count; i++) {
            NSString* text = array[i];
            if (![text hasPrefix:@"@"]) {
                [contentMutable appendString:text];
            }
        }
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        option.forbidaAlias = YES;
        
        NSString *nick = [[NIMKit sharedKit].provider infoByUser:userId option:option].showName;
        [self onSendText:[NSString stringWithFormat:@"%@ 你说的 \"\%@\" 已处理完成 ", nick, attachment.content] atUsers:@[messageModel.message.from]];
    }
}

- (void)openSafari:(NSString *)link
{
//    NSURLComponents *components = [[NSURLComponents alloc] initWithString:link];
//    if (components)
//    {
//        if (!components.scheme)
//        {
//            //默认添加 http
//            components.scheme = @"http";
//        }
//        [[UIApplication sharedApplication] openURL:[components URL]];
//    }
}
//TODO: 需修改.
- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:",
                    };
    });
    return actions;
}

#pragma mark - 导航按钮

#pragma mark - NIMTeamManagerDelegate

- (void)onTeamUpdated:(NIMTeam *)team {
  
    [self refreshTeamNoticeAndUnMessage];
}

- (void)onTeamAdded:(NIMTeam *)team {
    
    
}

- (void)onTeamRemoved:(NIMTeam *)team {
    
}

- (void)onTeamMemberChanged:(NIMTeam *)team {
    
}
#pragma mark - 菜单
//支持 转文字,转发等
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *defaultItems = [super menusItems:message];
    if (defaultItems) {
        [items addObjectsFromArray:defaultItems];
    }
    
    if ([NTESSessionUtil canMessageBeRevoked:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessage:)]];
    }
    
    return items;
    
}
// 撤回
- (void)revokeMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].chatManager revokeMessage:message completion:^(NSError * _Nullable error) {
        if (error) {
            if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送时间超过2分钟的消息，不能被撤回" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                //                DDLogError(@"revoke message eror code %zd",error.code);
                //TODO:超时了但是未返回相应错误.
                [weakSelf.view makeToast:@"消息撤回失败，请重试" duration:2.0 position:CSToastPositionCenter];
            }
        } else
        {
            NIMMessageModel *model = [self uiDeleteMessage:message];
            NIMMessage *tip = [YZHSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevoked:nil]];
            tip.timestamp = model.messageTime;
            [self uiInsertMessages:@[tip]];
            
            tip.timestamp = message.timestamp;
            // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
            [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
        }
    }];
}

#pragma mark - 辅助方法

- (BOOL)checkRTSCondition
{
    BOOL result = YES;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (self.session.sessionType == NIMSessionTypeP2P && [currentAccount isEqualToString:self.session.sessionId])
    {
        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSInteger memberNumber = team.memberNumber;
        if (memberNumber < 2)
        {
            [self.view makeToast:@"无法发起，群人数少于2人" duration:2.0 position:CSToastPositionCenter];
            result = NO;
        }
    }
    return result;
}
//不知道干嘛的
- (NIMKitMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[NIMKitMediaFetcher alloc] init];
        _mediaFetcher.limit = 1;
        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];;;
    }
    return _mediaFetcher;
}


#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (BOOL)shouldAutorotate{
    return !self.currentSingleSnapView;
}


@end
