//
//  YZHAddressBookBlackListVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddressBookBlackListVC.h"

#import "YZHAddBookFriendsCell.h"
#import "YZHBlackContacts.h"
#import "UITableView+SCIndexView.h"
#import "YZHAddBookSectionView.h"

@interface YZHAddressBookBlackListVC ()<UITableViewDelegate, UITableViewDataSource, SCTableViewSectionIndexDelegate, NIMUserManagerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) YZHBlackContacts* contacts;

@end

@implementation YZHAddressBookBlackListVC

#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 配置云信代理
    [self setUpNIMDelegate];
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

- (void)setUpNIMDelegate {
    
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
}

- (void)dealloc {
    
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
}


#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"黑名单管理";
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.contacts = [[YZHBlackContacts alloc] init];
    
    self.tableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.contacts.groupTitleCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.contacts memberCountOfGroup:section];
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHContactMemberModel* memberModel =  (YZHContactMemberModel *)[_contacts atMemberOfIndex:indexPath];
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    [cell refreshUser:memberModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddBookSectionView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHCommonHeaderIdentifier];
    headerView.titleLabel.text = self.contacts.sortedGroupTitles[section];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHContactMemberModel* memberModel =  (YZHContactMemberModel *)[_contacts atMemberOfIndex:indexPath];
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": memberModel.info.infoId ? memberModel.info.infoId : @""}];
}

//点击编辑按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    YZHContactMemberModel<YZHGroupMemberProtocol>* memberModel =  (YZHContactMemberModel<YZHGroupMemberProtocol> *)[_contacts atMemberOfIndex:indexPath];
    @weakify(self)
    [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:memberModel.info.infoId completion:^(NSError * _Nullable error) {
        @strongify(self)
        if (!error) {
           [self.contacts removeGroupMember:memberModel];
           self.tableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
           [self.tableView reloadData];
        }
    }];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

#pragma mark -

- (void)onBlackListChanged {
    
    self.contacts = [[YZHBlackContacts alloc] init];
    [self.tableView reloadData];
}

#pragma mark - SCTableViewSectionIndexDelegate
// 重写这两个代理方法,否则默认算法 indexView 与实际不一致.
- (void)tableView:(UITableView *)tableView didSelectIndexViewAtSection:(NSUInteger)section {
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    CGRect frame = [tableView rectForSection:indexPath.section];
    
    [tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:NO];
}

- (NSUInteger)sectionOfTableViewDidScroll:(UITableView *)tableView {
    
    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    NSInteger indexSection = indexPath.section;
    //TODO
    return indexSection;
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier: kYZHCommonCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHCommonHeaderIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
