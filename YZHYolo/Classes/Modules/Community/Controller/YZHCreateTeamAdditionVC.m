//
//  YZHCreateTeamAdditionVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/31.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCreateTeamAdditionVC.h"
#import "UIView+NIM.h"
#import "YZHImportBoxView.h"
#import "YZHCreatTeamMailDataView.h"

@interface YZHCreateTeamAdditionVC ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* recruitView;
@property (nonatomic, strong) UILabel* recruitTitleLabel;
@property (nonatomic, strong) UIButton* recruitGuideButton;
@property (nonatomic, strong) UIButton* recruitSelectedButton;
@property (nonatomic, strong) UIView* recruitImportView;
@property (nonatomic, assign) YZHCreateTeamType teamType;

@end

@implementation YZHCreateTeamAdditionVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

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

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height + 150);
    
    self.recruitView.frame = CGRectMake(0, 0, self.view.width, 55);
    
    self.recruitTitleLabel.centerY = self.recruitView.centerY;
    self.recruitTitleLabel.x = 16;
    
    self.recruitGuideButton.centerY = self.recruitView.centerY;
    self.recruitGuideButton.x = self.recruitTitleLabel.right + 7;
    
    self.recruitSelectedButton.centerY = self.recruitView.centerY;
    self.recruitSelectedButton.right = self.view.width - 21;
    
    self.recruitImportView.frame = CGRectMake(0, self.recruitView.bottom + 1, self.recruitView.width, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"填写群信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeCreate:)];
}

- (void)setupLayoutSubViews {
    
}

- (void)completeCreate:(UIBarButtonItem *)sender {
    
    [YZHRouter openURL:kYZHRouterCommunityCreateTeamResult info:@{
                                                                  @"teamType": @(YZHTeamTypeShare),
                                                         kYZHRouteBackIndex: kYZHRouteIndexRoot
                                                                  }];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.teamType = YZHTeamTypePublic;

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView* recruitView = [[UIView alloc] init];
    self.recruitView = recruitView;
    recruitView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:recruitView];
    
    UILabel* recruitTitleLabel = [[UILabel alloc] init];
    recruitTitleLabel.text = @"我要广播群招募";
    self.recruitTitleLabel = recruitTitleLabel;
    [recruitTitleLabel sizeToFit];
    
    UIButton* recruitGuideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recruitGuideButton = recruitGuideButton;
    [recruitGuideButton setImage: [UIImage imageNamed:@"team_createTeam_ introduce_normal"] forState:UIControlStateNormal];
    [recruitGuideButton sizeToFit];
    
    UIButton* recruitSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recruitSelectedButton = recruitSelectedButton;
    [recruitSelectedButton setImage: [UIImage imageNamed:@"team_createTeam_imput_selected"] forState:UIControlStateNormal];
    [recruitSelectedButton sizeToFit];
    
    [recruitView addSubview:recruitTitleLabel];
    [recruitView addSubview:recruitGuideButton];
    [recruitView addSubview:recruitSelectedButton];
    
    YZHImportBoxView* importBoxView = [[YZHImportBoxView alloc] init];
    self.recruitImportView = importBoxView;
    
    [scrollView addSubview:importBoxView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
