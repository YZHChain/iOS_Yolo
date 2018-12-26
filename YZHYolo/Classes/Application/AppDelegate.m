//
//  AppDelegate.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "AppDelegate.h"
#import "YZHLaunchViewController.h"
#import "YZHRootTabBarViewController.h"
#import "YZHCellLayoutConfign.h"
#import "YZHCustomAttachmentDecoder.h"
#import "NTESNotificationCenter.h"
#import "NTESClientUtil.h"
#import "YZHUserLoginManage.h"
#import <UserNotifications/UserNotifications.h>
#import <PushKit/PushKit.h>
#import "YZHServicesConfig.h"
#import "YZHCheckVersion.h"
#import "YZHPasteSkipManage.h"

NSString* const kYZHNotificationLogout            = @"NotificationLogout";
@interface AppDelegate ()<NIMLoginManagerDelegate, PKPushRegistryDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //云信配置
    [self setupNIMSDK];
    [self setupServices];
    
    [self registerPushService];
    [self commonInitListenEvents];
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[YZHLaunchViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    YZHPasteSkipManage* pasteManage = [YZHPasteSkipManage sharedInstance];
    [pasteManage checkoutTeamPasteboard];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    YZHPasteSkipManage* pasteManage = [YZHPasteSkipManage sharedInstance];
    [pasteManage checkoutTeamPasteboard];
    return YES;
}
// 如果iOS版本是9.0及以上的，会在下面方法接受到在地址栏输入的字符串
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    YZHPasteSkipManage* pasteManage = [YZHPasteSkipManage sharedInstance];
    [pasteManage checkoutTeamPasteboard];
    return YES;
}

#pragma mark PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    if ([type isEqualToString:PKPushTypeVoIP])
    {
        [[NIMSDK sharedSDK] updatePushKitToken:credentials.token];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    NSLog(@"receive payload %@ type %@",payload.dictionaryPayload,type);
    NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
    if ([badge isKindOfClass:[NSNumber class]])
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
     NSLog(@"registry %@ invalidate %@",registry,type);
}


#pragma mark - openURL

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
////    [[NTESRedPacketManager sharedManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
////    [[NTESRedPacketManager sharedManager] application:app openURL:url options:options];
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    //目前只有红包跳转
////    return [[NTESRedPacketManager sharedManager] application:application handleOpenURL:url];
//}

#pragma mark - misc
- (void)registerPushService
{
    if (@available(iOS 11.0, *))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
            {
                dispatch_async_main_safe(^{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"请开启推送功能否则无法收到推送通知" duration:2.0 position:CSToastPositionCenter];
                })
            }
        }];
    }
    else
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    //pushkit
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}


#pragma mark -- IM Configuration

- (void)setupServices
{
//    [[NTESLogManager sharedManager] start];
    [[NTESNotificationCenter sharedCenter] start];
//    [[NTESSubscribeManager sharedManager] start];
//    [[NTESRedPacketManager sharedManager] start];
}

- (void)setupNIMSDK {
    
    NSString *appKey;
#if DEBUG
    //  配置测试服,会检测是否开启,否则使用正式
    appKey = [YZHServicesConfig debugTestNIMAppKeyConfig];
#else
    appKey = [YZHServicesConfig stringForKey:kYZHAppConfigNIMAppKey];
#endif
    
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = nil;
    option.pkCername        = nil;
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[YZHCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排
    [[NIMKit sharedKit] registerLayoutConfig:[YZHCellLayoutConfign new]];
    //定制 UI 配置器
    NIMKitConfig* config = [[NIMKitConfig alloc] init];
    config.avatarType = NIMKitAvatarTypeRadiusCorner;
    [NIMKit sharedKit].config = config;
}

#pragma mark -- NIMLoginManagerDelegate

-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYZHNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:kYZHNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

- (void)setupLoginViewController
{
    YZHUserLoginManage* manage = [YZHUserLoginManage sharedManager];
    // 清空缓存用户信息
    [manage setCurrentLoginData:nil];
    // 跳转至登录页
    [manage executeHandInputLogin];
}

#pragma mark - 注销

-(void)logout:(NSNotification *)note
{
    [self doLogout];
}

- (void)doLogout
{
    [self setupLoginViewController];
}

@end
