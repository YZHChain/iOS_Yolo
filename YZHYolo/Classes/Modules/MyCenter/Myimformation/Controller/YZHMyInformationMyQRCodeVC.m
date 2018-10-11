//
//  YZHMyInformationMyQRCodeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationMyQRCodeVC.h"

@interface YZHMyInformationMyQRCodeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;


@end

@implementation YZHMyInformationMyQRCodeVC

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
    self.navigationItem.title = @"我的二维码";
    self.hideNavigationBarLine = YES;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
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
- (IBAction)saveImageViewToPhoto:(UIButton *)sender {
    
    UIImage* image = [self imageFromView:self.photoView];
    [self saveImageToPhotos:image];
}

#pragma mark - 6.Private Methods

- (void)setupNotification
{
    
}

-(UIImage*)imageFromView:(UIView*)view{
    CGSize s = view.bounds.size;
       UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)saveImageToPhotos:(UIImage*)savedImage{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        NSLog(@"存入手机相册成功");
    }else{
        NSLog(@"存入手机相册失败");
    }
}
#pragma mark - 7.GET & SET

@end
