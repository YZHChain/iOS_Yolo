//
//  YZHMyInformationVC.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationVC.h"


static NSString* const KCellIdentifier = @"imformationCellIdentifier";
@interface YZHMyInformationVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView* tableView;

@end

@implementation YZHMyInformationVC

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
//    if (self.supportNavigation) {
//        self.navigationController.navigationBar.hidden = YES;
//    }
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"个人信息";
    self.showNavigationBar = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc] init];
}

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"YZHMyInformationCell" bundle:nil] forCellReuseIdentifier: KCellIdentifier];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor yzh_backgroundThemeGray];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
