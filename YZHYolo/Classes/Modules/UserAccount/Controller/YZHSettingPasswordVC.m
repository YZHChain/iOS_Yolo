//
//  YZHSettingPasswordVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSettingPasswordVC.h"

#import "YZHSettingPasswordView.h"
#import "YZHRootTabBarViewController.h"
@interface YZHSettingPasswordVC ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong)YZHSettingPasswordView* settingPasswordView;

@end

@implementation YZHSettingPasswordVC

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

- (void)setupNavBar
{
    self.navigationItem.title = @"设置密码";
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.hideNavigationBar = YES;
}

- (void)setupView
{
    self.settingPasswordView = [YZHSettingPasswordView yzh_viewWithFrame:self.view.bounds];
    if (self.settingPasswordType == YZHSettingPasswordTypeFind) {
        self.settingPasswordView.navigationTitleLaebl.text = @"忘记密码";
        self.settingPasswordView.tileTextLabel.text = @"设置新密码";
//        [self.settingPasswordView.confirmButton setTitle:@"完成" forState:UIControlStateNormal];
//        [self.settingPasswordView.confirmButton setTitle:@"完成" forState:UIControlStateDisabled];
    }
    [self.settingPasswordView.confirmButton addTarget:self action:@selector(requestSettingPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.settingPasswordView];
    
    [self.settingPasswordView.passwordTextField becomeFirstResponder];
}

- (void)reloadView
{
    
}

#pragma mark - 3.Request Data

- (void)setupData
{
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten

#pragma mark - 5.Event Response

- (void)requestSettingPassword{
    
    NSString* requestURL;
    switch (YZHSettingPasswordTypeFind) {
        case YZHSettingPasswordTypeRegister:
            requestURL = PATH_USER_REGISTERED_REGISTEREDNVERIFY;
            break;
            case YZHSettingPasswordTypeFind:
            requestURL = PATH_USER_LOGIN_FORGETPASSWORD;
        default:
            requestURL = PATH_USER_REGISTERED_REGISTEREDNVERIFY;
            break;
    }
    NSDictionary* parameters = @{@"password":self.settingPasswordView.passwordTextField.text,
          @"phoneNum":self.phoneNum };
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:requestURL params:parameters successCompletion:^(id obj) {
        @strongify(self)
        [self autoLogin];
    } failureCompletion:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - 6.Private Methods

- (void)autoLogin{
    
    YZHRootTabBarViewController* tabBarViewController = [[YZHRootTabBarViewController alloc] init];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [window setRootViewController:tabBarViewController];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:^(BOOL finished){
                        // 将当前控制器视图移除,否则会造成内存泄漏,被Window 引用无法正常释放.
                        [self.view removeFromSuperview];
                    }];
}

- (void)setupNotification
{
    
}

- (void)keyboardNotification{
    //TODO:需要对 iphoneSE 等小屏做处理, 否则会被键盘盖住.
    //    @weakify(self)
    //    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
    //        @strongify(self)
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

#pragma mark - 7.GET & SET
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
