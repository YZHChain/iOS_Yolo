//
//  YZHTeamSendNoticeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamSendNoticeVC.h"

#import "YZHImportBoxView.h"
#import "YZHPublic.h"
#import "YZHUserLoginManage.h"
@interface YZHTeamSendNoticeVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet YZHImportBoxView *noticeImportBoxView;
@property (weak, nonatomic) IBOutlet UISwitch *informAllSwitch;
@property (weak, nonatomic) IBOutlet UIButton *sendNoticeButton;
@property (nonatomic, copy) void(^selectedTeamBlock)(NSArray* selectedTeamArray);
@property (nonatomic, strong) NSArray* selectedTeamArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *noticeAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTeamsLabel;
@property (nonatomic, copy) NSString* endTime;

@end

@implementation YZHTeamSendNoticeVC

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
    
    self.navigationItem.title = @"发布群公告";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.scrollView.delegate = self; self.noticeImportBoxView.maximumLengthLabel.text = @"/500";
    self.noticeImportBoxView.importTextView.maxLength = 500;
    
    self.endTimeLabel.textColor = [UIColor yzh_sessionCellGray];
    self.endTimeLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    
    self.noticeAllLabel.textColor = [UIColor yzh_sessionCellGray];
    self.noticeAllLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    
    self.sendTeamsLabel.textColor = [UIColor yzh_sessionCellGray];
    self.sendTeamsLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    
    [self.informAllSwitch addTarget:self action:@selector(clickInformAllSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reloadView {
    
    self.sendNoticeButton.layer.cornerRadius = 4;
    self.sendNoticeButton.layer.masksToBounds = YES;
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [scrollView endEditing:YES];
}

#pragma mark - 5.Event Response

- (void)clickCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)selectedEndTime:(id)sender {
    
    
    
}

- (IBAction)selectedTeam:(id)sender {
    
    [YZHRouter openURL:kYZHRouterCommunityCardSelectedTeam info:@{
                                                                  kYZHRouteSegue: kYZHRouteSegueModal,
                                                                  @"teamId": self.teamId,
                                                                  kYZHRouteSegueNewNavigation: @(YES),
                                                                  @"selectedTeamBlock":self.selectedTeamBlock
                                                                  }];
    
}
- (IBAction)sendTeamNotice:(id)sender {
    
//    if (YZHIsString(_endTime)) {
//        [YZHAlertManage showAlertMessage:@"请选择结束时间"];
//        return;
//    }
    //TODO: 同步群问题. IM 没提供多个群接口,  需要多次调用. 不合适.
    if (YZHIsString(self.noticeImportBoxView.importTextView.text)) {
        NSString* userId = [[[YZHUserLoginManage sharedManager] currentLoginData] account];
        NSMutableString* groupIds = [[NSMutableString alloc] init];
        [self.selectedTeamArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx) {
                [groupIds appendFormat:@"%@", [NSString stringWithFormat:@",%@", obj]];
            } else {
                [groupIds appendString:obj];
            }
        }];
        NSDictionary* params;
        if (self.informAllSwitch.isOn) {
            params = @{
                       @"endTime": _endTime.length ? _endTime : @"2018-12-30 00:00",
                       @"grouIds": groupIds.length ? groupIds.copy : _teamId,
                       @"noticeContent": [NSString stringWithFormat:@"@All %@", self.noticeImportBoxView.importTextView.text],
                       @"userId": userId ? [NSNumber numberWithInteger:userId.integerValue] : @"",
                       };
        } else {
            params = @{
                       @"endTime": _endTime.length ? _endTime : @"2018-12-30 00:00",
                       @"grouIds": groupIds.length ? groupIds.copy : _teamId,
                       @"noticeContent": self.noticeImportBoxView.importTextView.text,
                       @"userId": userId ? [NSNumber numberWithInteger:userId.integerValue] : @"",
                       };
        }
        @weakify(self)
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        [[YZHNetworkService shareService] POSTGDLNetworkingResource:PATH_TEAM_NOTICE_ADD params:params successCompletion:^(id obj) {
            @strongify(self)
            if ([obj objectForKey:@"code"] && [obj[@"code"] isEqualToString:@"200"]) {
                [hud hideWithText:@"公告发布成功"];
                self.sendNoticeButton.userInteractionEnabled = NO;
                self.sendNoticeButton.alpha = 0.4;
                [self IMSendNotice];
            } else {
                if (obj[@"message"]) {
                    [hud hideWithText:obj[@"message"]];
                } else {
                    [hud hideWithText:@"网络异常, 请重试"];
                }
            }
        } failureCompletion:^(NSError *error) {
            [hud hideWithText:@"网络异常, 请重试"];
        }];
        
        [self IMSendNotice];
    } else {
        [YZHAlertManage showAlertMessage:@"请填写群公告内容"];
    }
}

- (void)IMSendNotice {
    
    NSDictionary* noticeDic;
    if (self.informAllSwitch.isOn) {
        noticeDic = @{
                      @"announcement": [NSString stringWithFormat:@"@All %@", self.noticeImportBoxView.importTextView.text],
                      @"endTime": _endTime.length ? _endTime : @"2018-12-30 00:00",
                      };
    } else {
        noticeDic = @{
                      @"announcement": self.noticeImportBoxView.importTextView.text,
                      @"endTime": _endTime.length ? _endTime : @"2018-12-30 00:00",
                      };
    };
    
    NSString* noticeString = [noticeDic mj_JSONString];
    [[[NIMSDK sharedSDK] teamManager] updateTeamAnnouncement:noticeString teamId:_teamId completion:^(NSError * _Nullable error) {

    }];
    
}

- (void)clickInformAllSwitch:(UISwitch *)sender {
    
    if (sender.on) {
        self.noticeAllLabel.text = @"是";
    } else {
        self.noticeAllLabel.text = @"否";
    }
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (void (^)(NSArray *))selectedTeamBlock {
    
    if (!_selectedTeamBlock) {
        @weakify(self)
        _selectedTeamBlock = ^(NSArray *selectedArray){
            @strongify(self)
            self.selectedTeamArray = selectedArray;
            //刷新同步发送我的其他群列表
        };
    }
    return _selectedTeamBlock;
}

- (NSArray *)selectedTeamArray {
    
    if (!_selectedTeamArray) {
        _selectedTeamArray = @[_teamId];
    }
    return _selectedTeamArray;
}

@end
