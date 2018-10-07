//
//  YZHMyInformationPhotoVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationPhotoVC.h"

#import "YZHPhotoManage.h"
#import "UIButton+YZHTool.h"

static NSArray* buttonArray;
@interface YZHMyInformationPhotoVC ()

@property (weak, nonatomic) IBOutlet UIButton *savePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *callPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *callCameraButton;

@end

@implementation YZHMyInformationPhotoVC

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
    
    [super viewWillAppear:animated];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar
{
    self.navigationItem.title = @"头像";
    self.hideNavigationBarLine = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundDarkBlue];
    
    [self.callCameraButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateHighlighted];
    [self.callPhotoButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateHighlighted];
    [self.savePhotoButton yzh_setBackgroundColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateHighlighted];
    
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

- (IBAction)useCameraPictures:(UIButton *)sender {
    
    sender.backgroundColor = [UIColor whiteColor];
    [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypeCamera finishPicking:^(UIImage * _Nonnull image) {
        self.photoImageView.image = image;
    }];
}

- (IBAction)callMobilePhoto:(UIButton *)sender {
    
    sender.backgroundColor = [UIColor whiteColor];
    
    [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
        self.photoImageView.image = image;
    }];
    
}

- (IBAction)performbSavePhoto:(UIButton *)sender {
    
//    sender.backgroundColor = [UIColor whiteColor];
}

- (void)highlightedBackground:(UIButton *)sender {
    
//    if (sender.highlighted) {
//        sender.backgroundColor = [UIColor yzh_backgroundThemeGray];
//    } else {
//
//    }
}


#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

#pragma mark - 7.GET & SET


@end
