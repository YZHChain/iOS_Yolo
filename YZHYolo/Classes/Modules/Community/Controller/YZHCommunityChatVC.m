//
//  YZHCommunityChatVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommunityChatVC.h"

@interface YZHCommunityChatVC ()

@end

@implementation YZHCommunityChatVC

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

- (void)setupNavBar
{
    self.navigationItem.title = @"社群";
    
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton addTarget:self action:@selector(gotoUserDetails:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setImage:[UIImage imageNamed:@"session_rightItemBar_normal"] forState:UIControlStateNormal];
    //    [rightItemButton setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [rightItemButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

#pragma mark - 5.Event Response

- (void)gotoUserDetails:(UIBarButtonItem *)sender {
    
    [YZHRouter openURL:kYZHRouterCommunityCard info:@{
                                                            @"isTeamOwner":@(YES),
                                                            @"teamId":self.teamId
                                                            }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

@end
