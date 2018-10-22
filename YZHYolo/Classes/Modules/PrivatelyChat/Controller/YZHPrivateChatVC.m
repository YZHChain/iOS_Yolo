//
//  YZHPrivateChatVC.m
//  NIM
//
//  Created by Jersey on 2018/10/20.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "YZHPrivateChatVC.h"

@interface YZHPrivateChatVC ()

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

#pragma mark - 2.SettingView and Style

- (void)setupNav {
    
    self.navigationItem.title = [super sessionTitle];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemButton setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [rightItemButton setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [rightItemButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];

}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"设置Cell");
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
