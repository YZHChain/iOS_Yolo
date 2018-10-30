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

static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
static NSString* const kYZHFriendsCellIdentifier = @"friendsCellIdentifier";
static NSString* const kYZHAdditionalCellIdentifier = @"additionalCellIdentifier";
@interface YZHAddressBookVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, JKRSearchBarDelegate, JKRSearchControllerDelegate, JKRSearchControllerhResultsUpdating, SCTableViewSectionIndexDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* indexArray;
@property (nonatomic, strong) JKRSearchController* searchController;
@property (nonatomic, strong) SCIndexViewConfiguration* indexViewConfiguration;

@end

@implementation YZHAddressBookVC

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

- (void)viewDidAppear:(BOOL)animated {

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
    [self.view addSubview:self.tableView];
    //设置右边索引;
    self.tableView.sc_indexViewConfiguration = self.indexViewConfiguration;
    self.tableView.sc_indexViewDataSource = self.indexArray;
    self.tableView.delegate = self;
    
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.indexArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 ) {
        return 2;
    } else {
        return 2;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YZHAddBookAdditionalCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHAdditionalCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"addBook_cover_cell_addFirendLog"];
            cell.titleLabel.text = @"好友添加记录";
        }
        return cell;
    }
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHFriendsCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //TODO: 需要对 Router 封装跳转逻辑优化
    if (indexPath.section == 0 && indexPath.row == 0) {
        //TODO: 分两种推出方式, 如果用户已授权手机号信息,则Push. 否则 Presen.
        [YZHRouter openURL:kYZHRouterAddressBookPhoneContact];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        //TODO:
        [YZHRouter openURL:kYZHRouterAddressBookAddFirendRecord];
    } else {
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails];
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
        view.titleLabel.text = self.indexArray[section - 1];
    }
    
    return view;
}

#pragma mark -- UITableView Editing

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TODO: 过长
    UITableViewRowAction *categoryAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"分类标签" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        [YZHRouter openURL:kYZHRouterAddressBookSetTag info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES)}];
    }];
    
    UITableViewRowAction *remarkAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"备注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
       [YZHRouter openURL:kYZHRouterAddressBookSetNote info:@{kYZHRouteSegue: kYZHRouteSegueModal, kYZHRouteSegueNewNavigation: @(YES)}];
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
    [tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:NO];
    
}

- (NSUInteger)sectionOfTableViewDidScroll:(UITableView *)tableView {

    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    NSInteger indexSection = indexPath.section;
    if (indexSection > 0) {
        indexSection = indexPath.section - 1;
    } else {
        indexPath = 0;
    }
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
}

- (void)clickRightBarGotoAddFirend:(UIButton *)sender{
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirend];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 10, self.view.width, self.view.height - 64 - 40 - 10);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.rowHeight = kYZHCellHeight;
        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.tableFooterView = [YZHAddressBookFootView yzh_viewWithFrame:CGRectMake(0, 0, self.view.width, 48)];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier:kYZHFriendsCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookAdditionalCell" bundle:nil] forCellReuseIdentifier:kYZHAdditionalCellIdentifier];
        _tableView.sectionIndexColor = [UIColor yzh_fontShallowBlack];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (SCIndexViewConfiguration *)indexViewConfiguration {
    //TODO: 不能让Y到表头里面,否则弹出搜索时,会出问题
    if (!_indexViewConfiguration) {
        _indexViewConfiguration = [SCIndexViewConfiguration configuration];
        _indexViewConfiguration.indexItemsSpace = 1.5;
        self.tableView.sc_translucentForTableViewInNavigationBar = YES;
        self.tableView.sc_indexViewDelegate = self;
    }
    return _indexViewConfiguration;
}

- (NSArray *)indexArray{
    
    if (_indexArray == nil) {
        _indexArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }
    return _indexArray;
}

- (JKRSearchController *)searchController {
    
    if (!_searchController) {
        YZHAddBookSearchVC* addBookSearchVC = [[YZHAddBookSearchVC alloc] init];
        _searchController = [[JKRSearchController alloc] initWithSearchResultsController:addBookSearchVC];
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.hidesNavigationBarDuringPresentation = YES;
        // 代理方法都是设计业务, 可以单独抽取出来.
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.delegate = self;
    }
    return _searchController;
}

@end
