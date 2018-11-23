//
//  YZHCommunityAtMemberVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCommunityAtMemberVC.h"

#import "YZHAtMemberHeaderView.h"
#import "YZHBaseNavigationController.h"
#import "YZHAtMemberCell.h"
#import "YZHAddBookSectionView.h"
#import "UITableView+SCIndexView.h"
#import "NIMContactDefines.h"
#import "YZHAtMemberModel.h"
#import "YZHProgressHUD.h"

static NSString* kYZHAddBookSectionViewIdentifier = @"sectionView";
@interface YZHCommunityAtMemberVC ()<UITableViewDelegate, UITableViewDataSource, SCTableViewSectionIndexDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) YZHAtMemberHeaderView* headerView;
@property (nonatomic, strong) NSDictionary *contentDic;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) SCIndexViewConfiguration* indexViewConfiguration;
@property (nonatomic, strong) YZHAtMemberModel* atMemberModel;
@property (nonatomic, strong) NSMutableArray* selectedAtMembers;
@property (nonatomic, strong) NSMutableArray* selectedIndexPath;
@property (nonatomic, strong) UIImageView* atAllCellSelectedImageView;
@property (nonatomic, assign) BOOL isAtAll;

@end

@implementation YZHCommunityAtMemberVC

#pragma mark - 1.View Controller Life Cycle

- (instancetype)initWithConfig:(id)config withIsManage:(BOOL)isManage {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
        _isManage = isManage;
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

- (void)show{
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:[[YZHBaseNavigationController alloc] initWithRootViewController:self] animated:YES completion:nil];
}


#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    self.navigationItem.title = @"选择@的人";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(clickConfirm:)];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    [self.view addSubview:self.tableView];
    self.tableView.sc_indexViewConfiguration = self.indexViewConfiguration;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    self.isAtAll = NO;
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.isManage ? self.atMemberModel.groupTitleCount + 1 : self.atMemberModel.groupTitleCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isManage) {
        if (section == 0) {
            return 1;
        } else {
            return [self.atMemberModel memberCountOfGroup:section - 1];
        }
    } else {
        return [self.atMemberModel memberCountOfGroup:section];
    }
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZHContactMemberModel* memberModel;
    if (self.isManage) {
        if (indexPath.section == 0) {
            static NSString* cellIdentify = @"cell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
                cell.textLabel.text = @"@全体成员";
                cell.textLabel.font = [UIFont systemFontOfSize:13];
            }
            if ([self.selectedIndexPath containsObject:indexPath]) {
                [cell.contentView addSubview:self.atAllCellSelectedImageView];
            } else {
                [self.atAllCellSelectedImageView removeFromSuperview];
            }
            return cell;
        } else {
            //由于多了一行 Section,需要减一 才是真正的的 Model
            NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
            memberModel =  (YZHContactMemberModel *)[self.atMemberModel atMemberOfIndex:newIndexPath];
            YZHAtMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
            [cell refreshAtmember:memberModel];
            if ([self.selectedIndexPath containsObject:indexPath]) {
                [cell.contentView addSubview:cell.selectedImageView];
            } else {
                [cell.selectedImageView removeFromSuperview];
            }
            return cell;
        }
    } else {
        YZHContactMemberModel* memberModel;
        memberModel = (YZHContactMemberModel *)[self.atMemberModel atMemberOfIndex:indexPath];
        YZHAtMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:kYZHCommonCellIdentifier forIndexPath:indexPath];
        [cell refreshAtmember:memberModel];
        if ([self.selectedIndexPath containsObject:indexPath]) {
            [cell.contentView addSubview:cell.selectedImageView];
        } else {
            [cell.selectedImageView removeFromSuperview];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isManage) {
        if (indexPath.section == 0) {
            return 35;
        } else {
            return 55;
        }
    } else {
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YZHAddBookSectionView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYZHAddBookSectionViewIdentifier];
    if (self.isManage) {
        if (section == 0) {
            view.titleLabel.text = nil;
        } else {
            view.titleLabel.text = self.atMemberModel.sortedGroupTitles[section - 1];
        }
    } else {
        view.titleLabel.text = self.atMemberModel.sortedGroupTitles[section];
    }
    
    return view;
}

// 添加分段尾,为了隐藏每个Section最后一个 Cell 分割线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] init];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZHContactMemberModel* memberModel;
    if (self.isManage) {
        if (indexPath.section == 0) {
            self.isAtAll = !self.isAtAll;
            if ([self.selectedIndexPath containsObject:indexPath]) {
                [self.selectedIndexPath removeObject:indexPath];
            } else {
                [self.selectedIndexPath addObject:indexPath];
            }
        } else {
            //选中非 At ALL时
            NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
            memberModel = (YZHContactMemberModel*)[self.atMemberModel atMemberOfIndex:selectedIndexPath];
            //确保能找到此用户 ID。
            if (YZHIsString(memberModel.info.infoId)) {
                if ([self.selectedIndexPath containsObject:indexPath]) {
                    [self.selectedIndexPath removeObject:indexPath];
                } else {
                    [self.selectedIndexPath addObject:indexPath];
                }
                if ([self.selectedAtMembers containsObject:memberModel.info.infoId]) {
                    [self.selectedAtMembers removeObject:memberModel.info.infoId];
                } else {
                        [self.selectedAtMembers addObject:memberModel.info.infoId];
                }
            } else {
//                [YZHProgressHUD showLoadingOnView:YZHAppWindow text:@"无法找到此用户信息,请稍后再试"];
                [YZHProgressHUD showText:@"无法找到此用户信息,请稍后再试" onView:YZHAppWindow completion:nil];
            }
        }

    } else {
        memberModel = (YZHContactMemberModel*)[self.atMemberModel atMemberOfIndex:indexPath];
        if (YZHIsString(memberModel.info.infoId)) {
            [self.selectedIndexPath removeAllObjects];
            [self.selectedIndexPath addObject:indexPath];
            [self.selectedAtMembers removeAllObjects];
            [self.selectedAtMembers addObject:memberModel.info.infoId];
        } else {
//            [YZHProgressHUD showLoadingOnView:YZHAppWindow text:@"无法找到此用户信息,请稍后再试"];
            [YZHProgressHUD showText:@"无法找到此用户信息,请稍后再试" onView:YZHAppWindow completion:nil];
        }
    }
    
    [tableView reloadData];
}

#pragma mark - SCTableViewSectionIndexDelegate
// 重写这两个代理方法,否则默认算法 indexView 与实际不一致.
- (void)tableView:(UITableView *)tableView didSelectIndexViewAtSection:(NSUInteger)section {

    NSIndexPath* indexPath;
    if (section > 0) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section + 1];
    } else {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    }
    CGRect frame = [tableView rectForSection:indexPath.section];
    [_tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:NO];
}

- (NSUInteger)sectionOfTableViewDidScroll:(UITableView *)tableView {

    NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    NSInteger indexSection = indexPath.section;
    if (self.isManage) {
        if (indexSection > 0) {
            indexSection = indexPath.section - 1;
        } else {
            indexPath = 0;
        }
    } else {
        if (indexSection > 0) {
            indexSection = indexPath.section;
        } else {
            indexPath = 0;
        }
    }
    //TODO
    return indexSection;
}

#pragma mark - 5.Event Response

- (void)clickCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickConfirm:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.isManage) {
        if (self.isAtAll) {
            //选中所有 选中所有处理.
            if ([self.delegate respondsToSelector:@selector(didFinishedSelect:isRespond:)]) {
                [self.delegate didFinishedSelect:self.selectedAtMembers isRespond:self.headerView.respondSwitch.isOn];
            }
        } else {
            if (self.selectedAtMembers.count) {
                if ([self.delegate respondsToSelector:@selector(didFinishedSelect:isRespond:)]) {
                    [self.delegate didFinishedSelect:self.selectedAtMembers isRespond:self.headerView.respondSwitch.isOn];
                }
            } else {
                //无选择.
            }
        }
    } else {
        if (self.selectedAtMembers.count) {
            if ([self.delegate respondsToSelector:@selector(didFinishedSelect:isRespond:)]) {
                [self.delegate didFinishedSelect:self.selectedAtMembers isRespond:self.headerView.respondSwitch.isOn];
            }
        } else {
            //无选择.
        }
    }
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)makeData {
    
    @weakify(self)
    [self.config getAtMemberData:^(YZHAtMemberModel *atMemberModel) {
        @strongify(self)
        self.atMemberModel = atMemberModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            self.tableView.sc_indexViewDataSource = self.atMemberModel.sortedGroupTitles;
            [self.tableView reloadData];
        });
        
    }];
    
}

#pragma mark - 7.GET & SET

- (YZHAtMemberHeaderView *)headerView {

    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"YZHAtMemberHeaderView" owner:nil options:nil].lastObject;
        _headerView.backgroundView = ({
            UIView * view = [[UIView alloc] initWithFrame:_headerView.bounds];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _headerView;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.frame = self.view.bounds;
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAtMemberCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kYZHCommonCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHAddBookSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:kYZHAddBookSectionViewIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
    }
    return _tableView;
}

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

- (void)setConfig:(id<NIMContactSelectConfig>)config{
    _config = config;
    if ([config respondsToSelector:@selector(maxSelectedNum)]) {
        _contentDic = @{}.mutableCopy;
        _sectionTitles = @[].mutableCopy;
    }
    [self makeData];
}

- (NSMutableArray *)selectedAtMembers {
    
    if (!_selectedAtMembers) {
        _selectedAtMembers = [[NSMutableArray alloc] init];
    }
    return _selectedAtMembers;
}

- (NSMutableArray *)selectedIndexPath {
    
    if (!_selectedIndexPath) {
        _selectedIndexPath = [[NSMutableArray alloc] init];
    }
    return _selectedIndexPath;
}

- (UIImageView *)atAllCellSelectedImageView {
    
    if (!_atAllCellSelectedImageView) {
        _atAllCellSelectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_information_setName_selected"]];
        _atAllCellSelectedImageView.x = YZHScreen_Width - 36;
        _atAllCellSelectedImageView.y = 10;
        [_atAllCellSelectedImageView sizeToFit];
    }
    return _atAllCellSelectedImageView;
}

@end
