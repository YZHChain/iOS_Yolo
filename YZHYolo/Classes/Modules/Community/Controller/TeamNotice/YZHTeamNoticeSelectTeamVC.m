//
//  YZHTeamNoticeSelectTeamVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeSelectTeamVC.h"

#import "YZHTeamNoticeSelectTeamModel.h"
#import "YZHTeamNoticeSelectedTeamCell.h"

@interface YZHTeamNoticeSelectTeamVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHTeamNoticeSelectTeamModel* viewModel;
@property (nonatomic, strong) NSMutableArray* selectedIndexPathArray;

@end

@implementation YZHTeamNoticeSelectTeamVC

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
    self.navigationItem.title = @"我的群";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickconfirm:)];
    
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHTeamNoticeSelectedTeamCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kYZHCommonCellIdentifier];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.allMyOnwerTeam.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NIMTeam* team = self.viewModel.allMyOnwerTeam[indexPath.row];
    YZHTeamNoticeSelectedTeamCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier];
    [cell refresh:team];
    if ([self.selectedIndexPathArray containsObject:indexPath]) {
        [cell addSubview:cell.selectedImageView];
    } else {
        [cell.selectedImageView removeFromSuperview];
    }
    if ([self.viewModel.currentTeamPath isEqual:indexPath]) {
        cell.teamNameLabel.text = [NSString stringWithFormat:@"%@(本群)",team.teamName];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self.viewModel.currentTeamPath isEqual:indexPath]) {
        if ([self.selectedIndexPathArray containsObject:indexPath]) {
            [self.selectedIndexPathArray removeObject:indexPath];
        } else {
            [self.selectedIndexPathArray addObject:indexPath];
        }
        [tableView reloadData];
    }
}

// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

#pragma mark - 5.Event Response

- (void)clickCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickconfirm:(UIBarButtonItem *)sender {
    
    if (YZHIsArray(self.selectedIndexPathArray)) {
        NSMutableArray* teamIdArray = [[NSMutableArray alloc] init];
        @weakify(self)
        [self.selectedIndexPathArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            NIMTeam* team = self.viewModel.allMyOnwerTeam[idx];
            [teamIdArray addObject:team.teamId];
        }];
        self.selectedTeamBlock ? self.selectedTeamBlock(teamIdArray) : NULL;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (YZHTeamNoticeSelectTeamModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[YZHTeamNoticeSelectTeamModel alloc] initWithTeamId:self.teamId];
    }
    return _viewModel;
}

- (NSMutableArray *)selectedIndexPathArray {
    
    if (!_selectedIndexPathArray) {
        _selectedIndexPathArray = [[NSMutableArray alloc] init];
        if (self.viewModel.currentTeamPath) {
            [_selectedIndexPathArray addObject:self.viewModel.currentTeamPath];
        }
    }
    return _selectedIndexPathArray;
}

@end
