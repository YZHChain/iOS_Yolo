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

@interface YZHCommunityChatVC ()<NIMInputActionDelegate>

@property (nonatomic, strong) YZHPrivateChatConfig *sessionConfig;

@property (nonatomic, copy) void (^sharedPersonageCardHandle)(YZHUserCardAttachment*);
@property (nonatomic, copy) void (^sharedTeamCardHandle)(YZHTeamCardAttachment*);
@property (nonatomic, strong) UIView *currentSingleSnapView;
@property (nonatomic, strong) NIMKitMediaFetcher *mediaFetcher;

@end

@implementation YZHCommunityChatVC

#pragma mark - 1.View Controller Life Cycle

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

#pragma mark - 2.SettingView and Style

- (void)setupNav
{
    self.navigationItem.title = [super sessionTitle];
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton addTarget:self action:@selector(gotoUserDetails:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setImage:[UIImage imageNamed:@"session_rightItemBar_normal"] forState:UIControlStateNormal];
    [rightItemButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    //删除最近会话列表中有人@你的标记
    [NTESSessionUtil removeRecentSessionMark:self.session type:NTESRecentSessionMarkTypeAt];
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
//        [self.sessionInputView setInputDelegate:self];
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
    NIMMessage* message = [NIMMessageMaker msgWithText:text];
    
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

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers needResponed:(BOOL)needResponed {
    
    NIMMessage* message = [NIMMessageMaker msgWithText:text];
    
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
    if (needResponed) {
        //如果需要快捷回应时,则需要对消息进行封装成自定义消息
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        YZHSpeedyResponseAttachment* attachment = [[YZHSpeedyResponseAttachment alloc] initWithTitleText:text senderUserId:userId teamNickName:@"泽西"];
        message = [YZHSessionMsgConverter msgWithSeepdyReponse:attachment text:text];
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

// 联系人
- (void)onTapMediaItemContact:(NIMMediaItem *)item {
    
    [YZHRouter openURL:kYZHRouterSessionSharedCard info:@{
                                                          @"sharedType": @(1),
                                                          kYZHRouteSegue: kYZHRouteSegueModal,
                                                          kYZHRouteSegueNewNavigation: @(YES),
                                                          @"sharedPersonageCardBlock": self.sharedPersonageCardHandle
                                                          }];
}
// 我的社群
- (void)onTapMediaItemMyGroup:(NIMMediaItem *)item {
    // 弹出联系人页面
    [YZHRouter openURL:kYZHRouterSessionSharedCard info:@{
                                                          @"sharedType": @(2),
                                                          kYZHRouteSegue: kYZHRouteSegueModal,
                                                          kYZHRouteSegueNewNavigation: @(YES),
                                                          @"sharedTeamCardBlock": self.sharedTeamCardHandle
                                                          }];
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

#pragma mark - Cell事件
/*
- (BOOL)onTapAvatar:(NIMMessage *)message{
    //TODO目前两种,一种是好友,一种是临时 非好友,不知道非好友状态聊天对方 id 字段是否也是
    NSString* userId;
    if (message.isOutgoingMsg) {
        userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    } else {
        userId = message.session.sessionId;
    }
    NSDictionary* info = @{
                           @"userId": userId
                           };
    //这里要到我们的用户详情页里
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:info];
    return YES;
}
 */

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
    
    if (type == 0) {
        NSLog(@"收到了");
    } else if (type == 1) {
        NSLog(@"快捷回复");
    } else {
        NSLog(@"处理完成");
    }
}

- (void)openSafari:(NSString *)link
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:link];
    if (components)
    {
        if (!components.scheme)
        {
            //默认添加 http
            components.scheme = @"http";
        }
        [[UIApplication sharedApplication] openURL:[components URL]];
    }
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

- (void (^)(YZHUserCardAttachment *))sharedPersonageCardHandle {
    
    if (!_sharedPersonageCardHandle) {
        @weakify(self)
        _sharedPersonageCardHandle = ^(YZHUserCardAttachment *userCard) {
            @strongify(self)
            [self sendMessage:[YZHSessionMsgConverter msgWithUserCard:userCard]];
        };
    }
    return _sharedPersonageCardHandle;
}

- (void (^)(YZHTeamCardAttachment *))sharedTeamCardHandle {
    
    if (!_sharedTeamCardHandle) {
        @weakify(self)
        _sharedTeamCardHandle = ^(YZHTeamCardAttachment *teamCard) {
            @strongify(self)
            [self sendMessage:[YZHSessionMsgConverter msgWithTeamCard:teamCard]];
        };
    }
    return _sharedTeamCardHandle;
}

@end
