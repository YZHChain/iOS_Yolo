//
//  YZHBaseViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

@interface YZHBaseViewController ()

@end

@implementation YZHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置通知
    [self setupNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (self.hideNavigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    }
    if (self.hideNavigationBarLine) {
//        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (self.hideNavigationBar) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if (self.hideNavigationBarLine) {
//        self.navigationController.navigationBarHidden = NO;
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



#pragma mark GET & SET

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

@end
