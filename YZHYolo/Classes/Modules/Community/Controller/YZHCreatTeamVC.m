//
//  YZHCreatTeamVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/31.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCreatTeamVC.h"

#import "YZHCreatTeamMailDataView.h"
#import "YZHPublic.h"
#import "YZHPhotoManage.h"

@interface YZHCreatTeamVC ()<UITextViewDelegate>

@property (nonatomic, strong) YZHCreatTeamMailDataView* createTeamView;

@end

@implementation YZHCreatTeamVC


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
    self.navigationItem.title = @"填写群信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createTeam:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    YZHCreatTeamMailDataView* createTeamView = [YZHCreatTeamMailDataView yzh_viewWithFrame:self.view.bounds];
    self.createTeamView = createTeamView;
    [self.view addSubview:createTeamView];
    @weakify(self)
    createTeamView.updataBlock = ^(UIButton* sender) {
        @strongify(self)
        [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
            @strongify(self)
            self.createTeamView.avatarImageView.image = image;
        }];
    };
    
    self.createTeamView.teamSynopsisTextView.delegate = self;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (void)createTeam:(UIBarButtonItem* )item {
    // 如果是公开群则跳转至填写宣传页,否则直接创建群
    if (self.createTeamView.teamType == YZHTeamTypePublic) {
        [YZHRouter openURL:kYZHRouterCommunityCreateTeamAddition];
    } else {
//        采集创建群组相关资料 Model。
        NIMCreateTeamOption* teamOption = [[NIMCreateTeamOption alloc] init];
        teamOption.name = @"Test";
        teamOption.type = NIMTeamTypeAdvanced;
        teamOption.beInviteMode = NIMTeamBeInviteModeNoAuth;
        NSArray* array = @[@"zexi0625",@"18876789520"];
        //创群成功则跳转至结果页
        [[NIMSDK sharedSDK].teamManager createTeam:teamOption users:array completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
            // 存储相关资料,方便到成功页执行相应逻辑.
            if (!error) {
                [YZHRouter openURL:kYZHRouterCommunityCreateTeamResult info:@{
                                                                              @"teamType": @(YZHTeamTypePrivacy),
                                                                              @"teamID": teamId,
                                                                              kYZHRouteBackIndex: kYZHRouteIndexRoot
                                                                              }];
            }
        }];
        
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
