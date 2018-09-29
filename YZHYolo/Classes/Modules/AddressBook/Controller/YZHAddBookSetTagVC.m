//
//  YZHAddBookSetTagVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetTagVC.h"

#import "YZHAddBookSetTagCell.h"
#import "YZHAddBookSetTagFooterView.h"
#import "YZHAddBookSetTagAlertView.h"
//#import "UIView+YZHTool.h"
static NSString* const kSetTagCellIdentifier =  @"setTagCellIdentifier";

@interface YZHAddBookSetTagVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YZHAddBookSetTagVC

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
    self.navigationItem.title = @"设置标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.scrollEnabled = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSetTagCell" bundle:nil] forCellReuseIdentifier:kSetTagCellIdentifier];
    YZHAddBookSetTagFooterView* setTab =  [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookSetTagFooterView" owner:nil options:nil].lastObject;
    self.tableView.tableFooterView = setTab;
    [setTab.addTagButton addTarget:self action:@selector(clickAdditionTag:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddBookSetTagCell* cell = [tableView dequeueReusableCellWithIdentifier:kSetTagCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 5.Event Response

- (void)clickLeftBarItem {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickRightBarItem {
    
}

- (void)clickAdditionTag:(UIButton* )sender {
    
    YZHAddBookSetTagAlertView* alertView = [YZHAddBookSetTagAlertView yzh_viewWithFrame:CGRectMake(37, 186, 300, 191)];
    
    [alertView yzh_showOnWindowAnimations:^{
        
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
