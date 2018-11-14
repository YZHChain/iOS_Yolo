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

- (void)dealloc {
    
    [[[NIMSDK sharedSDK] userManager] removeDelegate:self];
}

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
    
    [[[NIMSDK sharedSDK] userManager] addDelegate:self];
//    [self.view addSubview:self.withoutDefaultView];
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.addFriendManage = [[YZHAddFirendRecordManage alloc] init];
}

- (void)refresh {
    
    [self setupData];
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
    
    //先判断是我发起还是对方发起.
    if (model.isMySend) {
        //因为没有拒绝的操作,所以当用户收到我发送出去的消息时,都是属于收到发出的请求得到回复的情况.
        //判断当前用户与对方是否为好友,是好友则
//        if (model.isMyFriend) { 直接在模型判断
           //直接跳转用户详情页,带发消息按钮 非好友时 //直接跳转用户详情页,带发送按钮和添加好友
            YZHAddBookDetailsModel* detailsModel = [[YZHAddBookDetailsModel alloc] initDetailsModelWithUserId:model.targetUserId];
            [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{@"userId": model.targetUserId, @"userDetailsModel": detailsModel}];
//        }
    } else {
        //不判断是否做过处理, 有限判断是否为好友. 如果判断是否处理状态,则会出现前面收到多条未处理消息, 然后处理了最后一条,但是前面所有未处理同一个人消息与这个消息会保持不一致. 可以考虑去重
//        if (model.isMyFriend) {
        
            //跳转至用户申请详情, 按钮改为发送消息.
//            [YZHRouter openURL:kYZHRouterAddressBookAddFriendShow info:@{@"userId": model.targetUserId, @"addMessage": model.addFriendNotification.postscript.length ? model.addFriendNotification.postscript : @"", @"isMySend": @(model.isMySend),
//                                                                         @"addFriendNotification":model.addFriendNotification
//                                                                         }];
//        } else {
            BOOL messageTimeout = NO;
            //调准至用户详情, 按钮为添加好友
            //跳转至用户申请详情, 按钮为发送消息
            [YZHRouter openURL:kYZHRouterAddressBookAddFriendShow info:@{@"userId": model.targetUserId, @"addMessage": model.addFriendNotification.postscript.length ? model.addFriendNotification.postscript : @"", @"isMySend": @(model.isMySend),
                                                                         @"addFriendNotification":model.addFriendNotification,
                                                                         @"messageTimeout": @(messageTimeout)
                                                                         }];
//        }
    }
}

#pragma mark - 5.Event Response

- (void)addFriend:(UIBarButtonItem* )barButtonItem {
    
    [YZHRouter openURL:kYZHRouterAddressBookAddFirend];
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
    [self.tableView reloadData];
}

#pragma mark - 7.GET & SET

-(YZHCommanDefaultView *)withoutDefaultView {
    
    if (!_withoutDefaultView) {
        _withoutDefaultView = [YZHCommanDefaultView commanDefaultViewWithImageName:@"addBook_addFirendRecord_defualt" TitleString:@"暂无好友申请" subTitleString:@"（暂时无好友添加您，不如点击右上角按钮去添加好友吧)"];
    }
    return _withoutDefaultView;
}

@end
