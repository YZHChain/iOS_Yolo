//
//  YZHAddBookDetailsVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookDetailsVC.h"

#import "YZHAddBookUserIDCell.h"
#import "YZHAddBookSettingCell.h"
#import "YZHAddBookUserAskFooterView.h"
#import "YZHAddBookSetTagVC.h"
#import "YZHBaseNavigationController.h"

@interface YZHAddBookDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YZHAddBookDetailsVC
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
    self.navigationItem.title = @"详情资料";
    //TODO:
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(clickRightItemGotoSetting) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"addBook_userDetails_rightBarButton_default"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    //TODO: 计算高度.
    self.tableView.tableFooterView = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookUserAskFooterView" owner:nil options:nil].lastObject;
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
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 配置Cell
    if (indexPath.section == 0) {
        //TODO: NIB 封装
        YZHAddBookUserIDCell* cell = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookUserIDCell" owner:nil options:nil].lastObject;
        return cell;
    } else {
        YZHAddBookSettingCell* cell = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookSettingCell" owner:nil options:nil].lastObject;
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.titleLabel.text = @"设置备注";
            cell.showTextLabel.text = nil;
            cell.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            cell.titleLabel.text = @"手机号码";
            cell.showTextLabel.text = @"18876789520";
            [cell.guideImageView removeFromSuperview];
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            cell.titleLabel.text = @"设置分类标签";
            cell.guideImageView.image = [UIImage imageNamed:@"my_cover_cell_back"];
            cell.showTextLabel.text = @"家人";
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            cell.titleLabel.text = @"地区";
            [cell.guideImageView removeFromSuperview];
            cell.showTextLabel.text = @"广东,深圳";
        }
        return cell;
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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
    
    if ((indexPath.section == 2 && indexPath.row == 0)) {
        
        YZHAddBookSetTagVC* vc = [[YZHAddBookSetTagVC alloc] init];
        YZHBaseNavigationController* nav = [[YZHBaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

#pragma mark - 5.Event Response

- (void)clickRightItemGotoSetting {
    
    [YZHRouter openURL:kYZHRouterAddressBookSetting];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

@end

