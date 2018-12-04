//
//  YZHRegisterBackupsVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/3.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRegisterBackupsVC.h"

#import "UIViewController+YZHTool.h"
#import "YZHSelectedTeamTypeVC.h"

@interface YZHRegisterBackupsVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *backupsButton;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation YZHRegisterBackupsVC

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
//    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
//    CAGradientLayer *layer = [CAGradientLayer new];
//    //存放渐变的颜色的数组
//    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
//    //起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
//    layer.startPoint = CGPointMake(0.0, 0.0);
//    layer.endPoint = CGPointMake(1, 0.0);
//
//    layer.frame = _passwordView.frame;
//    CGRect rect = _passwordView.frame;
//    UIView* view = [[UIView alloc] initWithFrame:rect];
//    [view.layer addSublayer:layer];
//
//    [_passwordView insertSubview:view atIndex:0];
//
//    [_passwordView setNeedsLayout];
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
    
    [self.startButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:18]];
    self.startButton.layer.cornerRadius = 4;
    self.startButton.layer.masksToBounds = YES;
    self.startButton.enabled = NO;
    
    self.passwordView.backgroundColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    self.passwordLabel.textColor = [UIColor whiteColor];
    
    self.backupsButton.selected = NO;
    //展示助记词
    self.passwordLabel.text = self.logModel.mnemonicWord;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)onTouchBackup:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        self.startButton.enabled = YES;
    } else {
        self.startButton.enabled = NO;
    }
}

- (IBAction)onTouchStart:(UIButton *)sender {
    
//    UIViewController* topViewController = [UIViewController yzh_rootViewController];
    
    YZHSelectedTeamTypeVC* selectedTypeVC = [[YZHSelectedTeamTypeVC alloc] init];
    selectedTypeVC.logModel = self.logModel;
    
    [self.navigationController pushViewController:selectedTypeVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
