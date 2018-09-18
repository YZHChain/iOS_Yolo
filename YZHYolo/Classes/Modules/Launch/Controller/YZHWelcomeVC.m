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
}

- (NSArray*)imagesForBanner{
    
    return @[@"welcome_background_cover",@"welcome_background_cover",@"welcome_background_cover"];
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
