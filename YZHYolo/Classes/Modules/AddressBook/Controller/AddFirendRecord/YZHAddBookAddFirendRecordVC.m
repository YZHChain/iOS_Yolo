//
//  YZHAddBookAddFirendRecordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/5.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendRecordVC.h"

#import "YZHCommanDefaultView.h"
#import "YZHPublic.h"
#import "YZHAddFirendRecordSectionHeader.h"
#import "YZHAddBookAddFirendRecordCell.h"
#import "YZHAddFirendRecordManage.h"
#import "YZHAddBookDetailsModel.h"
#import "YZHAddBookAddFirendShowModel.h"

@interface YZHAddBookAddFirendRecordVC ()<UITableViewDelegate, UITableViewDataSource, NIMUserManagerDelegate,NIMSystemNotificationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZHCommanDefaultView* withoutDefaultView;
@property (nonatomic, strong) YZHAddFirendRecordManage* addFriendManage;

@end

@implementation YZHAddBookAddFirendRecordVC

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
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
//    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
}

- (void)dealloc {
    
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
//    [[NIMSDK sharedSDK].subscribeManager removeDelegate:self];
}
//
//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
//    [self refresh];
//}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"好友申请";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriend:)];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    [self.tableView registerNib:[UINib nibWithNibName:@"YZHAddFirendRecordSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHCommonHeaderIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self refresh];
}

#pragma mark - 3.Request Data

- (void)setupData {
    //配置消息数据.
    self.addFriendManage = [[YZHAddFirendRecordManage alloc] init];
}

- (void)refresh {
    
    [self setupData];
    [self refreshView];
}

- (void)refreshView {
    
    if (self.addFriendManage.addFirendListModel.firstObject.count) {
        [self.withoutDefaultView removeFromSuperview];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    } else {
        [self.view addSubview:self.withoutDefaultView];
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.addFriendManage.timerArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addFriendManage.addFirendListModel[section].count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHAddFirendRecordCellType cellType = YZHAddFirendRecordCellTypeReview;
    YZHAddFriendRecordModel* model = self.addFriendManage.addFirendListModel[indexPath.section][indexPath.row];
    id object = model.addFriendNotification.attachment;
    if ([object isKindOfClass:[NIMUserAddAttachment class]]) {
        NIMUserOperation operation = [(NIMUserAddAttachment *)object operationType];
        //当消息属于请求验证的状态,并且当前消息属于对方发送给我的,并且处理状态不为0时, 才是可以操作的。
        if (operation == NIMUserOperationRequest && !model.isMySend && !model.addFriendNotification.handleStatus) {
            cellType = YZHAddFirendRecordCellTypeDating;
        } else {
            cellType = YZHAddFirendRecordCellTypeReview;
        }
    }
    YZHAddBookAddFirendRecordCell* cell = [YZHAddBookAddFirendRecordCell tempTableViewCellWithTableView:tableView indexPath:indexPath cellType:cellType];
    [cell update:model];
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self)
    UITableViewRowAction* removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        [self.addFriendManage removeAddFirendMessage:indexPath];
        if (!self.addFriendManage.addFirendListModel.firstObject.count) {
            [self refreshView];
        }
        [self.tableView reloadData];
    }];
    
    return @[removeAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kYZHCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kYZHSectionHeight;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString* dateText = self.addFriendManage.timerArray[section];
    YZHAddFirendRecordSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHCommonHeaderIdentifier];
    sectionHeader.dateLabel.text = dateText;
    
    return sectionHeader;
}
// 添加分段尾,为了隐藏分区最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZHAddFriendRecordModel* model = self.addFriendManage.addFirendListModel[indexPath.section][indexPath.row];
    //跳转逻辑.
    //先判断是我发起还是对方发起.
    if (model.isMySend) {
        [self isMysendRequstReviewModel:model];
    } else {
        // 未处理过的消息
        if (model.addFriendNotification.handleStatus == 0) {
            NIMUserAddAttachment* attachment = model.addFriendNotification.attachment;
            if (model.isMyFriend) {
                //是好友,非自己发出请求,对方直接添加我为好友无需时。
                [self notMysendRequstIsFriendNotVerifyReviewModel:model];
            } else {
                //非好友,非自己发出请求,对方需要添加我为好友需要验证时,或者不需要验证的方式
                if (attachment.operationType == NIMUserOperationAdd) {
                    [self notMySendRequstNotFirendNotVerifyReviewModel:model];
                } else {
                     [self notMySendRequstNotFirendNeedVerifyReviewModel:model];
                }
               
            }
        } else {
            //非自己发出,已经处理过的,属于我的好友.跳转至用户申请详情
            if (model.isMyFriend) {
                [self notMySendRequstIsFirendHasHandleStatusReviewModel:model];
            } else {
                [self notMySendRequstNotFirendHasHandleStatusReviewModel:model];
            }
        }
    }
    
}

#pragma mark - 5.Event Response

- (void)addFriend:(UIBarButtonItem* )barButtonItem {
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirend];
}

- (void)isMysendRequstReviewModel:(YZHAddFriendRecordModel* )model {
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": model.targetUserId}];
}

- (void)notMysendRequstNotFriendNotVerifyReviewModel:(YZHAddFriendRecordModel* )model {
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": model.targetUserId}];
}

- (void)notMysendRequstIsFriendNotVerifyReviewModel:(YZHAddFriendRecordModel* )model {
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": model.targetUserId}];
}

- (void)notMySendRequstNotFirendNotVerifyReviewModel:(YZHAddFriendRecordModel* )model {
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": model.targetUserId}];
}

- (void)notMySendRequstNotFirendNeedVerifyReviewModel:(YZHAddFriendRecordModel *)model {
    BOOL messageTimeout = NO;
    NSString* requstMessage;
    if (YZHIsString(model.addFriendNotification.postscript)) {
        requstMessage = model.addFriendNotification.postscript;
    } else {
        //TODO:默认展示？
        requstMessage = @"";
    }
    YZHAddBookAddFirendShowModel* userDetailsModel = [[YZHAddBookAddFirendShowModel alloc] initDetailsModelWithUserId:model.targetUserId addMessage:requstMessage
                                                                                                             isMySend:model.isMySend];
    [YZHRouter openURL:kYZHRouterAddressBookAddFriendShow info:@{
                                                                 @"addFriendNotification":model.addFriendNotification,
                                                                 @"userDetailsModel": userDetailsModel,
                                                                 @"messageTimeout": @(messageTimeout),
                                                                 @"userId": model.targetUserId,
                                                                 @"addMessage":requstMessage
                                                                 }];
}

- (void)notMySendRequstIsFirendHasHandleStatusReviewModel:(YZHAddFriendRecordModel *)model {
    
    [self notMySendRequstNotFirendNeedVerifyReviewModel:model];
//    //TODO:计算是否超时.也可以跳转到下个页面之后在计算.
//    BOOL messageTimeout = NO;
//    NSString* requstMessage;
//    if (YZHIsString(requstMessage)) {
//        requstMessage = model.addFriendNotification.postscript;
//    } else {
//        //TODO:默认展示？
//        requstMessage = @"";
//    }
//    YZHAddBookAddFirendShowModel* userDetailsModel = [[YZHAddBookAddFirendShowModel alloc] initDetailsModelWithUserId:model.targetUserId addMessage:requstMessage
//                                                                                                             isMySend:model.isMySend];
//    [YZHRouter openURL:kYZHRouterAddressBookAddFriendShow info:@{
//                                                                 @"addFriendNotification":model.addFriendNotification,
//                                                                 @"userDetailsModel": userDetailsModel,
//                                                                 @"messageTimeout": @(messageTimeout),
//                                                                 @"userId": model.targetUserId,
//                                                                 @"addMessage":requstMessage
//                                                                 }];
}

- (void)notMySendRequstNotFirendHasHandleStatusReviewModel:(YZHAddFriendRecordModel *)model {
    
    [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": model.targetUserId}];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - NIMSDK Delegate

- (void)onUserInfoChanged:(NIMUser *)user {
    
    [self refresh];
}

- (void)onFriendChanged:(NIMUser *)user {
    
    [self refresh];
}

- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification
{
    YZHAddFriendRecordModel* model = [[YZHAddFriendRecordModel alloc] init];
    model.addFriendNotification = notification;[self.addFriendManage.addFirendListModel.firstObject addObject:model];
    [self refresh];
}

#pragma mark - 7.GET & SET

-(YZHCommanDefaultView *)withoutDefaultView {
    
    if (!_withoutDefaultView) {
        _withoutDefaultView = [YZHCommanDefaultView commanDefaultViewWithImageName:@"addBook_addFirendRecord_defualt" TitleString:@"暂无好友申请" subTitleString:@"（暂时无好友添加您，不如点击右上角按钮去添加好友吧)"];
    }
    return _withoutDefaultView;
}

@end
