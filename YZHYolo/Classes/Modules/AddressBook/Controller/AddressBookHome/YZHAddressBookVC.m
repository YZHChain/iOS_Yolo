//
//  YZHAddressBookVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddressBookVC.h"

#import "YZHAddressBookHeaderView.h"
#import "YZHAddBookFriendsCell.h"
#import "YZHAddBookSectionView.h"
#import "YZHAddBookAdditionalCell.h"
#import "YZHAddressBookFootView.h"
#import "UITableView+SCIndexView.h"
#import "YZHBaseNavigationController.h"
#import "YZHPublic.h"
#import "JKRSearchController.h"
#import "YZHAddBookSearchVC.h"
#import "YZHGroupedContacts.h"
#import "YZHContactMemberModel.h"
#import "YZHAddBookDetailsModel.h"
#import "YZHTagContactManage.h"
#import "YZHSearchView.h"
#import "YZHAddBookPhoneContactVC.h"

typedef enum : NSUInteger {
    YZHAddressBookShowTypeDefault = 0,
    YZHAddressBookShowTypeTag = 1,
} YZHAddressBookShowType;
static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
static NSString* const kYZHFriendsCellIdentifier = @"friendsCellIdentifier";
static NSString* const kYZHAdditionalCellIdentifier = @"additionalCellIdentifier";
@interface YZHAddressBookVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, JKRSearchBarDelegate, JKRSearchControllerDelegate, JKRSearchControllerhResultsUpdating, SCTableViewSectionIndexDelegate, NIMUserManagerDelegate,
    NIMSystemNotificationManagerDelegate, NIMEventSubscribeManagerDelegate>

@property (nonatomic, strong) UITableView* defaultTableView;
@property (nonatomic, strong) UITableView* tagTableView;
@property (nonatomic, strong) YZHSearchView* searchView;
@property (nonatomic, strong) YZHSearchView* tagSearchView;
@property (nonatomic, strong) SCIndexViewConfiguration* indexViewConfiguration;
@property (nonatomic, strong) YZHGroupedContacts* contacts;
@property (nonatomic, strong) YZHTagContactManage* tagContactManage;
@property (nonatomic, assign) YZHAddressBookShowType currentType;

@end

@implementation YZHAddressBookVC

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNIMDelegate {
    
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
}

- (void)dealloc {
    
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager removeDelegate:self];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"通讯录";
    
    [self setupNavBarItem];
}

- (void)setupNavBarItem{
    
    //TODO: 封装库后期可优化
    @weakify(self)
    UIButton* leftButton = [UIButton yzh_setBarButtonItemWithStateNormalImageName:@"addBook_cover_leftBarButtonItem_default" stateSelectedImageName:@"addBook_cover_leftBarButtonItem_catogory" tapCallBlock:^(UIButton *sender) {
        @strongify(self)
        [self clickLeftBarSwitchType:sender];
    }];
    UIButton* rightButton = [UIButton yzh_setBarButtonItemWithImageName:@"addBook_cover_rightBarButtonItem_addFirend" tapCallBlock:^(UIButton *sender) {
        @strongify(self)
        [self clickRightBarGotoAddFirend:sender];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self.view addSubview:self.tagTableView];
    [self.view addSubview:self.defaultTableView];
    //设置右边索引;
    self.defaultTableView.sc_indexViewConfiguration = self.indexViewConfiguration;
    self.defaultTableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
    self.defaultTableView.delegate = self;
}

#pragma mark - 3.Request Data

- (void)setupData
{
    self.currentType = YZHAddressBookShowTypeDefault;
    self.contacts = [[YZHGroupedContacts alloc] init];
    self.tagContactManage = [[YZHTagContactManage alloc] init];
    self.defaultTableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
}

- (void)refresh {
    
    if (self.currentType == YZHAddressBookShowTypeDefault) {
        self.defaultTableView.hidden = NO;
        self.tagTableView.hidden = YES;
        self.defaultTableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
    } else {
        self.defaultTableView.hidden = YES;
        self.tagTableView.hidden = NO;
        self.defaultTableView.sc_indexViewDataSource = nil;
    }
    [self.defaultTableView reloadData];
    [self.tagTableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([self.defaultTableView isEqual: tableView]) {
       return _contacts.groupTitleCount + 1;
    } else {
        return _tagContactManage.tagContacts.count + 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    } else {
        if ([self.defaultTableView isEqual:tableView]) {
            return [_contacts memberCountOfGroup:section - 1];
        } else {
            return _tagContactManage.tagContacts[section - 1].count;
        }
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YZHAddBookAdditionalCell* cell = [YZHAddBookAdditionalCell tempTableViewCellWithTableView:tableView indexPath:indexPath];
        return cell;
    }
    
    YZHContactMemberModel* memberModel;
    if ([self.defaultTableView isEqual:tableView]) {
        memberModel =  (YZHContactMemberModel *)[_contacts memberOfIndex:indexPath];
    } else {
        memberModel = self.tagContactManage.tagContacts[indexPath.section - 1][indexPath.row];
    }
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHFriendsCellIdentifier forIndexPath:indexPath];
    [cell refreshUser:memberModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //TODO: 需要对 Router 封装跳转逻辑优化
    if (indexPath.section == 0 && indexPath.row == 0) {
        //TODO: 分两种推出方式, 如果用户已授权手机号信息,则Push. 否则 Presen.
        [YZHRouter openURL:kYZHRouterAddressBookPhoneContact];
//        YZHAddBookPhoneContactVC* vc = [[YZHAddBookPhoneContactVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        //TODO:
        [YZHRouter openURL:kYZHRouterAddressBookAddFirendRecord];
    } else {
        YZHContactMemberModel* memberModel;
        if ([self.defaultTableView isEqual:tableView]) {
            memberModel =  (YZHContactMemberModel *)[_contacts memberOfIndex:indexPath];
        } else {
            memberModel = self.tagContactManage.tagContacts[indexPath.section - 1][indexPath.row];
        }
//        YZHAddBookDetailsModel* model = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:memberModel.info.infoId];
        [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": memberModel.info.infoId}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    YZHAddBookSectionView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHAddBookSectionViewIdentifier];
    if (section == 0) {
        view.titleLabel.text = nil;
    } else {
        if ([self.defaultTableView isEqual: tableView]) {
            view.titleLabel.text = self.contacts.sortedGroupTitles[section - 1];
        } else {
            view.titleLabel.text = self.tagContactManage.showTagNameArray[section - 1];
        }
    }
    
    return view;
}

#pragma mark -- UITableView Editing

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO: 过长
    @weakify(self)
    UITableViewRowAction *categoryAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"分类标签" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        @strongify(self)
        
        YZHContactMemberModel* memberModel;
        if ([self.defaultTableView isEqual:tableView]) {
            memberModel =  (YZHContactMemberModel *)[self.contacts memberOfIndex:indexPath];
        } else {
            memberModel = self.tagContactManage.tagContacts[indexPath.section - 1][indexPath.row];
        }
        YZHAddBookDetailsModel* model = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:memberModel.info.infoId];
        [YZHRouter openURL:kYZHRouterAddressBookSetTag info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES),
                                                              @"userDetailsModel": model
                                                              }];
    }];
    
    UITableViewRowAction *remarkAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"备注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
          @strongify(self)
          YZHContactMemberModel* memberModel;
          if ([self.defaultTableView isEqual:tableView]) {
              memberModel =  (YZHContactMemberModel *)[self->_contacts   memberOfIndex:indexPath];
          } else {
              memberModel =   self.tagContactManage.tagContacts[indexPath.section - 1]  [indexPath.row];
          }
          YZHAddBookDetailsModel* model = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:memberModel.info.infoId];
           [YZHRouter openURL:kYZHRouterAddressBookSetNote info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES),
                                                              @"userDetailsModel": model
                                                                  }];
    }];
    
    categoryAction.backgroundColor = [UIColor colorWithRed:148/255.0 green:156/255.0 blue:169/255.0 alpha:1];
    remarkAction.backgroundColor = [UIColor colorWithRed:207/255.0 green:211/255.0 blue:217/255.0 alpha:1];
    
    
    return @[remarkAction, categoryAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - SCTableViewSectionIndexDelegate
// 重写这两个代理方法,否则默认算法 indexView 与实际不一致.
- (void)tableView:(UITableView *)tableView didSelectIndexViewAtSection:(NSUInteger)section {
    
    NSIndexPath* indexPath;
    if (section > 0) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section + 1];
    } else {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    CGRect frame = [tableView rectForSection:indexPath.section];
    [_defaultTableView setContentOffset:CGPointMake(0, frame.origin.y) animated:NO];
    
}

- (NSUInteger)sectionOfTableViewDidScroll:(UITableView *)tableView {
    
    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    NSInteger indexSection = indexPath.section;
    if (indexSection > 0) {
        indexSection = indexPath.section - 1;
    } else {
        indexPath = 0;
    }
    //TODO
    return indexSection;
}

#pragma mark - JKRSearchControllerhResultsUpdating

- (void)updateSearchResultsForSearchController:(JKRSearchController *)searchController {
//    NSString *searchText = searchController.searchBar.text;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF CONTAINS %@)", searchText];
//    JKRSearchResultViewController *resultController = (JKRSearchResultViewController *)searchController.searchResultsController;
//    if (!(searchText.length > 0)) resultController.filterDataArray = @[];
//    else resultController.filterDataArray = [self.dataArray filteredArrayUsingPredicate:predicate];
}

#pragma mark - JKRSearchControllerDelegate

- (void)willPresentSearchController:(JKRSearchController *)searchController {
//    NSLog(@"willPresentSearchController, %@", searchController);
}

- (void)didPresentSearchController:(JKRSearchController *)searchController {
//    NSLog(@"didPresentSearchController, %@", searchController);
}

- (void)willDismissSearchController:(JKRSearchController *)searchController {
//    NSLog(@"willDismissSearchController, %@", searchController);
}

- (void)didDismissSearchController:(JKRSearchController *)searchController {
//    NSLog(@"didDismissSearchController, %@", searchController);
}

#pragma mark - JKRSearchBarDelegate

- (void)searchBarTextDidBeginEditing:(JKRSearchBar *)searchBar {
//    NSLog(@"searchBarTextDidBeginEditing %@", searchBar);
}

- (void)searchBarTextDidEndEditing:(JKRSearchBar *)searchBar {
//    NSLog(@"searchBarTextDidEndEditing %@", searchBar);
}

- (void)searchBar:(JKRSearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"searchBar:%@ textDidChange:%@", searchBar, searchText);
}

#pragma mark - 5.Event Response

- (void)clickLeftBarSwitchType:(UIButton *)sender{
    
    sender.selected = !sender.isSelected;
    self.currentType = !self.currentType;
//    if (self.currentType == YZHAddressBookShowTypeDefault) {
//        self.defaultTableView.hidden = NO;
//        self.tagTableView.hidden = YES;
//    } else {
//        self.defaultTableView.hidden = YES;
//        self.tagTableView.hidden = NO;
//    }
    [self refresh];
}

- (void)clickRightBarGotoAddFirend:(UIButton *)sender{
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirend];
}

#pragma mark - 6.Private Methods

- (void)onTouchSearch:(UIButton *)sender {
    
    [YZHRouter openURL:kYZHRouterAddressBookSearchFirend info:@{kYZHRouteSegue: kYZHRouteSegueModal ,kYZHRouteSegueNewNavigation : @(YES)}];
}

#pragma mark - NIMSDKDelegate

- (void)onUserInfoChanged:(NIMUser *)user
{
    self.contacts = [[YZHGroupedContacts alloc] init];
    self.tagContactManage = [[YZHTagContactManage alloc] init];
    [self refresh];
}

- (void)onFriendChanged:(NIMUser *)user{
    
    self.contacts = [[YZHGroupedContacts alloc] init];
    self.tagContactManage = [[YZHTagContactManage alloc] init];
    [self refresh];
}
//收到系统消息
- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    
    
}

#pragma mark - 7.GET & SET

- (UITableView *)defaultTableView{
    
    if (_defaultTableView == nil) {
        
        _defaultTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _defaultTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64 - 40 - 10);
        _defaultTableView.delegate = self;
        _defaultTableView.dataSource = self;
        _defaultTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _defaultTableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _defaultTableView.rowHeight = kYZHCellHeight;
        _defaultTableView.tableHeaderView = self.searchView;
        _defaultTableView.tableFooterView = [YZHAddressBookFootView yzh_viewWithFrame:CGRectMake(0, 10, self.view.width, 48)];
        [_defaultTableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
        [_defaultTableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier:kYZHFriendsCellIdentifier];
        _defaultTableView.sectionIndexColor = [UIColor yzh_fontShallowBlack];
        _defaultTableView.showsVerticalScrollIndicator = NO;
    }
    return _defaultTableView;
}

- (UITableView *)tagTableView{
    
    if (_tagTableView == nil) {
        
        _tagTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tagTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64 - 40 - 10);
        _tagTableView.delegate = self;
        _tagTableView.dataSource = self;
        _tagTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tagTableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tagTableView.rowHeight = kYZHCellHeight;
        _tagTableView.tableHeaderView = self.tagSearchView;
        _tagTableView.tableFooterView = [YZHAddressBookFootView yzh_viewWithFrame:CGRectMake(0, 0, self.view.width, 48)];
        [_tagTableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
        [_tagTableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier:kYZHFriendsCellIdentifier];
        _tagTableView.sectionIndexColor = [UIColor yzh_fontShallowBlack];
        _tagTableView.showsVerticalScrollIndicator = NO;
    }
    return _tagTableView;
}

- (SCIndexViewConfiguration *)indexViewConfiguration {
    //TODO: 不能让Y到表头里面,否则弹出搜索时,会出问题
    if (!_indexViewConfiguration) {
        _indexViewConfiguration = [SCIndexViewConfiguration configuration];
        _indexViewConfiguration.indexItemsSpace = 1.5;
        self.defaultTableView.sc_translucentForTableViewInNavigationBar = YES;
        self.defaultTableView.sc_indexViewDelegate = self;
    }
    return _indexViewConfiguration;
}

- (YZHSearchView *)searchView {
    
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"YZHSearchView" owner:nil options:nil].lastObject;
        [_searchView.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchView;
}

- (YZHSearchView *)tagSearchView {
    
    if (!_tagSearchView) {
        _tagSearchView = [[NSBundle mainBundle] loadNibNamed:@"YZHSearchView" owner:nil options:nil].lastObject;
        [_tagSearchView.searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagSearchView;
}


@end
