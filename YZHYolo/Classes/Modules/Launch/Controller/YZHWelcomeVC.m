//
//  YZHWelcomeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHWelcomeVC.h"

#import "YZHWelcomeView.h"
#import "SDCycleScrollView.h"
#import "TAPageControl.h"
#import "UIViewController+KeyboardAnimation.h"
#import "YZHPublic.h"
#import "YZHPageControlView.h"

@interface YZHWelcomeVC ()

@property (nonatomic, strong) YZHWelcomeView* welcomeView;
@property (nonatomic, strong) SDCycleScrollView* cycleScrollView;
@property (nonatomic, strong) YZHPageControlView* controlView;


@end

@implementation YZHWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNav];
    
    [self setupView];
    
    [self setupViewResponseEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self keyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    // 移除通知.
    [self an_unsubscribeKeyboard];
}

#pragma mark -- SettingView

- (void)setupNav {
 
   self.hideNavigationBar = YES;
}

- (void)setupView {
    // TODO:低版本出现约束冲突.
    YZHWelcomeView* welcomeView = [YZHWelcomeView yzh_viewWithFrame:self.view.bounds];
    // 立即刷新视图,使约束更新.
    [welcomeView layoutIfNeeded];
    self.welcomeView = welcomeView;
    
    NSArray *images = [self imagesForBanner];
    CGRect frame = welcomeView.bannerView.frame;
    SDCycleScrollView* scroollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageNamesGroup:images];
    scroollView.showPageControl = NO;
    scroollView.autoScroll = YES;
    scroollView.autoScrollTimeInterval = 2.5;
    _cycleScrollView = scroollView;
    
    [self.welcomeView addSubview:scroollView];
    [self.view addSubview:self.welcomeView];
    
    _controlView = [[YZHPageControlView alloc] initWithFrame:CGRectMake(0, 33, 33 * 3 + 19 * 2, 10)];
    _controlView.centerX = self.welcomeView.centerX;
    _controlView.selectedIndex = 0;

    [self.welcomeView addSubview:_controlView];
    
    @weakify(self)
    self.cycleScrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        @strongify(self)
        self.controlView.selectedIndex = currentIndex;
    };
    self.cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        @strongify(self)
        [self.view endEditing:YES];
    };
    self.controlView.executeBlock = ^(NSInteger selectedIndex) {
        @strongify(self)
       [self.cycleScrollView makeScrollViewScrollToIndex:selectedIndex];
    };
    
    [self.welcomeView.phoneTextField becomeFirstResponder];
}

- (NSArray*)imagesForBanner{
    
    return @[@"welcome_background_cover1",@"welcome_background_cover2",@"welcome_background_cover3",@"welcome_background_cover4"];
}

- (void)keyboardNotification{
    
    @weakify(self)
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        @strongify(self)
        if (isShowing) {
            // TODO: 小屏时最好修改一下.
            self.welcomeView.y = - (keyboardRect.size.height);
        } else {
            self.welcomeView.y = 0;
        }
        [self.welcomeView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Event Response
// 使设置 ExecuteBlock 回调与分离出来, 有利于调试, 提高 Code 可读性
- (void)setupViewResponseEvent {
    
    @weakify(self)
    self.welcomeView.regesterButtonBlock = ^(UIButton *sender) {
        @strongify(self)
        [self gotoRigister];
    };
    self.welcomeView.loginButtonBlock = ^(UIButton *sender) {
        @strongify(self)
        [self setupLoginEvent];
    };
}

#pragma mark - 新版注册登录

- (void)gotoRigister {
    
    [YZHRouter openURL:kYZHRouterRegister info: @{@"hiddenBack": @(YES), kYZHRouteBackIndex: @(1)}];
}

- (void)gotoLogin {
    
    [YZHRouter openURL:kYZHRouterLogin info: @{kYZHRouteBackIndex: @(1)}];
}

#pragma mark --

- (void)setupRegistEvent {
    // 检测 ID 是否可用. TODO
    YZHParams params = @{
                         @"phone":self.welcomeView.phoneTextField.text
                         };
    YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:self.welcomeView text:nil];
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_CHECKOUPHONE params:params successCompletion:^(id obj) {
        [hud hideWithText:nil];
        if ([obj isEqualToString:@"621"]) {
            // 请求后台对手机号做校验 弹出相应框 通过则引导其去登录
            [YZHAlertManage showAlertTitle:nil message:@"该账号已注册、是否马上去登录" actionButtons:@[@"返回",@"去登录"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [YZHRouter openURL:kYZHRouterLogin info:@{@"phoneString": self.welcomeView.phoneTextField.text, kYZHRouteBackIndex: @(1)}];
                }
            }];
        } else {
            // 请求后台对手机号做校验 弹出相应框 通过则引导其去注册
            [YZHAlertManage showAlertTitle:nil message:@"该账号尚未注册、是否马上去注册" actionButtons:@[@"返回",@"去注册"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [YZHRouter openURL:kYZHRouterRegister info: @{@"hiddenBack": @(YES),@"phoneNumberString": self.welcomeView.phoneTextField.text, kYZHRouteBackIndex: @(1)}];
                }
            }];
        }

    } failureCompletion:^(NSError *error) {
        
        [hud hideWithText:error.domain];
    }];

}

- (void)setupLoginEvent {
    NSDictionary *info;
    if (YZHIsString(self.welcomeView.phoneTextField.text)) {
        info = @{kYZHRouteBackIndex: @(1),
                 @"phoneString": self.welcomeView.phoneTextField.text};
    } else {
        info = @{kYZHRouteBackIndex: @(1)};
    }
    [YZHRouter openURL:kYZHRouterLogin info:info];
}

@end
