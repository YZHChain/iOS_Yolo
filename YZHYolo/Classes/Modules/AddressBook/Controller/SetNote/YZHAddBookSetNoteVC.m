//
//  YZHAddBookSetNoteVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetNoteVC.h"

#import "YZHAddBookSetNoteCell.h"
#import "YZHAddBookSetTagVC.h"
#import "YZHBaseNavigationController.h"

@interface YZHAddBookSetNoteVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YZHAddBookSetNoteVC

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
    self.navigationItem.title = @"设置备注";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.rowHeight = 55;
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddBookSetNoteCellType cellType;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellType = YZHAddBookSetNoteCellNoteNameType;
        } else {
            cellType = YZHAddBookSetNoteCellPhoneType;
        }
    } else {
        cellType = YZHAddBookSetNoteCellCategoryTagType;
    }
    
    YZHAddBookSetNoteCell* cell = [YZHAddBookSetNoteCell tempTableViewCellWith:tableView indexPath:indexPath cellType:cellType];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kYZHCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
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
    YZHAddBookSetNoteCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    // 选中备注
    if (indexPath.section == 0) {
        
        [cell.subtitleTextField becomeFirstResponder];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        // 跳转到设置标签页
        YZHAddBookSetTagVC* vc = [[YZHAddBookSetTagVC alloc] init];
        YZHBaseNavigationController* nav = [[YZHBaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

#pragma mark - 5.Event Response

- (void)clickLeftBarItem {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickRightBarItem {
    
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end

