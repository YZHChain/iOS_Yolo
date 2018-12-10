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
#import "YZHAlertManage.h"

@interface YZHCreateTeamAdditionVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* recruitView;
@property (nonatomic, strong) UILabel* recruitTitleLabel;
@property (nonatomic, strong) UIButton* recruitGuideButton;
@property (nonatomic, strong) UIButton* recruitSelectedButton;
@property (nonatomic, strong) YZHImportBoxView* recruitImportView;
@property (nonatomic, assign) YZHCreateTeamType teamType;
@property (nonatomic, strong) UIView* sharedView;
@property (nonatomic, strong) UILabel* sharedTitleLabel;
@property (nonatomic, strong) UIButton* sharedGuideButton;
@property (nonatomic, strong) UIButton* sharedSelectedButton;
@property (nonatomic, strong) UILabel* footerLabel;
@property (nonatomic, assign) BOOL selectedCruit;
@property (nonatomic, assign) BOOL selectedShared;

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
    //3.设置View Frame
    [self reloadView];
    //3.请求数据
    [self setupData];
    //4.设置通知
    [self setupNotification];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"群设置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeCreate:)];
}

- (void)setupLayoutSubViews {
    
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.teamType = YZHTeamTypePublic;

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [self setupRecruitView];
//    [self setupSharedView];
    [self setupFooterView];
    
}

- (void)setupRecruitView {

    UIView* recruitView = [[UIView alloc] init];
    self.recruitView = recruitView;
    recruitView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:recruitView];
    
    UILabel* recruitTitleLabel = [[UILabel alloc] init];
    recruitTitleLabel.text = @"我要广播群招募";
    recruitTitleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    recruitTitleLabel.textColor = [UIColor yzh_fontShallowBlack];
    self.recruitTitleLabel = recruitTitleLabel;
    [recruitTitleLabel sizeToFit];
    
    UIButton* recruitGuideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recruitGuideButton = recruitGuideButton;
    [recruitGuideButton setImage: [UIImage imageNamed:@"team_createTeam_ introduce_normal"] forState:UIControlStateNormal];
    [recruitGuideButton sizeToFit];
    
    UIButton* recruitSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recruitSelectedButton = recruitSelectedButton;
    [self.recruitSelectedButton addTarget:self action:@selector(onTouchRecruit:) forControlEvents:UIControlEventTouchUpInside];

    [recruitSelectedButton setImage: [UIImage imageNamed:@"team_createTeam_imput_notSelected"] forState:UIControlStateNormal];
    [recruitSelectedButton setImage:[UIImage imageNamed:@"team_createTeam_imput_selected"] forState:UIControlStateSelected];
    [recruitSelectedButton sizeToFit];
    //默认为不勾选.
    self.recruitSelectedButton.selected = NO;
    self.selectedCruit = YES;
    [recruitView addSubview:recruitTitleLabel];
    [recruitView addSubview:recruitGuideButton];
    [recruitView addSubview:recruitSelectedButton];
    
    YZHImportBoxView* importBoxView = [[YZHImportBoxView alloc] init];
    self.recruitImportView = importBoxView;
    self.recruitImportView.hidden = YES; // 默认也是隐藏
    
    [self.scrollView addSubview:importBoxView];
}

- (void)setupSharedView {
    
    UIView* sharedView = [[UIView alloc] init];
    sharedView.backgroundColor = [UIColor whiteColor];
    self.sharedView = sharedView;
    
    [self.scrollView addSubview:sharedView];
    
    UILabel* sharedTitleLabel = [[UILabel alloc] init];
    sharedTitleLabel.text = @"我要把群设为互享群";
    sharedTitleLabel.font = [UIFont yzh_commonStyleWithFontSize:15];
    sharedTitleLabel.textColor = [UIColor yzh_fontShallowBlack];
    [sharedTitleLabel sizeToFit];
    self.sharedTitleLabel = sharedTitleLabel;
    
    [sharedView addSubview:sharedTitleLabel];
    
    UIButton* sharedGuideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharedGuideButton setImage: [UIImage imageNamed:@"team_createTeam_ introduce_normal"] forState:UIControlStateNormal];
    [sharedGuideButton sizeToFit];
    self.sharedGuideButton = sharedGuideButton;
    
    [sharedView addSubview:sharedGuideButton];
    
    UIButton* sharedSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharedSelectedButton addTarget:self action:@selector(onTouchShared:) forControlEvents:UIControlEventTouchUpInside];
    [sharedSelectedButton setImage: [UIImage imageNamed:@"team_createTeam_imput_selected"] forState:UIControlStateNormal];
    [sharedSelectedButton setImage:[UIImage imageNamed:@"team_createTeam_imput_notSelected"] forState:UIControlStateSelected];
    [sharedSelectedButton sizeToFit];
    self.sharedSelectedButton = sharedSelectedButton;
    
    [sharedView addSubview:sharedSelectedButton];
}

- (void)setupFooterView {
    
    UILabel* footerLabel = [[UILabel alloc] init];
    NSString* text = @"如您不需要发布群招募和群成员互享 请勿勾选，直接点击完成";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置文字居中
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    footerLabel.attributedText = attributedString;
//    footerLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    footerLabel.font = [UIFont systemFontOfSize:13];
    footerLabel.textColor = [UIColor yzh_sessionCellGray];
    footerLabel.numberOfLines = 0;
    footerLabel.contentMode = UIViewContentModeCenter;
    [footerLabel sizeToFit];
    self.footerLabel = footerLabel;

    [self.scrollView addSubview:footerLabel];
}

- (void)reloadView {

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.recruitView);
        make.bottom.equalTo(self.footerLabel.mas_bottom).mas_equalTo(30);
    }];
 
    [self.recruitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(55);
    }];
    
    [self.recruitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.recruitGuideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recruitTitleLabel.mas_right).mas_offset(7);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.recruitSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-21);
        make.centerY.mas_equalTo(0);
    }];

    [self.recruitImportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(self.scrollView);
        make.top.equalTo(self.recruitView.mas_bottom).mas_offset(1);
    }];
    
//    [self.sharedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.equalTo(self.recruitImportView.mas_bottom).mas_equalTo(10);
//        make.left.right.equalTo(self.recruitView);
//        make.height.mas_equalTo(55);
//    }];
//
//    [self.sharedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
//        make.centerY.mas_equalTo(0);
//    }];
//
//    [self.sharedGuideButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.sharedTitleLabel.mas_right).mas_offset(7);
//        make.centerY.mas_equalTo(0);
//    }];
//
//    [self.sharedSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-21);
//        make.centerY.mas_equalTo(0);
//    }];
    
    [self.footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recruitView.mas_bottom).mas_equalTo(self.view.height - 110);
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-80);
    }];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.selectedShared = YES;
    self.selectedCruit = YES;
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.scrollView endEditing: YES];
}

#pragma mark - 5.Event Response

- (void)completeCreate:(UIBarButtonItem *)sender {
    
    if (self.recruitSelectedButton.selected) {
        if (YZHIsString(self.recruitImportView.importTextView.text)) {
            self.clickCreatTeamBlock ? self.clickCreatTeamBlock(self.recruitImportView.importTextView.text) : UUID_NULL;
        } else {
            [YZHAlertManage showAlertMessage:@"请填写广播招募信息"];
        }
    } else {
        self.clickCreatTeamBlock ? self.clickCreatTeamBlock(nil) : UUID_NULL;
    }
}

- (void)onTouchRecruit:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    self.selectedCruit = !self.selectedCruit;
    self.recruitImportView.hidden = self.selectedCruit;
}

- (void)onTouchShared:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    self.selectedShared = !self.selectedShared;
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
