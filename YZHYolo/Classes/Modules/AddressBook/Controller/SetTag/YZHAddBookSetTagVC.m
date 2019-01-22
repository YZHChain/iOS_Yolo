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
#import "YZHSetTagModel.h"
#import "YZHProgressHUD.h"
#import "YZHAlertManage.h"

static NSString* const kSetTagCellSectionIdentifier =  @"setTagCellSectionIdentifier";
@interface YZHAddBookSetTagVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddBookSetTagFooterView* footerView;
@property (nonatomic, strong) UIImageView* selectedImageView;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) YZHSetTagModel* tagsModel;
@property (nonatomic, weak) YZHAddBookSetTagAlertView* alertView;

@end

@implementation YZHAddBookSetTagVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tagsModel = [YZHSetTagModel sharedSetTagModel];
    }
    return self;
}

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
    self.navigationItem.title = @"设置分类";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarItem:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarItem:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    //查找之前选中行数
    self.selectedIndexPath = [self.tagsModel findtargetUserTagName:self.userDetailsModel.classTagModel.subtitle type:YZHSetTagModelTypeUser];
    
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
    
    return self.tagsModel.userTagModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tagsModel tagNumberOfRowsInSection:section type:YZHSetTagModelTypeUser];
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddBookSetTagCell* cell = [YZHAddBookSetTagCell tempTableViewCellWith:tableView indexPath:indexPath];
    
    YZHUserCustomTagModel* tagModel = self.tagsModel.userTagModel[indexPath.section][indexPath.row];
    cell.model = tagModel;
    if ([self.selectedIndexPath isEqual:indexPath]) {
        [cell.contentView addSubview:self.selectedImageView];
        [cell.titleLabel setTextColor:[UIColor yzh_fontShallowBlack]];
    } else {
        [cell.titleLabel setTextColor:YZHColorRGBAWithRGBA(193, 193, 193, 1)];
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
        view.titleLabel.text = @"选择已有分类";
    } else {
        if (self.tagsModel.userTagModel.count == 2) {
           view.titleLabel.text = [NSString stringWithFormat:@"自定义分类（%ld / 5）", self.tagsModel.userTagModel.lastObject.count];
        } else {
           view.titleLabel.text = [NSString stringWithFormat:@"自定义分类（0 / 5）"];
        }
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedIndexPath) {
        if ([self.selectedIndexPath isEqual:indexPath]) {
            self.selectedIndexPath = nil;
        } else {
            self.selectedIndexPath = indexPath;
        }
    } else {
        self.selectedIndexPath = indexPath;
    }
    if (!self.selectedIndexPath) {
        [self.selectedImageView removeFromSuperview];
    }
    
    [tableView reloadData];
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
            @weakify(self)
            [YZHAlertManage showAlertTitle:nil message:@"仅删除分类, 被该标签标记的好友会恢复成无分类 " actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
                @strongify(self)
                if (buttonIndex == 1) {
                    [self removeCustomTagName:indexPath.row];
                    [self.tableView reloadData];
                }
            }];
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

- (void)clickLeftBarItem:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickRightBarItem:(UIBarButtonItem* )sender {
    
    if (!self.selectedIndexPath && YZHIsString(self.userDetailsModel.classTagModel.subtitle)) {
        
        [self updateUserSelectedTagName:nil];
        return;
    }
    YZHAddBookSetTagCell* cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    NSString* selectedTag = cell.titleLabel.text;
    if (![selectedTag isEqualToString:self.userDetailsModel.classTagModel.title]) {
        [self updateUserSelectedTagName:selectedTag];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }

}

- (void)updateUserSelectedTagName:(NSString *)tagName {
    
    YZHTargetUserExtManage* userExtManage = [YZHTargetUserExtManage targetUserExtWithUserId:self.userDetailsModel.userId];
    userExtManage.friend_tagName = tagName;
    NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo: self.userDetailsModel.userId];
    user.ext = [userExtManage mj_JSONString];
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
    @weakify(self)
    [[[NIMSDK sharedSDK] userManager] updateUser:user completion:^(NSError * _Nullable error) {
        @strongify(self)
        if (!error) {
            [hud hideWithText:@"保存成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                //TODO: 需要更新上层 Model,刷新
            }];
        } else {
            //TODO:失败文案
            [hud hideWithText:error.domain];
        }
    }];
}

- (void)clickAdditionTag:(UIButton* )sender {
    
    YZHAddBookSetTagAlertView* alertView = [YZHAddBookSetTagAlertView yzh_viewWithFrame:CGRectMake(37, 186, 300, 191)];
    self.alertView = alertView;
    // TODO: 待重新封装.
    [alertView yzh_showOnWindowAnimations:^{
    }];
    @weakify(self) //分类个数限制
    alertView.YZHButtonExecuteBlock = ^(UITextField * _Nonnull customTagTextField) {
        if (self.tagsModel.userTagModel.lastObject.count < 5) {
            //先检测当前是否存在此标签,如果不存在则直接去添加.
            if (![self.tagsModel checkoutContainCustomTagName:customTagTextField.text  type:YZHSetTagModelTypeUser]) {
                @strongify(self)
                [self addCustomTagName:customTagTextField.text];
            } else {
                //TODO:文案需产品确认
                [YZHProgressHUD showText:@"当前分类已包含,请您重新输入" onView:self.tableView];
            }
        } else {
            //TODO:文案需产品确认
            [YZHProgressHUD showText:@"当前分类已满,请您删除无用分类" onView:self.tableView];
        }
    };
}

- (void)addCustomTagName:(NSString *)tagName {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [self.tagsModel addUserCustomTag:tagName type:YZHSetTagModelTypeUser WithsuccessCompletion:^{
        @strongify(self)
        //TODO:文案需产品确认
        [self refreshTags];
        [hud hideWithText:@"分类添加成功"];
        [self.tableView reloadData];
        [self.alertView yzh_hideFromWindowAnimations:^{
            
        }];
    } failureCompletion:^(NSError *error) {
        //TODO:文案需产品确认
        [hud hideWithText:error.domain];
    }];
}

- (void)removeCustomTagName:(NSInteger)tagIndex {
    
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
    @weakify(self)
    [self.tagsModel removeUserCustomTagIndex:tagIndex type:YZHSetTagModelTypeUser WithsuccessCompletion:^{
        @strongify(self)
        //TODO:文案需产品确认
        [self refreshTags];
        [hud hideWithText:@"分类删除成功"];
        [self.alertView yzh_hideFromWindowAnimations:^{
            
        }];
    } failureCompletion:^(NSError *error) {
        //TODO:文案需产品确认
        [hud hideWithText:error.domain];
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)refreshTags {
    
    [self.tagsModel updateTargetUserTag];
    [self.tableView reloadData];
}

#pragma mark - 7.GET & SET

- (UIImageView *)selectedImageView {
    
    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_information_setName_selected"]];
        _selectedImageView.frame = CGRectMake(YZHView_Width - 18 - _selectedImageView.width, 18, _selectedImageView.width, _selectedImageView.height);
    }

    return _selectedImageView;
}

@end
