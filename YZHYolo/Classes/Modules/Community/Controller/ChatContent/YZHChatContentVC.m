//
//  YZHChatContentVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHChatContentVC.h"

#import "YZHChatContentHeaderView.h"
#import "YZHChatTextContentCell.h"
#import "YZHCustomAttachmentDecoder.h"

typedef enum : NSUInteger {
    YZHChatContentTypeImage = 1,
    YZHChatContentTypeCard,
    YZHChatContentTypeUrl,
} YZHChatContentType;

static NSString* kUrlCellIdentifie = @"UrlCellIdentifie";

@interface YZHChatContentVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YZHChatContentHeaderView* headerView;
@property (nonatomic, strong) UITableView* imageTableView;
@property (nonatomic, strong) UITableView* cardTableView;
@property (nonatomic, strong) UITableView* urlTableView;
@property (nonatomic, strong) NSArray<UITableView *>* tableViewArray;
@property (nonatomic, strong) NSArray<NIMMessage*>* urlMessages;
@property (nonatomic, strong) NSArray<NIMMessage*>* cardMessages;
@property (nonatomic, strong) NSArray<NIMMessage*>* imageViewMessages;

@end

@implementation YZHChatContentVC

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
    self.navigationItem.title = @"聊天内容";
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHChatContentHeaderView" owner:nil options:nil].lastObject;
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.view addSubview: self.imageTableView];
    [self.imageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom).mas_equalTo(0);
    }];
    [self.view addSubview: self.cardTableView];
    [self.cardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom).mas_equalTo(0);
    }];
    [self.view addSubview: self.urlTableView];
    [self.urlTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom).mas_equalTo(0);
    }];
    
    self.tableViewArray = @[_imageTableView, _cardTableView, _urlTableView];
    @weakify(self)
    self.headerView.switchTypeBlock = ^(kYZHChatContentType currentType) {
       @strongify(self)
        [self.tableViewArray enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (currentType == idx) {
                self.tableViewArray[idx].hidden = NO;
            } else {
                obj.hidden = YES;
            }
        }];
    };
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {

    
    NIMSession* session = [NIMSession session:self.targetId type:NIMSessionTypeTeam];
    
    NIMMessageSearchOption* imageOption = [[NIMMessageSearchOption alloc] init];
    imageOption.limit = 0;
    imageOption.order = NIMMessageSearchOrderDesc;
    imageOption.messageTypes = @[@(NIMMessageTypeImage)];
    
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:session option:imageOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        self.imageViewMessages = messages;
        [self.imageTableView reloadData];
    }];
    
    NIMMessageSearchOption* cardOption = [[NIMMessageSearchOption alloc] init];
    cardOption.limit = 0;
    cardOption.order = NIMMessageSearchOrderDesc;
    cardOption.messageTypes = @[@(NIMMessageTypeCustom)];
    
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:session option:cardOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        
        NSMutableArray<NIMMessage*> *mutableMessages = messages.mutableCopy;
        NSMutableArray* mutableCardMessages = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < mutableMessages.count; i++) {
            NIMCustomObject *customObject = (NIMCustomObject*)mutableMessages[i].messageObject;
            if ([customObject.attachment isKindOfClass:NSClassFromString(@"YZHUserCardAttachment")] || [customObject.attachment isKindOfClass:NSClassFromString(@"YZHTeamCardAttachment")]) {
                [mutableCardMessages addObject:mutableCardMessages[i]];
            }
        }
        self.cardMessages = mutableCardMessages.copy;
        [self.cardTableView reloadData];
    }];
    
    NIMMessageSearchOption* option = [[NIMMessageSearchOption alloc] init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        self.urlMessages = messages;
        [self.urlTableView reloadData];
    }];
    
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    if ([tableView isEqual:self.urlTableView]) {
//        return self.urlMessages.count
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (tableView.tag) {
        case YZHChatContentTypeUrl:
            return self.urlMessages.count;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case YZHChatContentTypeUrl:
            return [self reloadUrlTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
        default:
            return [self reloadTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
    }

}

- (UITableViewCell *)reloadTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}

- (UITableViewCell *)reloadUrlTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHChatTextContentCell* cell =  [tableView dequeueReusableCellWithIdentifier:kUrlCellIdentifie forIndexPath:indexPath];
    
    NIMMessage* message = self.urlMessages[indexPath.row];
    NIMMessageModel* messageModel = [[NIMMessageModel alloc] initWithMessage:message];
    
    [cell refreshData:messageModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (tableView.tag) {
        case YZHChatContentTypeUrl:
            return [self urlTableView:tableView heightForRowAtIndexPath:indexPath];
            break;
            
        default:
            return 50;
            break;
    }
}

- (CGFloat)urlTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    NIMMessage* message = self.urlMessages[indexPath.row];
    NIMMessageModel* messageModel = [[NIMMessageModel alloc] initWithMessage:message];
    //计算 Cell 高度.先计算ContentView 高度, 然后在加上Cell 内边距和 ContentView 内边距
    CGSize size = [messageModel contentSize:self.urlTableView.width];
    UIEdgeInsets contentViewInsets = messageModel.contentViewInsets;
    UIEdgeInsets bubbleViewInsets  = messageModel.bubbleViewInsets;
    cellHeight = size.height + contentViewInsets.top + contentViewInsets.bottom + bubbleViewInsets.top + bubbleViewInsets.bottom;
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView* headerView = [[UITableViewHeaderFooterView alloc] init];
    
    headerView.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor yzh_backgroundThemeGray];
        view;
    });
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    titleLabel.textColor = [UIColor yzh_sessionCellGray];
    titleLabel.text = @"最近一个月";
    
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    
    return headerView;
}


#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UITableView *)imageTableView{
    
    if (_imageTableView == nil) {
        _imageTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _imageTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
//        [_imageTableView registerNib:[UINib nibWithNibName:@"YZHMyCenterCell" bundle:nil] forCellReuseIdentifier: KCellIdentifier];
        _imageTableView.delegate = self;
        _imageTableView.dataSource = self;
//        _imageTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _imageTableView.tag = YZHChatContentTypeImage;
        _imageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _imageTableView;
}

- (UITableView *)cardTableView{
    
    if (_cardTableView == nil) {
        _cardTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _cardTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        //        [_imageTableView registerNib:[UINib nibWithNibName:@"YZHMyCenterCell" bundle:nil] forCellReuseIdentifier: KCellIdentifier];
        _cardTableView.delegate = self;
        _cardTableView.dataSource = self;
        _cardTableView.tag = YZHChatContentTypeCard;
        _cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _cardTableView;
}

- (UITableView *)urlTableView{
    
    if (_urlTableView == nil) {
        _urlTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _urlTableView.backgroundColor = [UIColor whiteColor];
        
        [_urlTableView registerClass:[YZHChatTextContentCell class] forCellReuseIdentifier:kUrlCellIdentifie];
        _urlTableView.delegate = self;
        _urlTableView.dataSource = self;
        _urlTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _urlTableView.tag = YZHChatContentTypeUrl;
    }
    return _urlTableView;
}


@end
