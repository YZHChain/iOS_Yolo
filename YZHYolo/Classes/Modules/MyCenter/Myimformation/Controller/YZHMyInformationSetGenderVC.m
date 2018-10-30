//
//  YZHMyInformationSetGenderVC.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationSetGenderVC.h"

#import "YZHPublic.h"
@interface YZHMyInformationSetGenderVC ()

@property (weak, nonatomic) IBOutlet UIButton *boyTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *girlTitleButton;
@property (weak, nonatomic) IBOutlet UIImageView *boySelectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *girlSelectedImageView;
@property (nonatomic, assign) NIMUserGender currentSeleced;

@end

@implementation YZHMyInformationSetGenderVC

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
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"设置性别";
    self.hideNavigationBarLine = YES;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    //    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    if ([self.userGender isEqualToString:@"男"]) {
        self.girlSelectedImageView.hidden = YES;
        self.boyTitleButton.selected = YES;
    } else {
        self.boySelectedImageView.hidden = YES;
        self.girlTitleButton.selected = YES;
    }
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

- (void)saveSetting{
    
    NSString* selectedGender = [YZHUserUtil genderString:self.currentSeleced];
    NSString* genderNumber = [NSString stringWithFormat:@"%ld", self.currentSeleced];
    if (![selectedGender isEqualToString:_userGender]) {
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:@""];
        @weakify(self)
        [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagGender) : genderNumber} completion:^(NSError *error) {
            @strongify(self)
            if (!error) {
                [hud hideWithText:@"性别修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [hud hideWithText:error.domain];
            }
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)selectedBoy:(UIButton *)sender {
    
    self.boyTitleButton.selected = YES;
    self.girlTitleButton.selected = NO;
    self.boySelectedImageView.hidden = NO;
    
    self.girlSelectedImageView.hidden = YES;
}
- (IBAction)selectedGirl:(UIButton *)sender {
    self.boyTitleButton.selected = NO;
    self.girlTitleButton.selected = YES;
    self.boySelectedImageView.hidden = YES;
    
    self.girlSelectedImageView.hidden = NO;
}


#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (NIMUserGender)currentSeleced {
    
    if (self.girlSelectedImageView.isHidden) {
        _currentSeleced = NIMUserGenderMale;
    } else {
        _currentSeleced = NIMUserGenderFemale;
    }
    return _currentSeleced;
}

@end
