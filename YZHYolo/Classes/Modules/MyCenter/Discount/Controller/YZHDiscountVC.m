//
//  YZHDiscountVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHDiscountVC.h"

#import <WebKit/WebKit.h>
#import "YZHUserLoginManage.h"
#import "YZHProgressHUD.h"
#import "ZXingObjC.h"
#import "YZHServicesConfig.h"

@interface YZHDiscountVC ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic, strong) YZHProgressHUD* hud;
@property (nonatomic, strong) NSString* userId;

@end

@implementation YZHDiscountVC


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

//防止内存泄漏
-(void)dealloc{
    
    if (self.webView!=nil) {
        [self removeScriptMessageHandler];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 每次进入页面时,重新刷新一次.
    [self.webView reload];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"异业联盟";
}

- (void)setupView
{
    super.hideNavigationBar = true;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self wkWebView]];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    UIColor* startColor = [UIColor yzh_colorWithHexString:@"#002E60"];
    UIColor* endColor = [UIColor yzh_colorWithHexString:@"#204D75"];
    [self setStatusBarBackgroundGradientColorFromLeftToRight:startColor withEndColor:endColor];
}

-(WKWebView*)wkWebView {
    
    if (self.webView==nil) {
        //创建并配置WKWebView的相关参数
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        [userContentController addScriptMessageHandler:self name:@"GOBACK"];
        [userContentController addScriptMessageHandler:self name:@"SAVEQR"];
        [userContentController addScriptMessageHandler:self name:@"GOROOT"];
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
        NSString* yolo_no = [YZHUserLoginManage sharedManager].currentLoginData.yoloId;
        NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:userId];
        NSString* userNick = user.userInfo.nickName;
        NSString* userPic = user.userInfo.avatarUrl;
        
        if (YZHIsString(userPic)) {
            userPic = [userPic stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        } else {
            userPic = nil;
        }
        if (self.url == nil) {
            NSString* urlServerString;
            //只有 DEBUG 时,才会切环境,否则默认都是使用正式服务地址.
#if DEBUG
            //  配置测试服,会检测是否开启、
            urlServerString = [YZHServicesConfig debugTestServerConfig];
#else
            urlServerString = [YZHServicesConfig stringForKey:kYZHAppConfigServerAddr];
#endif
            if (YZHIsString(userPic)) {
               self.url = [NSString stringWithFormat:@"%@%@?userId=%@&userNick=%@&userPic=%@&platform=ios",urlServerString , PATH_WEB_DISCOUNT, yolo_no, userNick, userPic];
            } else {
                self.url = [NSString stringWithFormat:@"%@%@?userId=%@&userNick=%@&userPic=&platform=ios",urlServerString , PATH_WEB_DISCOUNT, yolo_no, userNick];
            }
        }
        NSString* urlStr = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if (YZHIsString(urlStr) && [urlStr containsString:@"%23"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
        }
        NSURL* url = [[NSURL alloc] initWithString: urlStr];
        NSLog(@"-----加载 URL:%@------", url);
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                              timeoutInterval:60 * 60 * 1];
        [self.webView loadRequest: theRequest];
        self.webView.UIDelegate = self;
        
        NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
        // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
        
    }
    return self.webView;
}

-(void)removeScriptMessageHandler{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"GOBACK"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SAVEQR"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"GOROOT"];
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

- (void)saveImageToPhotos:(UIImage*)savedImage {
    // TODO: 先检查设备是否授权访问相册
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [YZHProgressHUD showText:@"图片已经保存到相册" onView:self.webView];
    }else{
        [YZHProgressHUD showText:@"图片保存失败,请重试" onView:self.webView];
    }
}

- (void)creatQRCodeAndSavaToPotosWithQRString:(NSString *)qrString  {
    //生成二维码
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    CGSize imageSize = CGSizeMake(217, 217);
    ZXBitMatrix* result = [writer encode:qrString
                                  format:kBarcodeFormatQRCode
                                   width:imageSize.width
                                  height:imageSize.height
                                   error:&error];
    if (result) {
        CGImageRef image = CGImageRetain([[ZXImage imageWithMatrix:result] cgimage]);
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        //保存图片
        [self saveImageToPhotos:[UIImage imageWithCGImage:image]];
        
        CGImageRelease(image);
    } else {
        [YZHProgressHUD showText:@"二维码图像处理失败, 请重试" onView:self.webView];
    }
}

#pragma mark - 7.GET & SET

#pragma mark - WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"GOBACK"]) { //返回
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    if ([message.name isEqualToString:@"SAVEQR"]) { //邀请码界面-保存二维码
        NSString* qrString = @"";
        if([message.body isKindOfClass:[NSString class]]){
            qrString = message.body;
        } else if([message.body isKindOfClass:[NSNumber class]]){
            NSNumber* body = message.body;
            qrString = body.stringValue;
        } else {
            qrString = message.body;
        }
        if (YZHIsString(qrString)) {
            //对其进行 UTF8 编码.
            NSString* QRcodeString = [qrString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self creatQRCodeAndSavaToPotosWithQRString:QRcodeString];
        } else {
            [YZHProgressHUD showText:@"未检测到二维码数据, 请稍后重试" onView:self.webView];
        }
        return;
    }
    if ([message.name isEqualToString:@"GOROOT"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        return;
    }
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideHUDError:nil];
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHUDError:error];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

    self.hud = [YZHProgressHUD showLoadingOnView:self.view text:nil];
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{
    
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHUDError:error];
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
            break;
        }
        case WKNavigationTypeBackForward: {
            NSLog(@"返回上一个页面类型");
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
        return false;
    }
    if([[self wkWebView].URL.absoluteString isEqualToString: request.URL.absoluteString]){
        return false;
    }
    if (![request.URL.absoluteString containsString:@"https://yolo"] ) {
        return false;
    }
//    if ([request.URL.absoluteString containsString:@"https://api"]) {
//        return false;
//    }
    
    if ([request.URL.query containsString:@"goback=1"] && ![self.webView.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return false;
    }
    if ([request.URL.query containsString:@"goRoot=1"] && ![self.webView.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return false;
    }
    YZHDiscountVC* vc = [[YZHDiscountVC alloc] init];
    vc.url = [[NSString alloc] initWithFormat:@"%@",request.URL.absoluteString];
    [self.navigationController pushViewController:vc animated:true];
    NSLog(@"页面跳转:URL:-----%@-----",request.URL.absoluteString);
    
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

-(void)hideHUDError:(NSError *)error{
    if (self.hud != nil) {
        if (error) {
            [self.hud hideWithText:error.domain];
        } else {
            [self.hud hideWithText:nil];
        }
        
    }
}

- (NSString *)userId {
    
    if (!_userId) {
        _userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    }
    return _userId;
}

//自定义清除缓存
- (void)deleteWebCache {
    /*
     在磁盘缓存上。
     WKWebsiteDataTypeDiskCache,
     
     html离线Web应用程序缓存。
     WKWebsiteDataTypeOfflineWebApplicationCache,
     
     内存缓存。
     WKWebsiteDataTypeMemoryCache,
     
     本地存储。
     WKWebsiteDataTypeLocalStorage,
     
     Cookies
     WKWebsiteDataTypeCookies,
     
     会话存储
     WKWebsiteDataTypeSessionStorage,
     
     IndexedDB数据库。
     WKWebsiteDataTypeIndexedDBDatabases,
     
     查询数据库。
     WKWebsiteDataTypeWebSQLDatabases
     */
    if (@available(iOS 9.0, *)) {
//        NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache];
        NSArray * types=@[WKWebsiteDataTypeLocalStorage];
        
        NSSet *websiteDataTypes= [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        // Fallback on earlier versions
    }
}

//- (void)deleteAllWebCache {
//    //allWebsiteDataTypes清除所有缓存
//    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//    
//    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//    
//    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//        
//    }];
//}

@end
