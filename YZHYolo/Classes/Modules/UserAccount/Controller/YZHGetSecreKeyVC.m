//
//  YZHGetSecreKeyVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/3.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHGetSecreKeyVC.h"

#import "YZHProgressHUD.h"
@interface YZHGetSecreKeyVC ()

@property (weak, nonatomic) IBOutlet UIButton *appGetButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneGetButton;

@end

@implementation YZHGetSecreKeyVC


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
    
    self.navigationItem.title = @"手机号获取密钥";

}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.appGetButton.layer.cornerRadius = 4;
    self.appGetButton.layer.masksToBounds = YES;
    
    self.phoneGetButton.layer.cornerRadius = 4;
    
    self.phoneGetButton.layer.masksToBounds = YES;
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)onTouchApp:(UIButton *)sender {
    
    NSDictionary* dic = @{
                          @"phone": self.phoneNumber,
                          @"receiveType": @(0)
                          };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [[YZHNetworkService shareService] GETNetworkingResource:SERVER_LOGIN(PATH_USER_GETECRETKEY) params:dic successCompletion:^(NSString* obj) {
        [hud hideWithText:nil];
        if ([obj isKindOfClass:[NSString class]]) {
            NSString* secretKey = obj;
            [YZHRouter openURL:kYZHRouterFindPassword info:@{
                                                             @"secretKey": secretKey,
                                                             kYZHRouteBackIndex: @(3)
                                                             }];
        }


    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

- (IBAction)onTouchPhone:(UIButton *)sender {
    
    NSDictionary* dic = @{
                          @"phone": self.phoneNumber,
                          @"receiveType": @(1)
                          };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [[YZHNetworkService shareService] GETNetworkingResource:SERVER_LOGIN(PATH_USER_GETECRETKEY) params:dic successCompletion:^(id obj) {
        [hud hideWithText:@"密钥已发送到您的手机" completion:^{
            [YZHRouter openURL:kYZHRouterFindPassword info:@{
                                                             
                                                kYZHRouteBackIndex: @(3)
                                                             }];
        }];
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
