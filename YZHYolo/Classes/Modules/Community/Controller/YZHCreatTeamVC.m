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

static NSInteger kTagViewHeight = 21;
static NSInteger kTagViewSpace = 11;
static NSInteger kTagViewSuperViewSpace = 18;
static NSInteger kTagViewRowHeight = 35;
static NSInteger kTagViewRowSpace = 10;

@interface YZHCreatTeamVC ()<UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YZHCreatTeamMailDataView* createTeamView;
@property (nonatomic, copy) YZHExecuteBlock selectedLabelSaveHandle;
@property (nonatomic, strong) NSMutableArray<NSString *>* selectedLabelArray;

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
        [YZHRouter openURL:kYZHRouterCommunityCreateTeamAddition];
    } else {
    // 采集创建群组相关资料 Model。
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
    
    [self.createTeamView.teamTagShowView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.createTeamView.teamTagViewLayoutConstraint.constant = 80;
    UIView* lastView;    // 代表同意行的上一个 TagView. 第一个则为 nil
    NSInteger level = 0; //代表目前已新增的行数
    NSInteger lastViewRight = 0;  //上一个 TagView的 X + Widtg
    
    for (NSInteger i = 0 ; i < self.selectedLabelArray.count; i++) {

        UIView* labelView = [[UIView alloc] init];
        labelView.layer.cornerRadius = 3;
        labelView.layer.borderWidth = 1;
        labelView.layer.borderColor = [UIColor yzh_backgroundThemeGray].CGColor;
        
        UILabel* tagLabel = [[UILabel alloc] init];
        tagLabel.text = self.selectedLabelArray[i];
        tagLabel.font = [UIFont yzh_commonStyleWithFontSize:11];
        CGSize tagSize = [tagLabel sizeThatFits: CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
        [self.createTeamView.teamTagShowView addSubview:labelView];
        [labelView addSubview:tagLabel];
        NSInteger viewWidth = tagSize.width + 32;
        if (lastView) {
            //如果新增加的 TagViewWide + 左边间距 + 与最右边的间距 超出了 SuperViewWidth 则需要向下新增一行.
            if (YZHView_Width - lastViewRight < (viewWidth + kTagViewSpace + kTagViewSuperViewSpace)) {
                lastView = nil;
                level++;
            }
        }
        // 判断是否有上一个
        if (lastView) {
            [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastView.mas_right).mas_offset(kTagViewSpace);
                make.width.mas_equalTo(viewWidth);
                make.top.bottom.mas_equalTo(lastView);
            }];
        } else {
            [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kTagViewSuperViewSpace);
                make.top.mas_equalTo(kTagViewRowSpace + level * kTagViewRowHeight);
                make.height.mas_equalTo(kTagViewHeight);
                make.width.mas_equalTo(viewWidth);
            }];
        }
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(labelView);
        }];
        if (lastView) {
            lastViewRight += viewWidth + kTagViewSpace;
        } else {
            lastViewRight = viewWidth + kTagViewSuperViewSpace; // diydiy
        }
        lastView = labelView;
    }
    
    self.createTeamView.teamTagViewLayoutConstraint.constant +=  (level * kTagViewRowHeight);
}

#pragma mark - 7.GET & SET

- (NSMutableArray<NSString *> *)selectedLabelArray {
    
    if (!_selectedLabelArray) {
        _selectedLabelArray = [[NSMutableArray alloc] init];
    }
    return _selectedLabelArray;
}

@end
