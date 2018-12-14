//
//  YZHMyInformationMyQRCodeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationMyQRCodeVC.h"

#import "YZHPublic.h"
#import "ZXingObjC.h"
#import "YZHUserModelManage.h"
@interface YZHMyInformationMyQRCodeVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (nonatomic, copy) NSString* QRCodeResult;

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
    self.view.backgroundColor = [UIColor yzh_backgroundDarkBlue];
    
    [self.view layoutIfNeeded];
    [self.view yzh_addGradientLayerView];
    
    NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    if (YZHIsString(user.userInfo.nickName)) {
        self.nickNameLabel.text = user.userInfo.nickName;
    } else {
        self.nickNameLabel.text = @"Yolo用户";
    }
    if (YZHIsString(user.userInfo.avatarUrl)) {
        [self.headerPhotoImageView yzh_setImageWithString:user.userInfo.avatarUrl placeholder:@"addBook_cover_cell_photo_default"];
        CGFloat radiu = 4;
        [self.headerPhotoImageView yzh_cornerRadiusAdvance:radiu rectCornerType: UIRectCornerAllCorners];
    }
    //生成二维码
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    CGSize imageSize = self.QRCodeImageView.size;
    ZXBitMatrix* result = [writer encode:self.QRCodeResult
                                  format:kBarcodeFormatQRCode
                                   width:imageSize.width
                                  height:imageSize.height
                                   error:&error];
    if (result) {
        CGImageRef image = CGImageRetain([[ZXImage imageWithMatrix:result] cgimage]);
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        self.QRCodeImageView.image = [UIImage imageWithCGImage:image];
        
        CGImageRelease(image);
    } else {
        
        [YZHProgressHUD showText:@"二维码图像处理失败, 请重试" onView:self.view];
    }
    
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

- (void)saveImageToPhotos:(UIImage*)savedImage {
    // TODO: 先检查设备是否授权访问相册
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
//        [self.view makeToast:@"图片已经保存到相册"
//                    duration:1
//                    position:CSToastPositionCenter];
        [YZHProgressHUD showText:@"图片已经保存到相册" onView:self.view];
    }else{
//        [self.view makeToast:@"图片保存失败,请重试"
//                    duration:1
//                    position:CSToastPositionCenter];
        [YZHProgressHUD showText:@"图片保存失败,请重试" onView:self.view];
    }
    

}

#pragma mark - 7.GET & SET

- (NSString *)QRCodeResult {
    
    if (!_QRCodeResult) {
        
        NSDictionary* dic = @{
                              @"type": [NSNumber numberWithInteger:0],
                              @"accid": [[[NIMSDK sharedSDK] loginManager] currentAccount]
                              };
        
        _QRCodeResult = [dic mj_JSONString];
    }
    return _QRCodeResult;
}

@end
