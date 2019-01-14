//
//  YZHTeamRecruitCardIntroVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamRecruitCardIntroVC.h"

#import "YZHTeamCardTextCell.h"
#import "YZHTeamCardHeaderView.h"
#import "YZHTeamRecruitCardIntroModel.h"
#import "UIButton+YZHTool.h"
#import "YZHProgressHUD.h"
#import "YZHTeamCardIntro.h"
#import "UIImageView+YZHImage.h"
#import "YZHCommunityChatVC.h"
#import "UIViewController+YZHTool.h"
#import "YZHTeamRecruitCell.h"

@interface YZHTeamRecruitCardIntroVC()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHTeamCardHeaderView* headerView;
@property (nonatomic, strong) YZHTeamRecruitCardIntroModel* viewModel;
@property (nonatomic, strong) UITableViewHeaderFooterView* footerView;
@property (nonatomic, strong) UIButton* addTeamButton;

@end

@implementation YZHTeamRecruitCardIntroVC
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
    self.navigationItem.title = @"群详情";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchClose)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)reloadView {
    
    [self.headerView refreshIntroWithModel:self.viewModel.headerModel];
    self.headerView.frame = CGRectMake(0, 0, self.tableView.width, self.headerView.updateHeight);
    [self.tableView setTableHeaderView:self.headerView];
    
    [self configurationFooterView];
    [self.tableView reloadData];
    
    self.tableView.tableFooterView = self.footerView;
    
    //非好友关系时, 拉取用户最新资料.
    @weakify(self)
    if (![[[NIMSDK sharedSDK] userManager] isMyFriend:self.viewModel.teamOwner] && YZHIsString(self.viewModel.teamOwner)) {
        [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[self.viewModel.teamOwner] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            @strongify(self)
            if (!error) {
                [self.viewModel updataTeamOwnerData:users.firstObject];
                [self.tableView reloadData];
            }
        }];
    }
    //不是自己的群时, 需更新.
    if (![[[NIMSDK sharedSDK] teamManager] isMyTeam:self.viewModel.teamId]) {
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:self.viewModel.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            if (!error) {
                @strongify(self)
                [self.viewModel updataHeaderModel:team];
                [self.tableView reloadData];
            }
        }];
    }
    //更新群公告数据,
    [self.viewModel updateTeamRecruitModelWithTeamId:self.teamId completion:^{
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    if (![[[NIMSDK sharedSDK] teamManager] isMyTeam:self.teamId]) {
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
        @weakify(self)
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:self.teamId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            @strongify(self)
            [hud hideWithText:nil];
            //如果请求失败,或者找不到此群,或者此群解散,按这个逻辑处理,默认都是展示此群已解散。
            self.viewModel = [[YZHTeamRecruitCardIntroModel alloc] initWithTeam:team recruitInfo:self.recruitInfo];
            if (error) {
                self.viewModel.error = error;
            }
            [self reloadView];
        }];
    } else {
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId];
        self.viewModel = [[YZHTeamRecruitCardIntroModel alloc] initWithTeam:team recruitInfo:self.recruitInfo];
        [self reloadView];
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.haveTeamData ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHTeamCardIntro* cell;
    if (indexPath.section == 0) {
        NSInteger row = indexPath.row;
        if (row == 0) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntro" owner:nil options:nil].firstObject;
            cell.titleLabel.text = @"群成员";
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%ld人",self.viewModel.team.memberNumber];
        } else if (row == 1) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntro" owner:nil options:nil].lastObject;
            cell.titleLabel.text = @"群主";
            cell.nameLabel.text = self.viewModel.teamOwnerName;
            if (YZHIsString(self.viewModel.teamOwnerAvatarUrl)) {
                [cell.avatarImageView yzh_setImageWithString:self.viewModel.teamOwnerAvatarUrl placeholder:@"addBook_cover_cell_photo_default"];
            } else {
                [cell.avatarImageView setImage:[UIImage imageNamed:@"addBook_cover_cell_photo_default"]];
            }
        }
         return cell;
    } else {
        YZHTeamRecruitCell* recruitCell = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamRecruitCell" owner:nil options:nil].firstObject;
        recruitCell.titleLabel.text = self.viewModel.recruitModel.content;
        return recruitCell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont yzh_commonFontStyleFontSize:12];
        label.text = self.viewModel.recruitModel.content;
        if (YZHIsString(label.text)) {
            
           CGFloat height =  [self getSpaceLabelHeight:label.text withFont:label.font withWidth:tableView.width];
            if (height >= 60) {
                return height + 40;
            } else {
                return 104;
            }
        } else {
            return 104;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (YZHIsString(self.viewModel.teamOwner)) {
            NSDictionary* info = @{
                                   @"userId": self.viewModel.teamOwner
                                   };
            [YZHRouter openURL:kYZHRouterAddressBookDetails info: info];
        }
    }
}

#pragma mark - 5.Event Response

- (void)onTouchClose{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)addTeam:(UIButton* )sender {
    
    // 添加入群附言.
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] teamManager] applyToTeam:self.teamId message:@"" completion:^(NSError * _Nullable error, NIMTeamApplyStatus applyStatus) {
        if (!error) {
            [hud hideWithText:@"已成功加入群聊"];
            @strongify(self)
            [self.addTeamButton setTitle:@"进入群聊" forState:UIControlStateNormal];
            [self.addTeamButton removeTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
            [self.addTeamButton addTarget:self action:@selector(gotoTeam:) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
//            [hud hideWithText:@"申请入群失败"];
            if (error.code == 801) {
                [hud hideWithText:@"群人数达到上限"];
            } else {
                [hud hideWithText:@"申请入群失败"];
            }
        }
        
    }];
}

- (void)gotoTeam:(UIButton* )sender {
    
    NIMSession* teamSession = [NIMSession session:self.teamId type:NIMSessionTypeTeam];
    YZHCommunityChatVC* teamVC = [[YZHCommunityChatVC alloc] initWithSession:teamSession];
    [self.navigationController pushViewController:teamVC animated:YES];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

#pragma mark - 7.GET & SET

- (YZHTeamCardHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHTeamCardIntroHeaderView" owner:nil options:nil].lastObject;
        _headerView.autoresizingMask = NO;
    }
    return _headerView;
}

- (void)configurationFooterView {
    
    _footerView = [[UITableViewHeaderFooterView alloc] init];
    self.tableView.tableFooterView = _footerView;
    _footerView.frame = CGRectMake(0, 0, self.tableView.width, 110);
    UIButton* addTeamButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addTeamButton.layer.cornerRadius = 4;
    addTeamButton.layer.masksToBounds = YES;
    [addTeamButton.titleLabel setFont:[UIFont yzh_commonStyleWithFontSize:20]];
    [addTeamButton yzh_setBackgroundColor:[UIColor yzh_fontThemeBlue] forState:UIControlStateNormal];
    [addTeamButton yzh_setBackgroundColor:[UIColor yzh_separatorLightGray] forState:UIControlStateDisabled];
    [addTeamButton setTitle:@"加入群聊" forState:UIControlStateNormal];
    //TODO: 有空看下云信,查找社群时,是否会返回相应错误参数,包含找不到此群还是此群已解散等信息。
    [addTeamButton setTitle:@"未找到该群" forState:UIControlStateDisabled];
    [addTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.addTeamButton = addTeamButton;
    if (self.viewModel.haveTeamData) {
        [addTeamButton addTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.tableView.tableHeaderView removeFromSuperview];
        if (self.viewModel.error.code == 803) {
            [addTeamButton setTitle:@"未找到该群" forState:UIControlStateNormal];
        } else {
            [addTeamButton setTitle:@"未找到该群" forState:UIControlStateNormal];
        }
        addTeamButton.enabled = NO;
    }
    
    // 判断如果处于本群群成员则,
    if ([[[NIMSDK sharedSDK] teamManager] isMyTeam:self.teamId]) {
        [self.addTeamButton setTitle:@"进入群聊" forState:UIControlStateNormal];
        [self.addTeamButton removeTarget:self action:@selector(addTeam:) forControlEvents:UIControlEventTouchUpInside];
        [self.addTeamButton addTarget:self action:@selector(gotoTeam:) forControlEvents:UIControlEventTouchUpInside];
        addTeamButton.enabled = YES;
    }
    
    [self.footerView addSubview:addTeamButton];
    
    [addTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
        make.height.mas_equalTo(40);
    }];
}

@end
