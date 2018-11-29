//
//  YZHDiscoverVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHDiscoverVC.h"
#import <WebKit/WebKit.h>

@interface YZHDiscoverVC () <WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView* webView;

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
    
//    [self setStatusBarBackgroundColor:[UIColor blueColor]];
    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
    [self setStatusBarBackgroundGradientColorFromLeftToRight:startColor withEndColor:endColor];

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
    
}

-(WKWebView*)wkWebVie{
    if (self.webView==nil) {
        //创建并配置WKWebView的相关参数
        //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
        //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
        //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
        
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
//        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        CGRect frame = self.view.frame;
        if(self.navigationController.viewControllers.count==1){
            frame.size.height = frame.size.height - self.tabBarController.tabBar.frame.size.height;
        }
        self.webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
//        self.webView.allowsBackForwardNavigationGestures = true ;
        self.webView.navigationDelegate = self;
        
        //    //loadFileURL方法通常用于加载服务器的HTML页面或者JS，而loadHTMLString通常用于加载本地HTML或者JS
        if (self.url==nil) {
            self.url = @"http://192.168.3.31:8091?yolo_no=123&platform=ios";
        }
            NSURL* url = [[NSURL alloc] initWithString:self.url];
            [self.webView loadRequest:[NSURLRequest requestWithURL:url ] ];
        //
            self.webView.UIDelegate = self;
        //
        //    [self.view addSubview:self.webView];
    }
    return self.webView;
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
    
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}


-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{
    
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
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
    //    NSLog(@"push with request %@",request);
//    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return false;
    }
    
    if([[self wkWebVie].URL.absoluteString isEqualToString: request.URL.absoluteString]){
        return false;
    }

//    UIView* currentSnapShotView = [[self wkWebVie] snapshotViewAfterScreenUpdates:YES];
    YZHDiscoverVC* vc = [[YZHDiscoverVC alloc] init];
    vc.url =[ [NSString alloc] initWithFormat:@"%@%@",request.URL.absoluteString,@"?platform=ios"]  ;
    [self.navigationController pushViewController:vc animated:true];
    
    return true;
  
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@", message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];

}




@end
