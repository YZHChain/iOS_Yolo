//
//  YZHAddBookSearchVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSearchVC.h"
#import "YZHUserLoginManage.h"
#import "YZHSearchModel.h"
#import "YZHSearchTeamCell.h"
#import "YZHSearchRecommendSectionView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YZHUserDataManage.h"
#import "YZHCommandTipLabelView.h"
#import "YZHAddBookFriendsCell.h"
#import "YZHUserModelManage.h"
#import "YZHAddBookSectionView.h"

static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
static NSString* const kYZHFriendsCellIdentifier = @"friendsCellIdentifier";
static NSString* const kYZHAdditionalCellIdentifier = @"additionalCellIdentifier";
@interface YZHAddBookSearchVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, YZHSearchLabelSelectedProtocol>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) YZHSearchListModel* searchModel;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, strong) NSString* lastKeyText;
@property (nonatomic, assign) int searchPageNumber;
@property (nonatomic, strong) YZHUserDataModel* userDataModel;
@property (nonatomic, strong) YZHCommandTipLabelView* tipLabelView;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, copy) NSString* tagLabelText;

@end

@implementation YZHAddBookSearchVC

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
    //    [self setupNotification];
    
    self.fd_prefersNavigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style
- (void)setupNavBar {
    
    [self searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tipLabelView];
    
    self.isSearchStatus = NO;
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearchStatus) {
        return self.searchModel.searchFirends.count ? 1 : 0;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearchStatus) {
        return self.searchModel.searchFirends.count;
    } else {
        return 0;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHContactMemberModel* memberModel = [self.searchModel.searchFirends objectAtIndex:indexPath.row];
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHFriendsCellIdentifier forIndexPath:indexPath];
    [cell refreshUser:memberModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (YZHIsString(self.tagLabelText)) {
        return 40;
    } else {
        return 0;
    }
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddBookSectionView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHAddBookSectionViewIdentifier];
    view.titleLabel.text = self.tagLabelText;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHContactMemberModel* memberModel = [self.searchModel.searchFirends objectAtIndex:indexPath.row];
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": memberModel.info.infoId}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    if (YZHIsString(searchBar.text)) {
        self.isSearchStatus = YES;
        [self searchTeamListWithKeyText:searchBar.text];
    } else {
        self.isSearchStatus = NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!YZHIsString(searchBar.text)) {
        self.isSearchStatus = NO;
        self.tipLabelView.hidden = NO;
        self.tipLabelView.titleLabel.text = @"选择好友分类";
        self.tableView.hidden = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - YZHSearchLabelSelectedProtocol

- (void)selectedTagLabel:(UIButton *)tagLabel {
    
    self.textField.text = tagLabel.titleLabel.text;
    [self.searchBar endEditing:YES];
    [self.searchModel searchFirendTag:self.textField.text];
    self.isSearchStatus = YES;
    if (self.searchModel.searchFirends.count) {
        self.tagLabelText = tagLabel.titleLabel.text;
        self.tipLabelView.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.tagLabelText = nil;
        self.tableView.hidden = YES;
        self.tipLabelView.hidden = NO;
        self.tipLabelView.titleLabel.text = @"未找到相关分类好友";
    }
    [self.tableView reloadData];
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)searchTeamListWithKeyText:(NSString *)keyText {
    
    self.tagLabelText = nil;
    if (YZHIsString(keyText)) {
        [self.searchModel searchFirendKeyText:keyText];
        self.isSearchStatus = YES;
        [self.tableView reloadData];
        if (self.searchModel.searchFirends.count) {
            self.tipLabelView.hidden = YES;
            self.tableView.hidden = NO;
        } else {
            self.tipLabelView.hidden = NO;
            self.tipLabelView.titleLabel.text = @"未找到相关好友";
            self.tableView.hidden = YES;
        }
    } else {
        self.isSearchStatus = NO;
        [self.tableView reloadData];
    }

    //如果搜索的是同一个关键字则页号 + 1; 否则默认从第一页开始
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //        _tableView.frame = CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64);
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier:kYZHFriendsCellIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        
        UISearchBar * searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width-80,33)];
        searchbar.placeholder = @"搜索";
        searchbar.searchBarStyle = UISearchBarStyleDefault;
        searchbar.showsCancelButton = YES;
        //通过KVC拿到textField
        UITextField  *seachTextFild = [searchbar valueForKey:@"searchField"];
        seachTextFild.textColor = [UIColor yzh_fontShallowBlack];
        seachTextFild.font = [UIFont yzh_commonFontStyleFontSize:14];
        //修改光标颜色
        [seachTextFild setTintColor:[UIColor blueColor]];
        
        self.textField = seachTextFild;
        for (id cencelButton in [searchbar.subviews[0] subviews])
        {
            if([cencelButton isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cencelButton;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        searchbar.delegate = self;
        if (@available(iOS 9.0, *)) {
            [[searchbar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
        } else {
            // Fallback on earlier versions
        }
        self.navigationItem.titleView = searchbar;
        
        _searchBar = searchbar;
    }
    return _searchBar;
}

- (YZHUserDataModel *)userDataModel {
    
    if (!_userDataModel) {
        _userDataModel = [[YZHUserDataManage sharedManager] currentUserData];
    }
    return _userDataModel;
}

- (YZHCommandTipLabelView *)tipLabelView {
    
    if (!_tipLabelView) {
        _tipLabelView = [YZHCommandTipLabelView yzh_viewWithFrame:self.view.bounds];
        YZHUserInfoExtManage* userInfo = [YZHUserInfoExtManage currentUserInfoExt];
        NSMutableArray* labelArray = [[NSMutableArray alloc] init];
        for (YZHUserCustomTagModel* tagModel in userInfo.customTags) {
            [labelArray addObject:tagModel.tagName];
        }
        if (labelArray.count) {
            [labelArray addObject:@"无分类好友"];
        }
        [_tipLabelView.showLabelView refreshLabelButtonWithLabelArray:labelArray];
        _tipLabelView.showLabelView.delegate = self;
    }
    return _tipLabelView;
}

- (YZHSearchListModel *)searchModel {
    
    if (!_searchModel) {
        _searchModel = [[YZHSearchListModel alloc] init];
    }
    return _searchModel;
}

@end
