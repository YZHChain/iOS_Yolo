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
#import "YZHCardContentCell.h"
#import "YZHCustomAttachmentDecoder.h"
#import "YZHImageContentCell.h"
#import "YZHImageReusableView.h"
#import "NTESGalleryViewController.h"
#import "NSString+YZHTool.h"
#import "VBFPopFlatButton.h"
#import "DLRadioButton.h"
#import "YZHAddFirendRecordSectionHeader.h"
#import "YZHChatContentManage.h"

typedef enum : NSUInteger {
    YZHChatContentTypeImage = 1,
    YZHChatContentTypeCard,
    YZHChatContentTypeUrl,
} YZHChatContentType;

static NSString* kImageCellIdentifie = @"imageCellIdentifie";
static NSString* kImageHeaderViewIdentifie = @"imageHeaderViewIdentifie";
static NSString* kCardCellIdentifie = @"cardCellIdentifie";
static NSString* kUrlCellIdentifie = @"UrlCellIdentifie";

@interface YZHChatContentVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NIMMessageCellDelegate>

@property (nonatomic, strong) YZHChatContentHeaderView* headerView;
@property (nonatomic, strong) UITableView* imageTableView;
@property (nonatomic, strong) UICollectionView* imageCollectionView;
@property (nonatomic, strong) UITableView* cardTableView;
@property (nonatomic, strong) UITableView* urlTableView;
@property (nonatomic, strong) NSArray<UITableView *>* tableViewArray;
@property (nonatomic, strong) NSArray<NIMMessage*>* urlMessages;
@property (nonatomic, strong) NSArray<NIMMessage*>* cardMessages;
@property (nonatomic, strong) NSArray<NIMMessage*>* imageViewMessages;
@property (nonatomic, strong) NSArray<NIMMessage*>* allTextMessage;
@property (nonatomic, strong) NIMMessage* messageForMenu;
@property (nonatomic, strong) YZHChatContentManage* chatContentManage;

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
    
    DLRadioButton* searchButton = [DLRadioButton buttonWithType:UIButtonTypeCustom];
    searchButton.marginWidth = 0;
    [searchButton setIcon:[UIImage imageNamed:@"addBook_cover_search_default"]];
    [searchButton setIconSelected:[UIImage imageNamed:@"addBook_cover_search_default"]];
    [searchButton setTitle:@"查找" forState:UIControlStateNormal];
    [searchButton setTitle:@"查找" forState:UIControlStateSelected];

    [searchButton sizeToFit];
    [searchButton addTarget:self action:@selector(onTouchSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHChatContentHeaderView" owner:nil options:nil].lastObject;
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.view addSubview: self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _cardTableView.hidden = YES;
    _urlTableView.hidden = YES;
    _imageCollectionView.hidden = NO;
    self.tableViewArray = @[_imageCollectionView, _cardTableView, _urlTableView];
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
    NIMSession* session;
    if (self.isTeam) {
       session = [NIMSession session:self.targetId type:NIMSessionTypeTeam];
    } else {
       session = [NIMSession session:self.targetId type:NIMSessionTypeP2P];
    }
    
    NIMMessageSearchOption* searchOption = [[NIMMessageSearchOption alloc] init];
    searchOption.limit = 0;
    searchOption.order = NIMMessageSearchOrderDesc;
    
    self.chatContentManage = [[YZHChatContentManage alloc] initWithSession:session searchOption:searchOption];
    
    @weakify(self)
    [self.chatContentManage searchImageViewMessagesCompletion:^{
        @strongify(self)
        [self.imageCollectionView reloadData];
    }];
    
    [self.chatContentManage searchUserCardMessagesCompletion:^{
        @strongify(self)
        [self.cardTableView reloadData];
    }];
    
    [self.chatContentManage searchURLMessagesCompletion:^{
        @strongify(self)
        [self.urlTableView reloadData];
    }];
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([tableView isEqual:self.urlTableView]) {
        return self.chatContentManage.urlTimers.count;
    } else {
        return self.chatContentManage.cardTimers.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (tableView.tag) {
//        case YZHChatContentTypeImage:
//            return self.imageViewMessages.count;
//            break;
        case YZHChatContentTypeCard:
            return self.chatContentManage.cardMessages[section].count;
            break;
        case YZHChatContentTypeUrl:
            return self.chatContentManage.urlMessages[section].count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
//        case YZHChatContentTypeImage:
//            return [self reloadImageTableView:tableView cellForRowAtIndexPath:indexPath];
//            break;
        case YZHChatContentTypeCard:
            return [self reloadCardTableView:tableView cellForRowAtIndexPath:indexPath];
            break;
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
    
    NIMMessage* message = self.chatContentManage.urlMessages[indexPath.section][indexPath.row];
    NIMMessageModel* messageModel = [[NIMMessageModel alloc] initWithMessage:message];
    
    [cell refreshData:messageModel];
    
    cell.delegate = self;
    
    return cell;
}

//- (UITableViewCell *)reloadImageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    YZHChatTextContentCell* cell =  [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifie forIndexPath:indexPath];
//
//    NIMMessage* message = self.imageViewMessages[indexPath.row];
//    NIMMessageModel* messageModel = [[NIMMessageModel alloc] initWithMessage:message];
//
//    [cell refreshData:messageModel];
//
//    return cell;
//}

- (UITableViewCell *)reloadCardTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHCardContentCell* cell =  [tableView dequeueReusableCellWithIdentifier:kCardCellIdentifie forIndexPath:indexPath];
    
    NIMMessage* message = self.chatContentManage.cardMessages[indexPath.section][indexPath.row];
    
    [cell refreshData:message];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (tableView.tag) {
//        case YZHChatContentTypeImage:
//            return 50;
//            break;
        case YZHChatContentTypeCard:
            return [self cardTableView:tableView heightForRowAtIndexPath:indexPath];
            break;
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
    NIMMessage* message = self.chatContentManage.urlMessages[indexPath.section][indexPath.row];
    NIMMessageModel* messageModel = [[NIMMessageModel alloc] initWithMessage:message];
    //计算 Cell 高度.先计算ContentView 高度, 然后在加上Cell 内边距和 ContentView 内边距
    CGSize size = [messageModel contentSize:self.urlTableView.width];
    UIEdgeInsets contentViewInsets = messageModel.contentViewInsets;
    UIEdgeInsets bubbleViewInsets  = messageModel.bubbleViewInsets;
    cellHeight = size.height + contentViewInsets.top + contentViewInsets.bottom + bubbleViewInsets.top + bubbleViewInsets.bottom;
    
    return cellHeight;
}

- (CGFloat)cardTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMMessage* message = self.chatContentManage.cardMessages[indexPath.section][indexPath.row];
    NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
    CGFloat cellHeight = 0;
    if ([customObject.attachment isKindOfClass:NSClassFromString(@"YZHUserCardAttachment")]) {
        cellHeight = 120;
    } else {
        cellHeight = 145;
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddFirendRecordSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHCommonHeaderIdentifier];
    NSString* dateText;
    if ([tableView isEqual:self.cardTableView]) {
        dateText = self.chatContentManage.cardTimers[section];
    } else {
        dateText = self.chatContentManage.urlTimers[section];
    }
    sectionHeader.dateLabel.text = dateText;
    
    return sectionHeader;
    
}

#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.chatContentManage.imageViewTimers.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.chatContentManage.imageViewMessages[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YZHImageContentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellIdentifie forIndexPath:indexPath];
    
    NIMMessage* message = self.chatContentManage.imageViewMessages[indexPath.section][indexPath.row];
    NIMMessageModel *model = [[NIMMessageModel alloc] initWithMessage:message];
    [cell refreshData: model];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(collectionView.width, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        YZHImageReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kImageHeaderViewIdentifie forIndexPath:indexPath];
        
        header.backgroundColor = [UIColor yzh_backgroundThemeGray];
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont yzh_commonLightStyleWithFontSize:13];
        titleLabel.textColor = [UIColor yzh_sessionCellGray];
        titleLabel.text = self.chatContentManage.imageViewTimers[indexPath.row];
        
        [header addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        }];
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NIMMessage* message = self.chatContentManage.imageViewMessages[indexPath.section][indexPath.row];
    
    NIMImageObject *object = (NIMImageObject *)message.messageObject;
    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    item.itemId         = [message messageId];
    item.size           = [object size];
    
    NIMSession* session = [NIMSession session:self.targetId type:NIMSessionTypeTeam];
//    NIMSession *session = [self isMemberOfClass:[YZHPrivateChatVC class]]? self.session : nil;
    
    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:session];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
//        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
//            if (!error) {
//                [wself uiUpdateMessage:message];
//            }
        }];
    }
}

#pragma mark - NIMMessageCellDelegate

- (BOOL)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view {
    
    BOOL handle = NO;
    NSArray *items = [self menusItems:message];
    if ([items count] && [self becomeFirstResponder]) {
        UIMenuController *controller = [UIMenuController sharedMenuController];
        controller.menuItems = items;
        _messageForMenu = message;
        [controller setTargetRect:view.bounds inView:view];
        [controller setMenuVisible:YES animated:YES];
        handle = YES;
    }
    return handle;
}

#pragma mark - 5.Event Response

- (void)copyText:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    if (message.text.length) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:message.text];
    }
}

- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    
    BOOL copyText = NO;
    if (message.messageType == NIMMessageTypeText)
    {
        copyText = YES;
    }
    if (copyText) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"复制"
                                                    action:@selector(copyText:)]];
    }
    return items;
    
}

- (void)onTouchSearch:(UIButton *)sender {
    
    NIMSession* session;
    if (self.isTeam) {
        session = [NIMSession session:self.targetId type:NIMSessionTypeTeam];
    } else {
        session = [NIMSession session:self.targetId type:NIMSessionTypeP2P];
    }
    if (session) {
        [YZHRouter openURL:kYZHRouterSessionSearchChatContent info:@{
                                                                     @"session": session,
                                                                     @"allTextMessages": self.allTextMessage.count ? self.allTextMessage : [[NSMutableArray alloc] init],
                                                                     kYZHRouteSegueNewNavigation: @(YES),
                                                                     kYZHRouteSegue: kYZHRouteSegueModal
                                                                     }];
    } else {
        [YZHRouter openURL:kYZHRouterSessionSearchChatContent];
    }
    
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (UICollectionView *)imageCollectionView {
    
    if (!_imageCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.headerReferenceSize = CGSizeMake(YZHScreen_Width, 40);
        flowLayout.minimumInteritemSpacing = 6;
        flowLayout.minimumLineSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.itemSize = CGSizeMake((YZHScreen_Width - 20 - 3 * 6) / 4 , 75);
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        _imageCollectionView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        [_imageCollectionView registerClass:[YZHImageContentCell class] forCellWithReuseIdentifier:kImageCellIdentifie];
        [_imageCollectionView registerClass:[YZHImageReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kImageHeaderViewIdentifie];
    }
    return _imageCollectionView;
}

- (UITableView *)cardTableView{
    
    if (_cardTableView == nil) {
        _cardTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _cardTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        [_cardTableView registerClass:[YZHCardContentCell class] forCellReuseIdentifier:kCardCellIdentifie];
        [_cardTableView registerNib:[UINib nibWithNibName:@"YZHAddFirendRecordSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHCommonHeaderIdentifier];
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
        _urlTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        
        [_urlTableView registerClass:[YZHChatTextContentCell class] forCellReuseIdentifier:kUrlCellIdentifie];
        [_urlTableView registerNib:[UINib nibWithNibName:@"YZHAddFirendRecordSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHCommonHeaderIdentifier];
        _urlTableView.delegate = self;
        _urlTableView.dataSource = self;
        _urlTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _urlTableView.tag = YZHChatContentTypeUrl;
    }
    return _urlTableView;
}

@end
