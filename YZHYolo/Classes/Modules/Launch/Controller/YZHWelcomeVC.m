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

@interface YZHWelcomeVC ()

@property(nonatomic, strong)YZHWelcomeView* welcomeView;

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
    [self.welcomeView addSubview:scroollView];
    scroollView.autoScrollTimeInterval = 2;
    scroollView.currentPageDotImage = [UIImage imageNamed:@"welcome_cover_currentPageDotImage"];
    scroollView.pageDotImage = [UIImage imageNamed:@"welcome_cover_pageDotImage"];
    scroollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    scroollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        [self.view endEditing:YES];
    };
    
    [self.view addSubview:self.welcomeView];
    
//    [self.welcomeView.phoneTextField becomeFirstResponder];
}

- (NSArray*)imagesForBanner{
    
    return @[@"welcome_background_cover",@"welcome_background_cover",@"welcome_background_cover"];
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
        [self setupRegistEvent];
    };
    self.welcomeView.loginButtonBlock = ^(UIButton *sender) {
        @strongify(self)
        [self setupLoginEvent];
    };
}

- (void)setupRegistEvent {
    // 检测 ID 是否可用. TODO
    YZHParams params = @{
                         @"yoloNo":self.welcomeView.phoneTextField.text
                         };
    YZHProgressHUD *hud = [YZHProgressHUD showLoadingOnView:self.welcomeView text:nil];
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_CHECKOUTYOLOID params:params successCompletion:^(id obj) {
        [hud hideWithText:nil];
        // 请求后台对手机号做校验 弹出相应框 通过则引导其去注册
        [YZHAlertManage showAlertTitle:nil message:@"该账号尚未注册、是否马上去注册" actionButtons:@[@"返回",@"去注册"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [YZHRouter openURL:kYZHRouterRegister info: @{@"hiddenBack": @(YES),@"phoneNumberString": self.welcomeView.phoneTextField.text, kYZHRouteBackIndex: @(1)}];
            }
        }];
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
