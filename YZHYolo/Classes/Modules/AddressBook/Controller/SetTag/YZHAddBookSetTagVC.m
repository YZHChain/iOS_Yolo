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
#import "YZHAddBookSetTagSectionView.h"


static NSString* const kSetTagCellIdentifier =  @"setTagCellIdentifier";
static NSString* const kSetTagCellSectionIdentifier =  @"setTagCellSectionIdentifier";
@interface YZHAddBookSetTagVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)YZHAddBookSetTagFooterView* footerView;
@property (nonatomic, strong) UIImageView* selectedImageView;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

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
    [self.tableView registerClass:[YZHAddBookSetTagSectionView class] forHeaderFooterViewReuseIdentifier:kSetTagCellSectionIdentifier];
    self.footerView = [[NSBundle mainBundle] loadNibNamed:@"YZHAddBookSetTagFooterView" owner:nil options:nil].lastObject;
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
    [self.footerView.addTagButton addTarget:self action:@selector(clickAdditionTag:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.tableView setEditing:YES animated:YES];
//    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
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
    
    return 15;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddBookSetTagCell* cell = [YZHAddBookSetTagCell tempTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"☆标准好友";
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"家人";
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"同事";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddBookSetTagSectionView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSetTagCellSectionIdentifier];
    if (section == 0) {
        view.titleLabel.text = @"选择已有标签";
    } else {
        view.titleLabel.text = @"自定义标签";
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZHAddBookSetTagCell* selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    YZHAddBookSetTagCell* lastSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
    [lastSelectedCell.titleLabel setTextColor:YZHColorWithRGB(193, 193, 193)];
    self.selectedIndexPath = indexPath;
    [selectedCell.contentView addSubview:self.selectedImageView];
    [selectedCell.titleLabel setTextColor:[UIColor yzh_fontShallowBlack]];
}

#pragma mark -- UITableView Editing
// 定制编辑按钮.
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section == 1) {
//
//        UITableViewRowAction* removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//            [tableView setEditing:NO animated:NO];
//        }];
//
//        return @[removeAction];
//    } else {
//
//        return nil;
//    }
//}
//点击编辑按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            NSLog(@"删除了哦");
        }

    } else {

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}
// 设置支持编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        return YES;
    } else {
        return NO;
    }
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
    // TODO: 待重新封装.
    [alertView yzh_showOnWindowAnimations:^{
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UIImageView *)selectedImageView {
    
    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_information_setName_selected"]];
        _selectedImageView.frame = CGRectMake(YZHView_Width - 18 - _selectedImageView.width, 18, _selectedImageView.width, _selectedImageView.height);
    }

    return _selectedImageView;
}

- (NSIndexPath *)selectedIndexPath {
    
    if (!_selectedIndexPath) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectedIndexPath;
}

@end
