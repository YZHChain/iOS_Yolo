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
#import "YZHAddBookSetNoteVC.h"
#import "YZHAddBookSetTagVC.h"
#import "YZHBaseNavigationController.h"

static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
static NSString* const kYZHFriendsCellIdentifier = @"friendsCellIdentifier";
static NSString* const kYZHAdditionalCellIdentifier = @"additionalCellIdentifier";
@interface YZHAddressBookVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong)NSArray* indexArray;

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

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"通讯录";
    
    [self setupNavBarItem];
}

- (void)setupNavBarItem{
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"addBook_cover_leftBarButtonItem_default"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"addBook_cover_leftBarButtonItem_catogory"] forState:UIControlStateSelected];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"my_myinformationCell_headPhoto_default"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [leftButton addTarget:self action:@selector(clickLeftBarSwitchType:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(clickRightBarGotoAddFirend:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self.view addSubview:self.tableView];
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    self.tableView.sc_indexViewConfiguration = indexViewConfiguration;
 self.tableView.sc_translucentForTableViewInNavigationBar = YES;
    self.tableView.sc_indexViewDataSource = self.indexArray;
    
    
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
        return cell;
    }
    YZHAddBookFriendsCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHFriendsCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [YZHRouter openURL:kYZHRouterAddressBookDetail];
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

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TODO: 过长
    UITableViewRowAction *categoryAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"分类标签" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //TODO:
        YZHAddBookSetTagVC* vc = [[YZHAddBookSetTagVC alloc] init];
        YZHBaseNavigationController* nav = [[YZHBaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    
    UITableViewRowAction *remarkAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"备注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //TODO:
        YZHAddBookSetNoteVC* vc = [[YZHAddBookSetNoteVC alloc] init];
        YZHBaseNavigationController* nav = [[YZHBaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    
    categoryAction.backgroundColor = [UIColor colorWithRed:148/255.0 green:156/255.0 blue:169/255.0 alpha:1];
    remarkAction.backgroundColor = [UIColor colorWithRed:207/255.0 green:211/255.0 blue:217/255.0 alpha:1];
    
    return @[remarkAction, categoryAction];
}

//- tableviewit
#pragma mark - 5.Event Response

- (void)clickLeftBarSwitchType:(UIButton *)sender{
    
    sender.selected = !sender.isSelected;
}

- (void)clickRightBarGotoAddFirend:(UIButton *)sender{
    
    sender.selected = !sender.isSelected;
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
        _tableView.rowHeight = 55;
        _tableView.tableHeaderView = [YZHAddressBookHeaderView yzh_viewWithFrame:CGRectMake(0, 0, self.view.width, 48)];
        _tableView.tableFooterView = [YZHAddressBookFootView yzh_viewWithFrame:CGRectMake(0, 0, self.view.width, 48)];
        _tableView.tableFooterView.backgroundColor = [UIColor yellowColor];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookFriendsCell" bundle:nil] forCellReuseIdentifier:kYZHFriendsCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookAdditionalCell" bundle:nil] forCellReuseIdentifier:kYZHAdditionalCellIdentifier];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionIndexColor = [UIColor yzh_fontshallowBlack];
    }
    return _tableView;
}

- (NSArray *)indexArray{
    
    if (_indexArray == nil) {
        _indexArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }
    return _indexArray;
}

@end
