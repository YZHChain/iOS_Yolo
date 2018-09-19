//
//  YZHBaseViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

@interface YZHBaseViewController ()

@property (nonatomic, strong) UIToolbar *keyboardToolbar; //键盘上方的工具栏
@end

@implementation YZHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置通知
    [self setupNotification];
    
    //监听textField已经开始编辑通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    //监听键盘将要隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (self.showNavigationBar) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if (self.hideNavigationBarLine) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (self.showNavigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    }
    if (self.hideNavigationBarLine) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    //关闭键盘
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    
    NSLog(@"%s %@",__FUNCTION__ ,self);
}

#pragma mark setting Notifaction

- (void)setupNotification{
    

}

#pragma mark - 收回键盘

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 防止TextField被键盘盖住

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
//    textField.inputAccessoryView = self.keyboardToolbar;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
