//
//  YZHScanQRCodeVC.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHScanQRCodeVC.h"

#import <AVFoundation/AVFoundation.h>
#import "YZHQRCodeManage.h"
#import "YZHPhotoManage.h"
#import "UIImage+YZHTool.h"

@interface YZHScanQRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;
@property (weak, nonatomic) IBOutlet UIButton *startLightButton;

@property (nonatomic, strong) AVCaptureSession* captureSession;
@property (nonatomic, strong) AVCaptureDevice* videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
@property (nonatomic, strong) AVCaptureMetadataOutput* movieOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* captureVideoPreviewLayer;
@property (nonatomic, strong) YZHQRCodeManage* manage;

@end

@implementation YZHScanQRCodeVC

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

- (void)dealloc {

    NSLog(@"扫描二维码成功释放了哦了哦");
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"扫码";
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    //TODO
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backPreviousPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // TODO: 封装.
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(readPhoneContact:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateHighlighted];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor yzh_backgroundThemeGray];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    if ([YZHQRCodeManage getAuthorization]) {

        YZHQRCodeManage* QRCodeManage = [[YZHQRCodeManage alloc] init];
        self.manage = QRCodeManage;
        self.manage.metadatadelegate = self;
        [QRCodeManage configurationVideoPreviewLayerWithScanImageView:self.scanImageView];
        [QRCodeManage startScanVideo];
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate


#pragma mark - 5.Event Response

- (void)backPreviousPage {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)readPhoneContact:(UIBarButtonItem *)sender {
    
    @weakify(self)
    [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
        @strongify(self)
        [self.manage stopScanVideo];
        [UIImage yzh_readQRCodeFromImage:image successfulBlock:^(CIFeature * _Nonnull feature) {
            
        }];
        self.scanImageView.image = image;
    }];
}

- (IBAction)startCameraLight:(UIButton *)sender {
    
    [self.manage startLight];
    
    sender.selected = !sender.isSelected;
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

@end
