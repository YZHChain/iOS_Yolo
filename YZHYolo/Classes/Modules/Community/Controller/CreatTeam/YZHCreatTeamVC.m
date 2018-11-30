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
#import "UIImage+NIMKit.h"
#import "NIMInputEmoticonDefine.h"
#import "NIMKit.h"
#import "NIMKitDevice.h"
#import "NIMKitFileLocationHelper.h"
#import "YZHTeamInfoExtManage.h"
#import "YZHTeamUpdataModel.h"

@interface YZHCreatTeamVC ()<UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YZHCreatTeamMailDataView* createTeamView;
@property (nonatomic, copy) YZHExecuteBlock selectedLabelSaveHandle;
@property (nonatomic, strong) NSMutableArray<NSString *>* selectedLabelArray;
@property (nonatomic, copy) NSString* avatarUrl;

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
            [self updatePhotoToIMDataWithImage:image];
        }];
    };
    
    self.createTeamView.teamSynopsisTextView.delegate = self;
    self.createTeamView.scrollView.delegate = self;
    
    UIView* tagView = [[UIView alloc] init];
    [self.createTeamView.teamTagView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.createTeamView.teamTagTitleView.mas_bottom);
    }];
    UIButton* tagViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagViewButton addTarget:self action:@selector(selectedTeamTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.createTeamView.teamTagView addSubview:tagViewButton];
    [tagViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)reloadView {
    
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [scrollView endEditing:YES];
}

#pragma mark - 5.Event Response

- (void)createTeam:(UIBarButtonItem* )item {
    // 如果是公开群则跳转至填写宣传页,否则直接创建群
    if (self.createTeamView.teamType == YZHTeamTypePublic) {
        
//        @weakify(self)
//        self.creatTeamHandle = ^(NSString *recruitText) {
//            @strongify(self)
//            if (YZHIsString(recruitText)) {
//                [self creatTeamWithRecruitText:recruitText];
//            } else {
//                [self creatTeamWithRecruitText:nil];
//            }
//        };
        @weakify(self)
        void (^creatTeamHandle) (NSString *recruitText) = ^(NSString* recuitText){
            @strongify(self)
            if (YZHIsString(recuitText)) {
                [self creatTeamWithRecruitText:recuitText];
            } else {
                [self creatTeamWithRecruitText:nil];
            }
        };
        [YZHRouter openURL:kYZHRouterCommunityCreateTeamAddition info:@{
                                                                        @"clickCreatTeamBlock":
                                                                            creatTeamHandle
                                                                        }];
    } else {
    // 采集创建群组相关资料 Model。
        [self creatTeamWithRecruitText:nil];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)selectedTeamTag:(UIButton *)sender {
   
    if (!self.selectedLabelSaveHandle) {
        @weakify(self)
        self.selectedLabelSaveHandle = ^(NSMutableArray* result) {
            // 更新已选群标签展示 View;
            @strongify(self)
            self.selectedLabelArray = result;
            [self refresh];
        };
    }
    
    [YZHRouter openURL:kYZHRouterCommunityCreateTeamTagSelected info:@{
                                                                       kYZHRouteSegue: kYZHRouteSegueModal,
                                                                       kYZHRouteSegueNewNavigation : @(YES),
                                                                       @"selectedLabelSaveHandle": self.selectedLabelSaveHandle,
                                                                       @"selectedLabelArray":self.selectedLabelArray
                                                                       }];
    
}

- (void)refresh {

    CGFloat showViewHeight =  [self.createTeamView.teamTagShowView refreshLabelViewWithLabelArray:self.selectedLabelArray];
    
    self.createTeamView.teamTagViewLayoutConstraint.constant = 80 + showViewHeight;
    
}

- (void)updatePhotoToIMDataWithImage:(UIImage* )image {
    
    UIImage *imageForAvatarUpload = [image nim_imageForAvatarUpload];
    NSString *fileName = [NIMKitFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NIMKitFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    @weakify(self)
    if (success) {
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
            [SVProgressHUD dismiss];
            @strongify(self)
            if (!error && self) {
                self.avatarUrl = urlString;
                self.createTeamView.avatarImageView.image = image;
                [self.view makeToast:nil];
            } else {
                [self.view makeToast:@"图片上传失败，请重试"
                            duration:2
                            position:CSToastPositionCenter];
            }
        }];
    } else {
        [self.view makeToast:@"图片上传失败，请重试"
                    duration:2
                    position:CSToastPositionCenter];
    }
}
- (void)creatTeamWithRecruitText:(NSString *)recruitText;
{
    NIMCreateTeamOption* teamOption = [[NIMCreateTeamOption alloc] init];
    if (self.createTeamView.teamType == YZHTeamTypePublic) {
        teamOption.joinMode = NIMTeamJoinModeNoAuth;
    } else if (self.createTeamView.teamType == YZHTeamTypePrivacy) {
        teamOption.joinMode = NIMTeamJoinModeNeedAuth;
    }
    YZHTeamRecruit* teamRecruit = nil;
    if (YZHIsString(recruitText)) {
        teamRecruit = [[YZHTeamRecruit alloc] initWithContent:recruitText];
    }
    if (YZHIsString(self.createTeamView.teamNameTextFiled.text)) {
        teamOption.name = self.createTeamView.teamNameTextFiled.text;
    } else {
        teamOption.name = @"群聊";
    }
    if (YZHIsString(self.avatarUrl)) {
        teamOption.avatarUrl = self.avatarUrl;
    }
    if (YZHIsString(self.createTeamView.teamSynopsisTextView.text)) {
        teamOption.intro = self.createTeamView.teamSynopsisTextView.text;
    }
    YZHTeamInfoExtManage* teamInfo = [[YZHTeamInfoExtManage alloc] initCreatTeamWithTeamLabel:self.selectedLabelArray.count ? self.selectedLabelArray : nil recruit:teamRecruit];
    NSString* teamInfoString = [teamInfo mj_JSONString];
    teamOption.clientCustomInfo = teamInfoString;
    teamOption.type = NIMTeamTypeAdvanced; 
//    teamOption.joinMode = NIMTeamJoinModeNoAuth; // 默认是公开群.
    teamOption.beInviteMode = NIMTeamBeInviteModeNoAuth; // 默认不需要验证
    teamOption.inviteMode = NIMTeamInviteModeAll; // 默认是允许成员添加好友进群.
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    NSArray* array = @[userId];
    //创群成功则跳转至结果页
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    [[NIMSDK sharedSDK].teamManager createTeam:teamOption users:array completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds) {
        // 存储相关资料,方便到成功页执行相应逻辑. 创建完群组之后需要将回话添加到列表中.
        if (!error) {
            [hud hideWithText:nil];
            [YZHRouter openURL:kYZHRouterCommunityCreateTeamResult info:@{
                                                                          @"teamType": @(self.createTeamView.teamType),
                                                                          @"teamID": teamId,
                                                                          kYZHRouteBackIndex: kYZHRouteIndexRoot
                                                                          }];
            YZHTeamUpdataModel* model = [[YZHTeamUpdataModel alloc] initWithTeamId:teamId isCreatTeam:YES];
            //通知后台
            [[YZHNetworkService shareService] POSTNetworkingResource:PATH_TEAM_ADDUPDATEGROUP params:model.params successCompletion:^(id obj) {
                
                NSLog(@"成功");
            } failureCompletion:^(NSError *error) {
                NSLog(@"失败");
            }];
        } else {
            [hud hideWithText:@"网络异常,请重试"];
        }
    }];
}
    
#pragma mark - 7.GET & SET

- (NSMutableArray<NSString *> *)selectedLabelArray {
    
    if (!_selectedLabelArray) {
        _selectedLabelArray = [[NSMutableArray alloc] init];
    }
    return _selectedLabelArray;
}

@end
