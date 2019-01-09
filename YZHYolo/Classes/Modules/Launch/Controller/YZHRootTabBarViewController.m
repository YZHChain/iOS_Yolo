//
//  YZHRootTabBarViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRootTabBarViewController.h"
#import "YZHTabBarModel.h"
#import "YZHBaseNavigationController.h"
#import "UIColor+YZHColorStyle.h"
#import "YZHDiscoverVC.h"
#import "AppDelegate.h"
#import "UITabBar+YZHBadge.h"
#import "YZHRecentSessionExtManage.h"

NSString* const kYZHSelectedDiscoverNotifaction = @"kYZHSelectedDiscoverNotifaction";
typedef NS_ENUM(NSInteger, YZHRootTabBarType) {
    
    YZHRootTabBarTypeCommunity = 0,
    YZHRootTabBarTypePrivately,
    YZHRootTabBarTypeAddressBook,
    YZHRootTabBarTypeDiscover,
    YZHRootTabBarTypeMycenter,
};

@interface YZHRootTabBarViewController ()<UITabBarControllerDelegate, NIMSystemNotificationManagerDelegate, NIMConversationManagerDelegate>

@property (nonatomic, assign) NSInteger communityUnreadCount;
@property (nonatomic, assign) NSInteger privatelyUnreadCount;
@property (nonatomic, assign) NSInteger addressBookUnreadCount;
@property (nonatomic, strong) YZHRecentSessionBadgeExtManage* recentsExtManage;

@end

@implementation YZHRootTabBarViewController

+ (instancetype)instance {
    
    UIViewController* rootVC = YZHAppWindow.rootViewController;
    if ([rootVC isKindOfClass:[YZHRootTabBarViewController class]]) {
        return (YZHRootTabBarViewController *)rootVC;
    } else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
    [self refreshCommunitySessionBadge];
    [self refreshPrivatelySessionBadge];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //会话界面发送拍摄的视频，拍摄结束后点击发送后可能顶部会有红条，导致的界面错位。
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)dealloc {
    
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetView

- (void)setupView{
    
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor whiteColor];
    //TODO:
    self.tabBar.backgroundImage = [UIImage imageNamed:@""];
    
    YZHTabBarItems *viewModel = [[YZHTabBarItems alloc] init];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (int i=0; i<viewModel.itemsModel.count; i++) {
        YZHTabBarModel *itemModel = viewModel.itemsModel[i];
        Class clazz = NSClassFromString(itemModel.viewController);
        UIViewController *vc = [[clazz alloc] init];
        if (itemModel.hasNavigation) {
            vc = [[YZHBaseNavigationController alloc] initWithRootViewController:vc];
        }
        [vcs addObject:vc];
    }
    [self setViewControllers:vcs];
    
    for (int i=0; i < self.tabBar.items.count; i++) {
        YZHTabBarModel *itemModel = viewModel.itemsModel[i];
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
        tabBarItem.title = itemModel.title;
        tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        //图片
        
        UIImage *defaultImgge = [UIImage imageNamed:itemModel.image];
        UIImage *selectedImgge = [UIImage imageNamed:itemModel.selectedImage];
        tabBarItem.image = [defaultImgge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.selectedImage = [selectedImgge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //文字颜色
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor yzh_colorWithHexString:itemModel.color]}
                                  forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor yzh_colorWithHexString:itemModel.selectedColor]}
                                  forState:UIControlStateSelected];
        
    }
    self.selectedIndex = 0;
    self.delegate = self;
    
}

#pragma mark - NIMConversationManagerDelegate

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount {
    
    [self.recentsExtManage addRecentSession:recentSession];
    [self refreshSessionBadge];
    [self hideBadgeWithTotalUnreadCount:totalUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {

    [self.recentsExtManage refreshRecentSession:recentSession];
    [self refreshSessionBadge];
    [self hideBadgeWithTotalUnreadCount:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount {
    
//    [self.recentsExtManage configuration];
    [self.recentsExtManage removeRecentSession:recentSession];
    [self refreshSessionBadge];
    [self hideBadgeWithTotalUnreadCount:totalUnreadCount];
}

- (void)messagesDeletedInSession:(NIMSession *)session {
    self.communityUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    NIMRecentSession* recentSession = [[[NIMSDK sharedSDK] conversationManager] recentSessionBySession:session];
    if (recentSession) {
        [self.recentsExtManage removeRecentSession:recentSession];
    }
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    
    self.communityUnreadCount = 0;
    [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypeCommunity];
    [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypePrivately];
}

- (void)allMessagesRead
{
    self.communityUnreadCount = 0;
    [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypeCommunity];
    [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypePrivately];
}

- (void)hideBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {
    
    if (!totalUnreadCount) {
        [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypeCommunity];
        [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypePrivately];
    }
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    self.addressBookUnreadCount = unreadCount;
    [self refreshAddressSessionBadge];
}

#pragma mark -- UITabBarControllerDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if ([item.title isEqualToString:@"广场"]) {
        YZHBaseNavigationController* baseNav = [self.viewControllers objectAtIndex: YZHRootTabBarTypeDiscover];
        YZHDiscoverVC* discover = (YZHDiscoverVC*)baseNav.viewControllers.firstObject;
        if ([discover isKindOfClass:[YZHDiscoverVC class]]) {
            [discover refreshView];
        }
        //TODO: https://www.jianshu.com/p/80939746e48c
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickDiscouver" object:nil];
//        }];
    }
    
}

#pragma mark -- RefreshTabbarItemBadge

- (void)refreshSessionBadge {

    [self refreshCommunitySessionBadge];
    [self refreshPrivatelySessionBadge];
}

- (void)refreshCommunitySessionBadge {
    
    if (self.recentsExtManage.communityBadge) {
        [self.tabBar yzh_showBadgeOnItemIndex:YZHRootTabBarTypeCommunity];
    } else {
        [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypeCommunity];
    }
}

- (void)refreshPrivatelySessionBadge {
    
    if (self.recentsExtManage.privatelyBadge) {
        [self.tabBar yzh_showBadgeOnItemIndex:YZHRootTabBarTypePrivately];
    } else {
        [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypePrivately];
    }
}

- (void)refreshAddressSessionBadge {
    
    if (self.addressBookUnreadCount) {
        [self.tabBar yzh_showBadgeOnItemIndex:YZHRootTabBarTypeAddressBook];
    } else {
        [self.tabBar yzh_hideBadgeOnItemIndex:YZHRootTabBarTypeAddressBook];
    }
}

- (YZHRecentSessionBadgeExtManage *)recentsExtManage {
    
    if (!_recentsExtManage) {
        _recentsExtManage = [[YZHRecentSessionBadgeExtManage alloc] init];
        
    }
    return _recentsExtManage;
}

@end
