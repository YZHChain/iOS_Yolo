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
#import "YZHProgressHUD.h"

@interface YZHAddBookSetNoteVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHAddBookSetNoteCell* noteCell;
@property (nonatomic, strong) YZHAddBookSetNoteCell* phoneCell;
@property (nonatomic, strong) YZHAddBookSetNoteCell* tagCell;

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
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
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
    
    YZHAddBookSetNoteCell* cell = [YZHAddBookSetNoteCell tempTableViewCellWith:tableView indexPath:indexPath];
    YZHAddBookDetailModel* viewModel;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            viewModel = self.noteModel.firstObject;
            self.noteCell = cell;
        } else {
            viewModel = self.noteModel.lastObject;
            self.phoneCell = cell;
        }
    } else {
        viewModel = self.classTagModel;
        self.tagCell = cell;
    }
    
    cell.model = viewModel;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.tableView endEditing:YES];
}

#pragma mark - 5.Event Response

- (void)clickLeftBarItem {
    
    // 可以检测当前编辑是否改变,改变则提示.是否需要保存编辑
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickRightBarItem {
    
    if ([self checkoutEditChange]) {
        YZHTargetUserExtManage* userExtManage = self.userDetailsModel.targetUserExt;
        userExtManage.friend_phone = self.phoneCell.subtitleTextField.text;
        userExtManage.friend_tagName = self.tagCell.subtitleLabel.text;
        NSString* userExtString = [userExtManage mj_JSONString];
        if (YZHIsString(userExtString)) {
            self.userDetailsModel.user.ext = userExtString;
        }
        self.userDetailsModel.user.alias = self.noteCell.subtitleTextField.text;
        
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:self.tableView text:nil];
        [[[NIMSDK sharedSDK] userManager] updateUser:self.userDetailsModel.user completion:^(NSError * _Nullable error) {
            if (!error) {
                self.userDetailsModel.userNotePhoneArray.firstObject.subtitle = self.phoneCell.subtitleTextField.text;
                if (self.userDetailsModel.userNotePhoneArray.count == 1) {
                    if (YZHIsString(self.tagCell.subtitleLabel.text)) {

                        [self.userDetailsModel.userNotePhoneArray addObject:self.
                         noteModel.lastObject];
                    } else {

                    }
                } else {
                    if (YZHIsString(self.tagCell.subtitleLabel.text)) {
                        self.userDetailsModel.userNotePhoneArray.lastObject.subtitle = self.tagCell.subtitleLabel.text;
                    } else {
                        [self.userDetailsModel.userNotePhoneArray removeLastObject];
                    }
                }
//                [self.detailsTableView reloadData];
                [self dismissViewControllerAnimated:YES completion:^{

                }];
                [hud hideWithText:nil];
            } else {
                //TODO:云信错误.
                [hud hideWithText:error.domain];
            }
        }];
    }
    
}

- (BOOL)checkoutEditChange {
    
    // 暂时不对标签做检测
    return YES;
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (NSMutableArray<YZHAddBookDetailModel *> *)noteModel {
    
    if (!_noteModel) {
        _noteModel = self.userDetailsModel.viewModel[self.userDetailsModel.viewModel.count - 2];
        //如果未设置过手机号,则临时添加一个Model 为了展示.
        if (_noteModel.count == 1) {
            YZHAddBookDetailModel* phoneModel = [[YZHAddBookDetailModel alloc] init];
            phoneModel.title = @"手机号码";
            phoneModel.cellClass = @"YZHAddBookSettingCell";
            phoneModel.cellHeight = 55;
            [_noteModel addObject:phoneModel];
        }
    }
    return _noteModel;
}

-  (YZHAddBookDetailModel *)classTagModel {
    
    if (!_classTagModel) {
       _classTagModel = self.userDetailsModel.viewModel.lastObject.firstObject;
    }
    return _classTagModel;
}
@end

