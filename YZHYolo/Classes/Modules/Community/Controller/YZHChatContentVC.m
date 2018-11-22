//
//  YZHChatContentVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHChatContentVC.h"

#import "YZHChatContentHeaderView.h"
@interface YZHChatContentVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YZHChatContentHeaderView* headerView;
@property (nonatomic, strong) UITableView* imageTableView;
@property (nonatomic, strong) UITableView* cardTableView;
@property (nonatomic, strong) UITableView* urlTableView;
@property (nonatomic, strong) NSArray<UITableView *>* tableViewArray;

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
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
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
//        _cardTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        _cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _cardTableView;
}

- (UITableView *)urlTableView{
    
    if (_urlTableView == nil) {
        _urlTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _urlTableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
        //     [_imageTableView registerNib:[UINib libWithNibName:@"YZHMyCenterCell" bundle:nil] urlorCellReuseIdentifier: KCellIdentifier];
        _urlTableView.delegate = self;
        _urlTableView.dataSource = self;
        _urlTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _urlTableView;
}


@end
