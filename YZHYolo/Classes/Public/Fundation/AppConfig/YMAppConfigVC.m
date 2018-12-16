//
//  YMAppConfigVC.m
//  YEAMoney
//
//  Created by suke on 2016/10/31.
//  Copyright © 2016年 YEAMoney. All rights reserved.
//

#import "YMAppConfigVC.h"

#import "YMAppConfigCell.h"
#import "YZHServicesConfig.h"

@interface YMAppConfigVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *configInfo;
@property (nonatomic, strong) NSArray *configKeys;
@property (nonatomic, assign) UIWindowLevel originalWindowLevel;

@end

@implementation YMAppConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //取配置信息
    self.configInfo = [[YZHServicesConfig shareServicesConfig].info mutableCopy];
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //改变windowLevel，防止被UIAlertView等window遮挡
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.originalWindowLevel = window.windowLevel;
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    if (window != keyWindow) {
//        window.windowLevel = keyWindow.windowLevel + 1;
//    }
    //iOS 11 后 UIAlertView window 不是 [UIApplication sharedApplication].keyWindow
    window.windowLevel = UIWindowLevelAlert + 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //还原windowLevel
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.windowLevel = self.originalWindowLevel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 2.设置view和样式

- (void)setupNavBar
{
    self.navigationItem.title = @"App Config";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    if ([self isPresented]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    }
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.allowsSelection = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:self.tableView];
    
//    self.textFieldScrollView = self.tableView;
}

- (void)configureCell:(YMAppConfigCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.configKeys[indexPath.row];
    id value = self.configInfo[key];
    NSString *valueClass = NSStringFromClass([value class]);
    
    if ([valueClass isEqualToString:@"__NSCFBoolean"]) {
        cell.keyLabel.text = key;
        cell.valueTextField.hidden = YES;
        cell.valueTextField.text = nil;
        cell.editEndHandler = nil;
        cell.valueSwitch.hidden = NO;
        cell.valueSwitch.on = [value boolValue];
        @weakify(self)
        cell.switchHandler = ^(BOOL on){
            @strongify(self)
            [self.configInfo setObject:@(on) forKey:key];
        };
    } else if ([valueClass isEqualToString:@"__NSCFString"]) {
        cell.keyLabel.text = key;
        cell.valueTextField.hidden = NO;
        cell.valueTextField.text = [NSString stringWithFormat:@"%@",value];
        @weakify(self)
        cell.editEndHandler = ^(NSString *text){
            @strongify(self)
            [self.configInfo setObject:text forKey:key];
        };;
        cell.valueSwitch.hidden = YES;
        cell.valueSwitch.on = NO;
        cell.switchHandler = nil;
    }
}

#pragma mark - 3.请求数据



#pragma mark - 4.数据源、代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.configInfo.count;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        YMAppConfigCell *cell = [[[UINib nibWithNibName:NSStringFromClass([YMAppConfigCell class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    } else if (section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        cell.textLabel.text = @"恢复默认值";
        cell.textLabel.textColor = [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"保存后App会自动关闭，重新打开App后修改生效";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    if (section == 0) {
        
    } else if (section == 1) {
        //TODO:windowLevel比UIActionSheet高是，如何显示UIActionSheet
//        UIActionSheet *sheet = [[UIActionSheet alloc] bk_initWithTitle:@"将恢复所有配置信息到默认值"];
//        [sheet bk_setDestructiveButtonWithTitle:@"恢复默认值" handler:^(){
            [self restoreDefault];
//        }];
//        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
//        [sheet showInView:self.view];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.tableView endEditing:YES];
}

#pragma mark - 5.自定义方法

- (void)restoreDefault
{
    self.configInfo = [[YZHServicesConfig shareServicesConfig].defaultInfo mutableCopy];
    [self.tableView reloadData];
}

- (void)saveAction:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
//    if ([self isPresented]) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    //保存配置信息，重启后生效
    [[YZHServicesConfig shareServicesConfig] saveConfigInfo:self.configInfo];
    //退出应用
    [self exitApplication];
}

//退出应用
- (void)exitApplication
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.5 animations:^{
        window.transform = CGAffineTransformMakeScale(1.0, 0.005*1);
    } completion:^(BOOL finished) {

        UIView *bView = [[UIView alloc] initWithFrame:window.bounds];
        bView.backgroundColor = [UIColor blackColor];
        [window addSubview:bView];
        
        UIView *wView = [[UIView alloc] initWithFrame:window.bounds];
        wView.backgroundColor = [UIColor clearColor];
        [window addSubview:wView];
        UIBezierPath* wPath = [UIBezierPath bezierPathWithOvalInRect:wView.bounds];
        CAShapeLayer *wLayer = [[CAShapeLayer alloc] init];
        wLayer.path = wPath.CGPath;
        wLayer.fillColor = [UIColor whiteColor].CGColor;
        [wView.layer addSublayer:wLayer];
        
        UIView *view = [[UIView alloc] initWithFrame:window.bounds];
        view.backgroundColor = [UIColor clearColor];
        [window addSubview:view];
        UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:view.bounds];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = aPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        [view.layer addSublayer:layer];
        
        [UIView animateWithDuration:0.3*1 animations:^{
            wView.transform = CGAffineTransformMakeScale(0.0000001, 1);
            view.transform = CGAffineTransformMakeScale(1, 0.0000001);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                exit(0);
            });
        }];
    }];
}

- (void)backAction:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isPresented
{
    return self.navigationController.viewControllers.count <= 1;
}

#pragma mark - 6.GET & SET

- (void)setConfigInfo:(NSMutableDictionary *)configInfo {
    _configInfo = configInfo;
    //key排序
    NSArray *array = [configInfo.allKeys copy];
    self.configKeys = [array sortedArrayUsingSelector:@selector(compare:)];
}

@end

