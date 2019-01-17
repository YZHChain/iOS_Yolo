//
//  YZHTeamNoticeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeVC.h"

#import "YZHPublic.h"
#import "YZHTeamNoticeView.h"
#import "YZHTeamNoticeModel.h"
#import "YZHAlertManage.h"

static NSString* kYZHNoticeIdtify = @"YZHTeamNoticeView";
@interface YZHTeamNoticeVC ()<UITableViewDelegate, UITableViewDataSource, YZHTeamNoticeProtecol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHTeamNoticeList* dataSource;
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UIView* emptyView;

@end

@implementation YZHTeamNoticeVC

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
    
    //3.请求数据
    [self setupData];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"群公告内容";
    
    if (self.isManage) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(sendTeamNotice:)];
    }
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHTeamNoticeView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kYZHNoticeIdtify];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
    NSDictionary* params = @{
                              @"group_id": _teamId ? _teamId : nil,
                              @"pageSize": [NSNumber numberWithInteger:100],
                              @"pn": [NSNumber numberWithInteger:0]
                           };
    [[YZHNetworkService shareService] POSTGDLNetworkingResource:SERVER_CHAT(PATH_TEAM_NOTICE_LIST) params:params successCompletion:^(id obj) {
        [hud hideWithText:nil];
        self.dataSource = [YZHTeamNoticeList YZH_objectWithKeyValues:obj];
        [self.dataSource.noticeArray mutableCopy];
        if (self.dataSource.noticeArray.count) {
            if (self.errorView.superclass) {
                [self.errorView removeFromSuperview];
            }
            if (self.emptyView.superclass) {
                [self.emptyView removeFromSuperview];
            }
        } else {
            [self.view addSubview:self.emptyView];
        }
        [self.tableView reloadData];
    } failureCompletion:^(NSError *error) {
        [hud hideWithText:error.domain];
        [self.view addSubview:self.errorView];
    }];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.noticeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHTeamNoticeModel* model = self.dataSource.noticeArray[indexPath.section];
    YZHTeamNoticeView* cell = [tableView dequeueReusableCellWithIdentifier:kYZHNoticeIdtify];
    [cell refresh:model];
    
    if (!self.isManage) {
        [cell.removeButton removeFromSuperview];
    } else {
        cell.delegete = self;
        cell.section = indexPath.section;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHTeamNoticeModel* model = self.dataSource.noticeArray[indexPath.section];
    CGFloat labelHeight = [self getSpaceLabelHeight:model.announcement withFont:[UIFont systemFontOfSize:13] withWidth:YZHScreen_Width - 32];
    if (labelHeight <= 60) {
        return 145;
    } else {
        return labelHeight + 85;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section != 0) {
        return 10;
    } else {
        return 0;
    }
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onTouchRemove:(YZHTeamNoticeModel *)modle section:(NSInteger)section {
    
    @weakify(self)
    [YZHAlertManage showAlertTitle:@"温馨提示" message:@"你确定要删除掉此条公告吗？此操作不可逆" actionButtons:@[@"取消", @"确认"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            //执行删除. TODO: 需后台提供接口.
            NSDictionary* params = @{
                                     @"noticeId": modle.noticeId.length ? modle.noticeId : @""
                                     };
            YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
            [[YZHNetworkService shareService] POSTGDLNetworkingResource:SERVER_CHAT(PATH_TEAM_NOTICE_DELETE) params:params successCompletion:^(id obj) {
                @strongify(self)
                [hud hideWithText:nil];
                self.dataSource = [YZHTeamNoticeList YZH_objectWithKeyValues:obj];
                [self.dataSource.noticeArray removeObjectAtIndex:section];
                if (section == 0) {
                    //同时删除掉云信
                    [[[NIMSDK sharedSDK] teamManager] updateTeamAnnouncement:@"" teamId:self.teamId completion:^(NSError * _Nullable error) {
                        if (!error) {
                            //                    [hud hideWithText:@"删除成功"];
                        } else {
                            //                    [hud hideWithText:@"网络异常, 请重试"];
                        }
                    }];
                }
                [self.tableView reloadData];
            } failureCompletion:^(NSError * error) {
                [hud hideWithText:@"网络异常, 请重试"];
            }];
        }
    }];
    
}

#pragma mark - 5.Event Response

- (void)sendTeamNotice:(UIBarButtonItem *)sender {
    
    [YZHRouter openURL:kYZHRouterCommunityCardSendTeamNotice info:@{
                                                                    @"teamId":self.teamId,
                                                                    kYZHRouteSegue: kYZHRouteSegueModal,
                                                                    kYZHRouteSegueNewNavigation:@(YES)
                                                                    }];
}

#pragma mark - 6.Private Methods

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

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UIView *)errorView {
    
    if (!_errorView) {
        _errorView = [[NSBundle mainBundle] loadNibNamed:@"YZHErrorStatusView" owner:nil options:nil].lastObject;
        _errorView.frame = self.view.bounds;
    }
    return _errorView;
}

- (UIView *)emptyView {
    
    if (!_emptyView) {
        _emptyView = [[NSBundle mainBundle] loadNibNamed:@"YZHEmptyStatusView" owner:nil options:nil].lastObject;
        _emptyView.frame = self.view.bounds;
    }
    return _emptyView;
}

@end
