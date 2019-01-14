//
//  YZHTransferTeamVC.m
//  YZHYolo
//
//  Created by Jersey on 2019/1/14.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHTransferTeamVC.h"

#import "YZHTeamMemberModel.h"
#import "YZHAlertManage.h"
#import "YZHProgressHUD.h"
@interface YZHTransferTeamVC ()

@property (nonatomic, strong) NSIndexPath* selectedPath;
@property (nonatomic, strong) UIImageView* selectedImageView;

@end

@implementation YZHTransferTeamVC

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
    
    self.navigationItem.title = @"选择新群主";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completion)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview: self.tableView];
    
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHTeamMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
    YZHContactMemberModel* member = self.viewModel.memberArray[indexPath.row];
    
    cell.teamId = self.viewModel.teamId;
    [cell refresh:member];
    if ([self.selectedPath isEqual:indexPath]) {
        [cell.contentView addSubview: self.selectedImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.selectedPath) {
        self.selectedPath = indexPath;
    } else {
        if ([self.selectedPath isEqual:indexPath]) {
            self.selectedPath = nil;
            [self.selectedImageView removeFromSuperview];
        } else {
            self.selectedPath = indexPath;
        }
    }
    
    [tableView reloadData];
}

#pragma mark - 5.Event Response

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completion {
    
    if (self.selectedPath) {
        
        YZHContactMemberModel* member = self.viewModel.memberArray[self.selectedPath.row];
        
        @weakify(self)
        [YZHAlertManage showAlertTitle:nil message:@"确认要转让本群么?" actionButtons:@[@"取消", @"确定"] actionHandler:^(UIAlertController *alertController, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                @strongify(self)
                YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
                [[[NIMSDK sharedSDK] teamManager] transferManagerWithTeam:self.teamId newOwnerId:member.info.infoId isLeave:NO completion:^(NSError * _Nullable error) {
                    @strongify(self)
                    if (error) {
                        [hud hideWithText:@"转让失败,请重试"];
                    } else {
                        @strongify(self)
                        [hud hideWithText:@"转让成功" completion:^{
                            
                            [self dismissViewControllerAnimated:YES completion:^{
                                self.transferCompletion ? self.transferCompletion() : NULL;
                            }];
                        }];
                    }
                }];
            }
        }];
    } else {
        [YZHAlertManage showAlertMessage:@"请选择一位群成员"];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)makeData {
    
    @weakify(self)
    [self.config getTeamMemberData:^(YZHTeamMemberModel *teamMemberModel) {
        @strongify(self)
        self.viewModel = teamMemberModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } containsSelf:NO];
}

#pragma mark - 7.GET & SET

- (UIImageView *)selectedImageView {
    
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_information_setName_selected"]];
        _selectedImageView.x = YZHScreen_Width - 36;
        _selectedImageView.y = 25;
        [_selectedImageView sizeToFit];
    }
    return _selectedImageView;
}
@end
