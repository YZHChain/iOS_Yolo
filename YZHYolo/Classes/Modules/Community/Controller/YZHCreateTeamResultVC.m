//
//  YZHCreateTeamResultVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/1.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCreateTeamResultVC.h"

#import "UIViewController+YZHTool.h"

@interface YZHCreateTeamResultVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addShareTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *addFirendButton;
@property (weak, nonatomic) IBOutlet UIButton *gotoTeamButton;

@end

@implementation YZHCreateTeamResultVC


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

- (void)setupNavBar {
    self.navigationItem.title = @"群创建成功";
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"继续建群" style:UIBarButtonItemStylePlain target:self action:@selector(gotoTeam:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    
    //如果不是互享则隐藏.
    if (self.teamType != YZHTeamTypeShare) {
        self.titleLabel.text = @"群已创建成功";
        self.addShareTeamButton.hidden = YES;
    } else {
        self.titleLabel.text = @"群创建成功，是否要马上向其他互享群发出请求？";
        [self.addShareTeamButton addTarget:self action:@selector(onTouchShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.addFirendButton addTarget:self action:@selector(onTouchAddFirend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.gotoTeamButton addTarget:self action:@selector(gotoTeam:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (void)gotoTeam:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
    //销毁掉前面所有控制器.
    UITabBarController* topViewController = (UITabBarController *)[UIViewController yzh_rootViewController];
    [topViewController setSelectedIndex:0];
    UINavigationController* communityNav = topViewController.viewControllers.firstObject;
    UIViewController* vc = [[UIViewController alloc] init];
    [communityNav pushViewController:vc animated:YES];
    
    
}

- (void)onTouchAddFirend:(UIButton *)sender {
    
    
}

- (void)onTouchShare:(UIButton *)sender {
    
    
}


#pragma mark - 6.Private Methods



- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
