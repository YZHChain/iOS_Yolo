//
//  YZHPrivacySettingVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivacySettingVC.h"
#import "YZHPrivacySettingModel.h"
#import "YZHPrivacySettingCell.h"

@interface YZHPrivacySettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHPrivacySettingContent* viewModel;

@end

@implementation YZHPrivacySettingVC

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

- (void)setupNavBar
{
    //TODO:数据持久化未做.
    self.navigationItem.title = @"隐私设置";
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.viewModel.modelArray.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* privacySettingCell = @"privacyCellIdentifier";
    YZHPrivacySettingCell* cell = [tableView dequeueReusableCellWithIdentifier:privacySettingCell];
    YZHPrivacySettingModel* model = self.viewModel.modelArray[indexPath.row];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YZHPrivacySettingCell" owner:nil options:nil].lastObject;
        cell.titleLabel.text = model.title;
        cell.viewModel = self.viewModel;
    }
    cell.currentRow = indexPath.row;
    cell.subtitleLabel.text = model.subTitle;
    [cell.chooseSwitch setOn:model.isSelected];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kYZHCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZHPrivacySettingModel* model = self.viewModel.modelArray[indexPath.row];
    YZHPrivacySettingCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.chooseSwitch setOn:<#(BOOL)#> animated:<#(BOOL)#>
//    if (indexPath.row == 0) {
//
//    } else if (indexPath.row == 1) {
//
//    } else {
//
//    }
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (YZHPrivacySettingContent *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [YZHPrivacySettingContent sharePrivacySettingContent];
    }
    return _viewModel;
}

@end
