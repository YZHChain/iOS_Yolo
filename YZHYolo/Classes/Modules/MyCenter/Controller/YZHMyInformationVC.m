//
//  YZHMyInformationVC.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationVC.h"

@interface YZHMyInformationVC ()

@end

@implementation YZHMyInformationVC

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    if (self.supportNavigation) {
//        self.navigationController.navigationBar.hidden = NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    if (self.supportNavigation) {
//        self.navigationController.navigationBar.hidden = YES;
//    }
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"个人信息";
    self.showNavigationBar = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftBtn.frame = CGRectMake(0, 0, 11,19);
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"navigation_item_left"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
//    //创建UIBarButtonSystemItemFixedSpace
//    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    //将宽度设为负值
//    spaceItem.width = -18;
//    self.navigationItem.leftBarButtonItems = @[spaceItem, leftBarBtn];
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

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
