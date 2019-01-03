//
//  YZHBaseViewController.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

@interface YZHBaseViewController ()<NIMUserManagerDelegate>

@end

@implementation YZHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 修改状态栏
//    [self setStatusBarBackgroundColor:[UIColor yzh_backgroundDarkBlue]];
    
    // 设置导航栏
//    [self setupNav];
    // 设置通知
    [self setupNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

//    if (self.hideNavigationBar && self.navigationController.navigationBar.hidden == NO) {
//
//    }
    if (self.hideNavigationBar) {
        if (self.navigationController.viewControllers.count == 1) {
            self.navigationController.navigationBar.hidden = YES;
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }

//    if (self.hideNavigationBarLine) {
//        self.navigationController.navigationBarHidden = YES;
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    if (self.hideNavigationBar && self.navigationController.navigationBar.hidden == YES) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
    if (self.hideNavigationBar) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        } else {
            self.navigationController.navigationBar.hidden = NO;
        }
    }
//    if (self.hideNavigationBarLine) {
//        self.navigationController.navigationBarHidden = NO;
//    }
    
    //关闭键盘
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {

    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    NSLog(@"%s %@",__FUNCTION__ ,self);
}

#pragma mark -- Setting View

- (void)setupNav {
    
    if (!self.navigationItem.backBarButtonItem && !YZHIsString(self.navigationItem.title)) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        backBtn.title = @"返回";
        self.navigationItem.backBarButtonItem = backBtn;
    }
}

- (void)setStatusBarBackgroundGradientColorFromLeftToRight:(UIColor *)startColor withEndColor:(UIColor*) endColor{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        CAGradientLayer *layer = [CAGradientLayer new];
        //存放渐变的颜色的数组
        layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        //起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
        layer.startPoint = CGPointMake(0.0, 0.0);
        layer.endPoint = CGPointMake(1, 0.0);
        
        layer.frame = statusBar.frame;
        //        [statusBar.layer addSublayer:layer];
//        [statusBar.layer insertSublayer:layer atIndex:0];
        CGRect rect = statusBar.frame;
        UIView* view = [[UIView alloc] initWithFrame:rect];
        [view.layer addSublayer:layer];
        [self.view addSubview:view];
//        [self.view.layer insertSublayer:layer atIndex:0];
    }
}

//设置状态栏颜色statusBarWindow
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
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
