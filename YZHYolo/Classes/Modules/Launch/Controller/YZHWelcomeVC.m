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

@interface YZHWelcomeVC ()

@property(nonatomic, strong)YZHWelcomeView* welcomeView;

@end

@implementation YZHWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self keyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    // 移除通知.
    [self an_unsubscribeKeyboard];
}

#pragma mark -- SettingView

- (void)setupView{
    
    YZHWelcomeView* welcomeView = [[NSBundle mainBundle] loadNibNamed:@"YZHWelcomeView" owner:nil options:nil].lastObject;
    
    welcomeView.frame = self.view.bounds;
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
    
    [self.welcomeView.phoneTextField becomeFirstResponder];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
