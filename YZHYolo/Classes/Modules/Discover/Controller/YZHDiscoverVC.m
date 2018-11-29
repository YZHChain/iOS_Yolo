//
//  YZHDiscoverVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHDiscoverVC.h"
#import <WebKit/WebKit.h>
#import "YZHUserLoginManage.h"
#import "YZHProgressHUD.h"

@interface YZHDiscoverVC () <WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView* webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic,strong) YZHProgressHUD* hud ;
@end

@implementation YZHDiscoverVC


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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"广场";
}

- (void)setupView
{
    super.hideNavigationBar = true ;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self wkWebVie] ];
    
    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
    [self setStatusBarBackgroundGradientColorFromLeftToRight:startColor withEndColor:endColor];
    
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.height, 2)];
//    [self.view addSubview:self.progressView];
//    self.progressView.progressTintColor = [UIColor greenColor];
//    self.progressView.trackTintColor = [UIColor clearColor];
    
}

-(WKWebView*)wkWebVie{
    if (self.webView==nil) {
        //创建并配置WKWebView的相关参数
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"CreateGroup"];
        [userContentController addScriptMessageHandler:self name:@"GOBACK"];
        [userContentController addScriptMessageHandler:self name:@"AddGroup"];
        [userContentController addScriptMessageHandler:self name:@"SelectMyGroup"];
        [userContentController addScriptMessageHandler:self name:@"SelectGroup"];
        [userContentController addScriptMessageHandler:self name:@"ChangeRecommend"];
        [userContentController addScriptMessageHandler:self name:@"SelectRecuire"];
        [userContentController addScriptMessageHandler:self name:@"AddRecuire"];
        [userContentController addScriptMessageHandler:self name:@"SelectActiveGroup"];
        
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
            self.url = [NSString stringWithFormat:@"http://192.168.3.31:8091?yolo_no=%@&platform=ios",yolo_no];
        }
        NSURL* url = [[NSURL alloc] initWithString:self.url];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url ] ];
        self.webView.UIDelegate = self;
        
        NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
        // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];

    }
    return self.webView;
}

-(void)removeScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"CreateGroup"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"GOBACK"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AddGroup"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SelectMyGroup"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SelectGroup"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"ChangeRecommend"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SelectRecuire"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"AddRecuire"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SelectActiveGroup"];
}


- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET

#pragma mark - WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"AddGroup"]) { //公开群-加入
        NSNumber* value = message.body;
        NSLog(@"%@", [value stringValue]);
        return;
    }
    
    if ([message.name isEqualToString:@"GOBACK"]) { //返回
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    if ([message.name isEqualToString:@"CreateGroup"]) { //招募管理-立即创建
        NSLog(@"CreateGroup");
        return;
    }
    
    if ([message.name isEqualToString:@"SelectMyGroup"]) { //招募管理里面的搜索
        NSLog(@"SelectMyGroup");
        return;
    }
    
    if ([message.name isEqualToString:@"SelectGroup"]) { //公开群-搜索
        NSLog(@"SelectGroup");
        return;
    }
    
    if ([message.name isEqualToString:@"ChangeRecommend"]) { //更换推荐
        NSLog(@"ChangeRecommend");
        return;
    }
    
    if ([message.name isEqualToString:@"SelectRecuire"]) { //社群招募里面的搜索
        NSLog(@"SelectRecuire");
        return;
    }
    
    if ([message.name isEqualToString:@"AddRecuire"]) { //社群招募-加入
        NSLog(@"AddRecuire");
        NSNumber* value = message.body;
        NSLog(@"%@", [value stringValue]);
        return;
    }
    
    if ([message.name isEqualToString:@"SelectActiveGroup"]) { //活跃群里面的查找
        NSLog(@"SelectActiveGroup");
        return;
    }
    
    
    
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideHUD];
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHUD];
}


-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
   self.hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{
    
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHUD];
}

//服务器开始请求的时候调用
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    Boolean flag = false;
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            flag = [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            flag = [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            flag = [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    if (flag) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}


//请求链接处理
-(Boolean)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return false;
    }
    
    if([[self wkWebVie].URL.absoluteString isEqualToString: request.URL.absoluteString]){
        return false;
    }
    
    YZHDiscoverVC* vc = [[YZHDiscoverVC alloc] init];
    vc.url =[ [NSString alloc] initWithFormat:@"%@",request.URL.absoluteString]  ;
    [self.navigationController pushViewController:vc animated:true];
    
    return true;
    
}

//提示框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@", message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        [self.progressView setProgress:[self wkWebVie].estimatedProgress animated:YES];
//        if ([self wkWebVie].estimatedProgress < 1.0) {
//            self.delayTime = 1 - self.webView.estimatedProgress;
//            return;
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.progressView.progress = 0;
//        });
    }
}

//防止内存泄漏
-(void)dealloc{
    if (self.webView!=nil) {
        [self removeScriptMessageHandler];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

-(void)hideHUD{
    if (self.hud!=nil) {
        [self.hud hideWithText:nil];
    }
}



@end
