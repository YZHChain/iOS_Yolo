//
//  YZHTeamQRCodeSharedVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamQRCodeSharedVC.h"

#import "YZHSharedFunctionView.h"
#import "YZHPublic.h"
#import "ZXingObjC.h"
#import "YZHTeamExtManage.h"

@interface YZHTeamQRCodeSharedVC()

@property (weak, nonatomic) IBOutlet UIImageView *headerPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (nonatomic, copy) NSString* QRCodeResult;
@property (strong, nonatomic) IBOutlet UIView *saveSharedView;
@property (nonatomic, strong) YZHSharedFunctionView* sharedFunctionView;

@end

@implementation YZHTeamQRCodeSharedVC

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
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"群地址";
    
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundDarkBlue];
    
    @weakify(self);
    self.sharedFunctionView.cancelBlock = ^(UIButton *sender) {
        @strongify(self);
        [self hideSharedTeam];
    };
    
    NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId];
    if (YZHIsString(team.teamName)) {
        self.nickNameLabel.text = team.teamName;
    } else {
        self.nickNameLabel.text = @"Yolo群聊";
    }
    if (YZHIsString(team.avatarUrl)) {
        [self.headerPhotoImageView yzh_setImageWithString:team.avatarUrl placeholder:@"team_cell_photoImage_default"];
        [self.headerPhotoImageView yzh_cornerRadiusAdvance:self.headerPhotoImageView.size.height / 2 rectCornerType: UIRectCornerAllCorners];
    } else {
        self.headerPhotoImageView.image = [UIImage imageNamed:@"team_cell_photoImage_default"];
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
        
    }
    
    self.sharedFunctionView.firendSharedBlock = ^(UIButton *sender) {
        
    };
    self.sharedFunctionView.teamSharedBlock = ^(UIButton *sender) {

    };
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark - 5.Event Response

- (IBAction)saveQRCodeImageView:(UIButton *)sender {
    
    UIImage* image = [self imageFromView:self.photoView];
    [self saveImageToPhotos:image];
}

- (IBAction)sharedTeam:(UIButton *)sender {
    
    [self.saveSharedView removeFromSuperview];
    [self.view addSubview:self.sharedFunctionView];
    
    [self.sharedFunctionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        [UIView animateWithDuration:2 animations:^{
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(151);
            
//        }];
    }];
}

- (void)hideSharedTeam {
    
    [self.sharedFunctionView removeFromSuperview];
    [self.view addSubview:self.saveSharedView];
    [self.saveSharedView mas_makeConstraints:^(MASConstraintMaker *make) {
//        [UIView animateWithDuration:2 animations:^{
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(110);
//        }];
    }];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {

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
        [self.view makeToast:@"图片已经保存到相册"
                    duration:1
                    position:CSToastPositionCenter];
    }else{
        [self.view makeToast:@"图片保存失败,请重试"
                    duration:1
                    position:CSToastPositionCenter];
    }
}

#pragma mark - 7.GET & SET

- (YZHSharedFunctionView *)sharedFunctionView {
    
    if (!_sharedFunctionView) {
        _sharedFunctionView = [[NSBundle mainBundle] loadNibNamed:@"YZHSharedFunctionView" owner:nil options:nil].lastObject;
        
    }
    return _sharedFunctionView;
}

- (NSString *)QRCodeResult {
    
    if (!_QRCodeResult) {
        
        NSDictionary* dic = @{
                              @"type": [NSNumber numberWithInteger:1],
                              @"accid": self.teamId
                              };
        
        _QRCodeResult = [dic mj_JSONString];
    }
    return _QRCodeResult;
}

@end