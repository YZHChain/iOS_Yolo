//
//  YZHLoginViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHLoginVC.h"

#import "YZHPublic.h"
#import "YZHLoginView.h"
#import "YZHRegisterVC.h"
#import "YZHFindPasswordVC.h"
#import "YZHRootTabBarViewController.h"
#import "UIViewController+KeyboardAnimation.h"

@interface YZHLoginVC ()

@property(nonatomic, strong)YZHLoginView* loginView;


@end

@implementation YZHLoginVC

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
    
    [super viewWillDisappear:animated];
    
    [self keyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    // 移除通知.
    [self an_unsubscribeKeyboard];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"去登录";
}

- (void)setupView
{
    self.loginView = [YZHLoginView yzh_viewWithFrame:self.view.bounds];
    [self.loginView.confirmButton addTarget:self action:@selector(postLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loginView];
    
    [self.loginView.accountTextField becomeFirstResponder];
}

#pragma mark - 3.Request Data

- (void)setupData
{

}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegaten


#pragma mark - 5.Event Response

- (void)postLogin{
    
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

#pragma mark - 6.Private Methods

- (void)setupNotification
{

}

- (void)keyboardNotification{
    
    @weakify(self)
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        @strongify(self)
        if (isShowing) {
            // TODO: 小屏时最好修改一下.
            self.loginView.y = -180;
        } else {
            self.loginView.y = 0;
        }
        [self.loginView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark GET & SET

#pragma mark - 7.GET & SET


@end
