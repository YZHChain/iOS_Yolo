//
//  YZHSharedContactVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSharedContactVC.h"

#import "YZHGroupedContacts.h"
#import "YZHSharedContactCell.h"
#import "YZHContactMemberModel.h"
#import "UITableView+SCIndexView.h"
#import "YZHAddBookSectionView.h"
#import "YZHAlertManage.h"
#import "YZHUserModelManage.h"
#import "YZHTeamModel.h"
#import "YZHProgressHUD.h"
#import "YZHChatContentUtil.h"
#import "YZHUserLoginManage.h"

static NSString* kYZHSharedCellIdentifier = @"YZHSharedContactCell";
static NSString* const kYZHAddBookSectionViewIdentifier = @"addBookSectionViewIdentifier";
@interface YZHSharedContactVC ()<UITableViewDelegate, UITableViewDataSource, SCTableViewSectionIndexDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHGroupedContacts* contacts;
@property (nonatomic, strong) NSArray<NIMTeam*>* teamDataSource;
@property (nonatomic, strong) SCIndexViewConfiguration* indexViewConfiguration;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) NSIndexPath* lastSelectedIndexPath;
@property (nonatomic, strong) NSMutableArray* selectedFirendIndexPath;

@end

@implementation YZHSharedContactVC

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

    if (self.sharedType == YZHSharedContactTypePersonageCard) {
        self.navigationItem.title = @"选择朋友";
    } else if (self.sharedType == YZHSharedContactTypeTeamCard) {
        self.navigationItem.title = @"选择社群";
    } else {
        self.navigationItem.title = @"添加好友进群";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchCancel:)];
    if (self.isForward) {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchConfirmForward:)];
    } else {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchConfirm:)];
    }

}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHSharedContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kYZHSharedCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.selectedIndexPath = nil;
    self.lastSelectedIndexPath = nil;
    
    if (self.sharedType == YZHSharedContactTypePersonageCard) {
        self.contacts = [[YZHGroupedContacts alloc] init];
        //设置右边索引;
        self.tableView.sc_indexViewConfiguration = self.indexViewConfiguration;
        self.tableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
    } else if (self.sharedType == YZHSharedContactTypeTeamCard) {
        self.teamDataSource = [[YZHTeamModel alloc] init].allTeamModel;
    } else {
        self.contacts = [[YZHGroupedContacts alloc] init];
        //设置右边索引;
        self.tableView.sc_indexViewConfiguration = self.indexViewConfiguration;
        self.tableView.sc_indexViewDataSource = self.contacts.sortedGroupTitles;
    }

    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.sharedType == YZHSharedContactTypePersonageCard || self.sharedType == YZHSharedContactTypeTeamAddFriend) {
        
        return self.contacts.groupTitleCount;
    } else if (self.sharedType == YZHSharedContactTypeTeamCard) {
        
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.sharedType == YZHSharedContactTypePersonageCard  || self.sharedType == YZHSharedContactTypeTeamAddFriend) {
        
        return [self.contacts memberCountOfGroup:section];
    } else if (self.sharedType == YZHSharedContactTypeTeamCard) {
        
        return self.teamDataSource.count;
    } else {
        return 0;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHSharedContactCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHSharedCellIdentifier forIndexPath:indexPath];
    if (self.sharedType == YZHSharedContactTypePersonageCard || self.sharedType == YZHSharedContactTypeTeamAddFriend) {
        
        YZHContactMemberModel* memberModel = (YZHContactMemberModel *)[_contacts sharedMemberOfIndex:indexPath];
        [cell refreshUser:memberModel];
    } else if (self.sharedType == YZHSharedContactTypeTeamCard) {
        
        NIMTeam* team = self.teamDataSource[indexPath.row];
        [cell refreshTeam:team];
    }
    if (self.sharedType == YZHSharedContactTypePersonageCard || self.sharedType == YZHSharedContactTypeTeamCard) {
        if ([self.selectedIndexPath isEqual: indexPath]) {
            [cell addSubview:cell.selectedImageView];
        } else {
            [cell.selectedImageView removeFromSuperview];
        }
    } else {
        if ([self.selectedFirendIndexPath containsObject:indexPath]) {
            [cell addSubview:cell.selectedImageView];
        } else {
            [cell.selectedImageView removeFromSuperview];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return kYZHCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.sharedType == YZHSharedContactTypePersonageCard || self.sharedType == YZHSharedContactTypeTeamAddFriend) {
        
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YZHAddBookSectionView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHAddBookSectionViewIdentifier];
    if (self.sharedType == YZHSharedContactTypePersonageCard) {
        view.titleLabel.text = self.contacts.sortedGroupTitles[section];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.sharedType == YZHSharedContactTypePersonageCard || self.sharedType == YZHSharedContactTypeTeamCard) {
        self.selectedIndexPath = indexPath;
        [tableView reloadData];
    } else {
        if ([self.selectedFirendIndexPath containsObject:indexPath]) {
            [self.selectedFirendIndexPath removeObject:indexPath];
            
        } else {
            [self.selectedFirendIndexPath addObject:indexPath];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - SCTableViewSectionIndexDelegate
// 重写这两个代理方法,否则默认算法 indexView 与实际不一致.
- (void)tableView:(UITableView *)tableView didSelectIndexViewAtSection:(NSUInteger)section {
    
//    NSIndexPath* indexPath;
//    if (section > 0) {
//        indexPath = [NSIndexPath indexPathForRow:0 inSection:section + 1];
//    } else {
//        indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
//    }
    CGRect frame = [tableView rectForSection:section];
    [tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:NO];
    
}

- (NSUInteger)sectionOfTableViewDidScroll:(UITableView *)tableView {
    
    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    NSInteger indexSection = indexPath.section;
//    if (indexSection > 0) {
//        indexSection = indexPath.section - 1;
//    } else {
//        indexPath = 0;
//    }
    //TODO
    return indexSection;
}


#pragma mark - 5.Event Response

- (void)onTouchCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//TODO: 有时间在封装.
- (void)onTouchConfirmForward:(UIBarButtonItem *)sender {
    
    if (self.forwardType == YZHForwardContactTypePersonageCard) {
        if (!self.selectedIndexPath) {
            [YZHAlertManage showAlertMessage:@"请选择一位联系人"];
            return;
        }
        YZHContactMemberModel* memberModel = (YZHContactMemberModel *)[_contacts sharedMemberOfIndex:self.selectedIndexPath];
        
        NSString* userId = memberModel.info.infoId;
        self.forwardMessageToUserBlock ? self.forwardMessageToUserBlock(userId) : NULL;
    } else {
        if (!self.selectedIndexPath) {
            [YZHAlertManage showAlertMessage:@"请选择一个群名片"];
            return;
        }
        NIMTeam* teamCard = self.teamDataSource[self.selectedIndexPath.row];
        self.forwardMessageToTeamBlock ? self.forwardMessageToTeamBlock(teamCard.teamId) : NULL;
    }
}

- (void)onTouchConfirm:(UIBarButtonItem *)sender {
    
    if (self.sharedType == YZHSharedContactTypePersonageCard) {
        if (!self.selectedIndexPath) {
            [YZHAlertManage showAlertMessage:@"请选择一位联系人名片"];
            return;
        }
        YZHContactMemberModel* memberModel = (YZHContactMemberModel *)[_contacts sharedMemberOfIndex:self.selectedIndexPath];
        YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage targetUserInfoExtWithUserId:memberModel.info.infoId];
        YZHUserCardAttachment* userCardAttachment = [[YZHUserCardAttachment alloc] init];
        userCardAttachment.userName = memberModel.info.showName;
        userCardAttachment.yoloID = userInfoExt.userYolo.yoloID;
        userCardAttachment.account = memberModel.info.infoId;
        [userCardAttachment encodeAttachment];
        self.sharedPersonageCardBlock ? self.sharedPersonageCardBlock(userCardAttachment) : NULL;
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else if (self.sharedType == YZHSharedContactTypeTeamCard) {
        if (!self.selectedIndexPath) {
            [YZHAlertManage showAlertMessage:@"请选择一个群名片"];
            return;
        }
            NIMTeam* teamCard = self.teamDataSource[self.selectedIndexPath.row];
            YZHTeamCardAttachment* teamCardAttachment = [[YZHTeamCardAttachment alloc] init];
            teamCardAttachment.groupName = teamCard.teamName;
            teamCardAttachment.groupID = teamCard.teamId;
            teamCardAttachment.groupSynopsis = teamCard.intro;
            teamCardAttachment.groupUrl = [YZHChatContentUtil createTeamURLWithTeamId:teamCard.teamId];
            teamCardAttachment.avatarUrl = teamCard.avatarUrl ? teamCard.avatarUrl : @"team_cell_photoImage_default";
            self.sharedTeamCardBlock ? self.sharedTeamCardBlock(teamCardAttachment) : NULL;

            [self dismissViewControllerAnimated:YES completion:^{

            }];
    } else if (self.sharedType == YZHSharedContactTypeTeamAddFriend) {
        if (!self.selectedFirendIndexPath.count) {
            [YZHAlertManage showAlertMessage:@"请选择一位好友"];
            return;
        }
        NSMutableArray* userIdArray = [[NSMutableArray alloc] init];
        @weakify(self)
        [self.selectedFirendIndexPath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            YZHContactMemberModel* memberModel = (YZHContactMemberModel *)[self.contacts sharedMemberOfIndex:obj];
            NSString* yoloId = memberModel.info.infoId;
            if (YZHIsString(yoloId)) {
                [userIdArray addObject:yoloId];
            }
        }];
        //邀请好友入群附言.
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NSString* userName = [[[NIMSDK sharedSDK] userManager] userInfo: userId].userInfo.nickName;
        YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:YZHAppWindow text:nil];
        [[[NIMSDK sharedSDK] teamManager] addUsers:userIdArray toTeam:self.teamId postscript:[NSString stringWithFormat:@"%@ 邀请你加入群聊", userName] completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            @strongify(self)
            if (!error) {
                [hud hideWithText:@"成功邀请好友入群" completion:^{
                    @strongify(self)
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.addFriendSuccessful ? self.addFriendSuccessful() : NULL;
                    }];
                }];
            } else {
                [hud hideWithText:@"邀请失败"];
                NSLog(@"error:%@", error);
            }
        }];
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

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

- (NSMutableArray *)selectedFirendIndexPath {
    
    if (!_selectedFirendIndexPath) {
        _selectedFirendIndexPath = [[NSMutableArray alloc] init];
    }
    return _selectedFirendIndexPath;
}
@end
