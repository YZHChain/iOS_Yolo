//
//  YZHTeamMemberVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberVC.h"

#import "YZHTeamMemberCell.h"
#import "YZHTeamMemberModel.h"

@interface YZHTeamMemberVC()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHTeamMemberModel* viewModel;

@end

@implementation YZHTeamMemberVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithConfig:(id<NIMContactSelectConfig>)config withIsManage:(BOOL)isManage {
    
    self = [super init];
    if (self) {
        _config = config;
        _isManage = isManage;
        _teamId = config.teamId;
        _member = [[YZHTeamMemberModel alloc] init];
        [self makeData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"群成员";
    
    if (self.isManage) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理成员" style:UIBarButtonItemStylePlain target:self action:@selector(manageMember:)];
    }
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHTeamMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转至群成员, 非好友时需要有临时会话功能
}

#pragma mark - 5.Event Response

- (void)manageMember:(UIBarButtonItem *)sender {
    
    //跳转到管理群成员
    
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)makeData {
    
    @weakify(self)
    [self.config getContactData:^(NSDictionary *contentDic, NSArray *titles) {
        @strongify(self)
        NSLog(@"获取到的群成员信息%@,%@", contentDic, titles);
        
    }];
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHTeamMemberCell" bundle:nil] forCellReuseIdentifier: kYZHCommonCellIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    }
    return _tableView;
}

@end
