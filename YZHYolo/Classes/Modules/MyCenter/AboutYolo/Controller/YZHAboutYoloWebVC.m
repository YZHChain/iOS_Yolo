//
//  YZHAboutYoloWebVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAboutYoloWebVC.h"
#import <WebKit/WebKit.h>
#import "YZHUserLoginManage.h"
#import "YZHProgressHUD.h"
/*
@interface YZHAboutYoloWebVC ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic, strong) YZHProgressHUD* hud;
@property (nonatomic, strong) NSString* userId;

@end

@implementation YZHAboutYoloWebVC


#pragma mark - 1.View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
//    [self setupNavBar];
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
    self.navigationItem.title = @"";
}

- (void)setupView {
    
//    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
    
    super.hideNavigationBar = true ;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self wkWebView]];
    
    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
    [self setStatusBarBackgroundGradientColorFromLeftToRight:startColor withEndColor:endColor];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET


-(WKWebView*)wkWebView{
    
if (self.webView==nil) {
    //创建并配置WKWebView的相关参数
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    configuration.userContentController = userContentController;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    CGRect frame = self.view.frame;
    if(self.navigationController.viewControllers.count==1){
        frame.size.height = frame.size.height - self.tabBarController.tabBar.frame.size.height;
    }
    self.webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    self.webView.navigationDelegate = self;
    NSString* yolo_no = [YZHUserLoginManage sharedManager].currentLoginData.account;
    if (self.url==nil) {
        self.url = [NSString stringWithFormat:@"https://yolotest.yzhchain.com/yolo-web/index.html?yolo_no=%@&platform=ios",yolo_no];
    }
    NSURL* url = [[NSURL alloc] initWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url ]];
    self.webView.UIDelegate = self;
    
    NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
    // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
    
    return self.webView;
    
}


@end
    */
