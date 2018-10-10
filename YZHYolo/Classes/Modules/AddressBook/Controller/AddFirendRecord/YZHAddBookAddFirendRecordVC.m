//
//  YZHAddBookAddFirendRecordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/5.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendRecordVC.h"

#import "YZHCommanDefaultView.h"
#import "YZHPublic.h"
#import "YZHAddFirendRecordSectionHeader.h"
#import "YZHAddBookAddFirendRecordCell.h"
@interface YZHAddBookAddFirendRecordVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHCommanDefaultView* withoutDefaultView;

@end

@implementation YZHAddBookAddFirendRecordVC

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
    
    self.navigationItem.title = @"好友申请";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend:)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHAddFirendRecordSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHCommonHeaderIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.showsVerticalScrollIndicator = NO;
    
//    [self.view addSubview:self.withoutDefaultView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddFirendRecordCellType cellType;
    if (indexPath.section < 2) {
        cellType = YZHAddFirendRecordCellTypeDating;
    } else {
        cellType = YZHAddFirendRecordCellTypeReview;
    }
    YZHAddBookAddFirendRecordCell* cell = [YZHAddBookAddFirendRecordCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:cellType];
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction* removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    
    return @[removeAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kYZHCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kYZHSectionHeight;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddFirendRecordSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHCommonHeaderIdentifier];
    
    return sectionHeader;
}
// 添加分段尾,为了隐藏分区最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"isShowFirendRecord": @"YES"}];
}

#pragma mark - 5.Event Response

- (void)addFriend:(UIBarButtonItem* )barButtonItem {
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirend];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

-(YZHCommanDefaultView *)withoutDefaultView {
    
    if (!_withoutDefaultView) {
        _withoutDefaultView = [YZHCommanDefaultView commanDefaultViewWithImageName:@"addBook_addFirendRecord_defualt" TitleString:@"暂无好友申请" subTitleString:@"（暂时无好友添加您，不如点击右上角按钮去添加好友吧)"];
    }
    return _withoutDefaultView;
}

@end
