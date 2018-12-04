//
//  YZHSelectedTeamTypeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/3.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSelectedTeamTypeVC.h"

#import "YZHUserLoginManage.h"
#import "YZHProgressHUD.h"

@interface YZHSelectedTeamTypeVC ()
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation YZHSelectedTeamTypeVC


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
    self.navigationItem.title = @"";
    
    self.hideNavigationBar = YES;
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.confirmButton.layer.cornerRadius = 4;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.enabled = NO;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response
//提交当前选择并且登陆.
- (IBAction)onTouchConfirm:(UIButton *)sender {
   
    
}
//TODO: 应该提前登陆.
- (IBAction)onTouchSkip:(UIButton *)sender {
    
    YZHUserLoginManage* manage = [YZHUserLoginManage sharedManager];
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    [manage IMServerLoginWithAccount:_logModel.acctId token:_logModel.token userLoginModel:_logModel successCompletion:^{
        [hud hideWithText:@"nil"];
    } failureCompletion:^(NSError *error) {
        // TODO云信登录错误
        [hud hideWithText:error.domain];
    }];
    
}

#pragma mark - 6.Private Methods

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
