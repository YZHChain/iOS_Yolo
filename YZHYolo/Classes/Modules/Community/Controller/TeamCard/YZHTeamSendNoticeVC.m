//
//  YZHTeamSendNoticeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamSendNoticeVC.h"

#import "YZHImportBoxView.h"
@interface YZHTeamSendNoticeVC ()

@property (weak, nonatomic) IBOutlet YZHImportBoxView *noticeImportBoxView;
@property (weak, nonatomic) IBOutlet UISwitch *informAllSwitch;
@property (weak, nonatomic) IBOutlet UIButton *sendNoticeButton;
@property (nonatomic, copy) void(^selectedTeamBlock)(NSArray* selectedTeamArray);
@property (nonatomic, strong) NSArray* selectedTeamArray;

@property (weak, nonatomic) IBOutlet UILabel *noticeAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTeamsLabel;

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
    
    self.noticeImportBoxView.maximumLengthLabel.text = @"/500";
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

@end
