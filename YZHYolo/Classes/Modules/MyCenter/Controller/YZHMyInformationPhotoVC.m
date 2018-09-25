//
//  YZHMyInformationPhotoVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationPhotoVC.h"

@interface YZHMyInformationPhotoVC ()

@end

@implementation YZHMyInformationPhotoVC

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
    
    //TODO: 不知道什么原因, Bar 还是隐藏的。暂时先通过这里解决。。
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"头像";
    self.hideNavigationBarLine = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundDarkBlue];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)useCameraPictures:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callMobilePhoto:(UIButton *)sender {
}

- (IBAction)performbSavePhoto:(UIButton *)sender {
}


#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET


@end
