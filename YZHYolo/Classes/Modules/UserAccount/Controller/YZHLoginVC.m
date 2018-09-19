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

@interface YZHLoginVC ()

@property(nonatomic, strong)YZHLoginView* loginView;
@property (nonatomic, strong) UIToolbar *keyboardToolbar; //键盘上方的工具栏

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
//    //监听textField已经开始编辑通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldTextDidBeginEditing:)
//                                                 name:UITextFieldTextDidBeginEditingNotification
//                                               object:nil];
//    //监听键盘将要隐藏通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

#pragma mark - 防止TextField被键盘盖住
/*
- (void)textFieldTextDidBeginEditing:(NSNotification *)aNotificaiton
{
    UITextField *textField = aNotificaiton.object;
    //判断是否是当前view的subview
    if ([textField isDescendantOfView:self.view] == NO) {
        return;
    }
    //TODO:适应不同的键盘高度
    //算出view需上移的高度
    UIView *view = textField.window;
    CGRect rect = [textField convertRect:textField.bounds toView:view];
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat scrollY = 252 + 20 - (view.bounds.size.height - maxY - 44.0);
    scrollY = scrollY>0 ? scrollY : 0.0 ;
    //上移view
    if (self.textFieldScrollView) {
        [self.textFieldScrollView setContentOffset:CGPointMake(0, scrollY+self.textFieldScrollView.contentOffset.y) animated:YES];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect bounds = self.view.bounds;
            bounds.origin.y += scrollY;
            self.view.bounds = bounds;
        }];
    }
    //键盘上方的工具栏，在iPhone4和4s机型上可能会挡住HUD，暂时取消。
        textField.inputAccessoryView = self.keyboardToolbar;
    //    textField.inputView = nil;
}

- (void)hideKeyboardBarAction:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
}

- (void)keyboardWillHide{
    //复原view的位置
    if (self.textFieldScrollView) {
        [self.textFieldScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect bounds = self.view.bounds;
            bounds.origin.x = 0;
            bounds.origin.y = 0;
            self.view.bounds = bounds;
        }];
    }
}
*/

#pragma mark GET & SET

- (UIToolbar *)keyboardToolbar {
    if (_keyboardToolbar == nil) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboardBarAction:)];
        [toolBar setItems:@[flexItem, doneItem] animated:NO];
        _keyboardToolbar = toolBar;
    }
    return _keyboardToolbar;
}


#pragma mark - 7.GET & SET


@end
