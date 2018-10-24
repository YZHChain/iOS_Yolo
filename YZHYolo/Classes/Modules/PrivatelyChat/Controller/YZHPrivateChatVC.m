//
//  YZHPrivateChatVC.m
//  NIM
//
//  Created by Jersey on 2018/10/20.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "YZHPrivateChatVC.h"

#import "NIMContactSelectViewController.h"
#import "NIMNormalTeamCardViewController.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "NIMKitMediaFetcher.h"
#import "NIMSessionViewController.h"
#import "UIView+Toast.h"

#import "YZHPrivateChatConfig.h"
#import "NTESSessionUtil.h"
#import "NTESTimerHolder.h"
//#import "NTESSnapchatAttachment.h"
#import "YZHSessionMsgConverter.h"
#import "UIActionSheet+YZHBlock.h"
#import "NTESGalleryViewController.h"

#import "Reachability.h"
#import <CoreServices/UTCoreTypes.h>


@interface YZHPrivateChatVC ()<UIImagePickerControllerDelegate,
                               UINavigationControllerDelegate,
                               NIMSystemNotificationManagerDelegate,
                               NIMMediaManagerDelegate,
                               NTESTimerHolderDelegate,
                               NIMContactSelectDelegate,
                               NIMEventSubscribeManagerDelegate,
                               NIMNormalTeamCardVCProtocol,
                               NIMAdvancedTeamCardVCProtocol,
                               NIMInputDelegate>

@property (nonatomic, strong) YZHPrivateChatConfig *sessionConfig;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NIMKitMediaFetcher *mediaFetcher;
@property (nonatomic, strong) UIView *currentSingleSnapView;
@end

@implementation YZHPrivateChatVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏 重写覆盖父类方法.
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
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (id<NIMSessionConfig>)sessionConfig {
    if (_sessionConfig == nil) {
        _sessionConfig = [[YZHPrivateChatConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

#pragma mark - 2.SettingView and Style

- (void)setupNav {
    
    self.navigationItem.title = [super sessionTitle];
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton addTarget:self action:@selector(lookUserDetails:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setImage:[UIImage imageNamed:@"session_rightItemBar_normal"] forState:UIControlStateNormal];
//    [rightItemButton setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [rightItemButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
}

- (void)lookUserDetails:(UIButton *)sender {
    
    NSString* userId = self.session.sessionId;
    //跳转用户资料.
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
}
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

- (void)reloadView {
    
}

#pragma mark - NIMNormalTeamCardVCProtocol, NIMAdvancedTeamCardVCProtocol
//不太确定.
- (void)NIMNormalTeamCardVCDidSetTop:(BOOL)isTop {
    [self doTopSession:isTop];
}

- (void)NIMAdvancedTeamCardVCDidSetTop:(BOOL)isTop {
    [self doTopSession:isTop];
}

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

#pragma mark - NIMSystemNotificationManagerDelegate
//好像没用....
#pragma mark - 石头剪子布
#pragma mark - 实时语音
#pragma mark - 视频聊天
#pragma mark - 群组会议
#pragma mark - 文件传输
#pragma mark - 阅后即焚

//- (void)sendSnapchatMessagePath:(NSString *)path
//{
//    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
//    [attachment setImageFilePath:path];
//    [self sendMessage:[YZHSessionMsgConverter msgWithSnapchatAttachment:attachment]];
//}

//- (void)sendSnapchatMessage:(UIImage *)image
//{
//    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
//    [attachment setImage:image];
//    [self sendMessage:[YZHSessionMsgConverter msgWithSnapchatAttachment:attachment]];
//}
#pragma mark - 白板

#pragma mark - 提示消息
#pragma mark - 红包
#pragma mark - 群已读回执
#pragma mark - NIMMeidaButton
// 联系人
- (void)onTapMediaItemContact:(NIMMediaItem *)item {
    // 弹出联系人页面
    UIViewController* vc = [[UIViewController alloc] init];
    vc.navigationItem.title = @"联系人";
    [self.navigationController pushViewController:vc animated:YES];
}
// 我的社群
- (void)onTapMediaItemMyGroup:(NIMMediaItem *)item {
    // 弹出联系人页面
    UIViewController* vc = [[UIViewController alloc] init];
    vc.navigationItem.title = @"社群";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 消息发送时间截获

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if (error.code == NIMRemoteErrorCodeInBlackList)
    {
        //消息打上拉黑拒收标记，方便 UI 显示 TODO
        message.localExt = @{@"NTESMessageRefusedTag":@(true)};
        [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:self.session completion:nil];
        
        //插入一条 Tip 提示
        NIMMessage *tip = [YZHSessionMsgConverter msgWithTip:@"消息已发送，但对方拒收"];
        [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:self.session completion:nil];
    }
    [super sendMessage:message didCompleteWithError:error];
}

#pragma mark - 录音事件

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
}

#pragma mark -- Cell

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Cell事件

- (BOOL)onTapAvatar:(NIMMessage *)message{
    //TODO目前两种,一种是好友,一种是临时 非好友,不知道非好友状态聊天对方 id 字段是否也是
    NSString *userId = message.from;
    NSDictionary* info = @{
                           @"userId": userId
                           };
    //这里要到我们的用户详情页里
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:info];
    return YES;
}

#pragma mark - Cell Actions
// 图片展示,
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
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

- (void)showCustom:(NIMMessage *)message
{
    //普通的自定义消息点击事件可以在这里做哦~
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
                    @(NIMMessageTypeCustom):    @"showCustom:"};
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
            }else{
//                DDLogError(@"revoke message eror code %zd",error.code);
                //TODO:超时了但是未返回相应错误.
                [weakSelf.view makeToast:@"消息撤回失败，请重试" duration:2.0 position:CSToastPositionCenter];
            }
        }
        else
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

//- (void)sendImageMessagePath:(NSString *)path
//{

//    [self sendSnapchatMessagePath:path];
//}

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


#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (BOOL)shouldAutorotate{
    return !self.currentSingleSnapView;
}

@end
