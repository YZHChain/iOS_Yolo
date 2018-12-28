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
#import "YZHScanQRCodeMaskView.h"
#import "YZHAlertManage.h"
#import "YZHScanQRCodeModel.h"
#import "YZHDiscountVC.h"
#import "UIViewController+YZHTool.h"

@interface YZHScanQRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;
@property (weak, nonatomic) IBOutlet UIView *scanContentView;
@property (weak, nonatomic) IBOutlet UIButton *startLightButton;
@property (nonatomic, strong) YZHQRCodeManage* manage;
@property (nonatomic, strong) YZHScanQRCodeMaskView* maskView;
@property (nonatomic, strong) NSTimer* lineTimer;
@property (nonatomic, assign) BOOL startAnimation;
@property (nonatomic, assign) BOOL isSkip;

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.isSkip = NO;
    self.scanImageView.image = nil;
}

- (void)dealloc {

    NSLog(@"扫描二维码成功释放了哦了哦");
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"扫码";
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
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
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
    if ([YZHQRCodeManage getAuthorization]) {

        YZHQRCodeManage* QRCodeManage = [[YZHQRCodeManage alloc] init];
        self.manage = QRCodeManage;
        self.manage.metadatadelegate = self;
        self.photoImageView.bounds = CGRectMake(0, 0, YZHScreen_Width, YZHScreen_Height - 64);
        [QRCodeManage configurationVideoPreviewLayerWithScanImageView:self.photoImageView];
        [QRCodeManage startScanVideo];
        self.scanContentView.backgroundColor = [UIColor clearColor];
        //TODO: 待封装
        [self.scanLineImageView removeFromSuperview];
        [self.scanContentView addSubview:self.scanLineImageView];
        self.scanLineImageView.origin = CGPointMake(0, 0);
        [self.scanLineImageView sizeToFit];
        [self startScanWithLineAnimation];
//        [self.view insertSubview:self.maskView aboveSubview:self.photoImageView];
    }
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            NSString* scannedResultUTF8 = [scannedResult stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            //执行二维码跳转逻辑
            YZHScanQRCodeModel* qrCodeModel;
            if (YZHIsString(scannedResultUTF8)) {
                qrCodeModel = [YZHScanQRCodeModel YZH_objectWithKeyValues:scannedResultUTF8];
            } else {
                qrCodeModel = [YZHScanQRCodeModel YZH_objectWithKeyValues:scannedResult];
            }
            [self handleQRCodeModel:qrCodeModel];
            
            break;
        }
    }
}

#pragma mark - 5.Event Response

- (void)backPreviousPage {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)readPhoneContact:(UIBarButtonItem *)sender {
    
    @weakify(self)
    [YZHPhotoManage presentWithViewController:self sourceType:YZHImagePickerSourceTypePhotoLibrary finishPicking:^(UIImage * _Nonnull image) {
        @strongify(self)
        [UIImage yzh_readQRCodeFromImage:image successfulBlock:^(CIQRCodeFeature * _Nonnull feature) {
            @strongify(self)
            //执行二维码跳转逻辑
            //先对其进行解码
            NSString* qrCodeString = [feature.messageString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YZHScanQRCodeModel* qrCodeModel = [YZHScanQRCodeModel YZH_objectWithKeyValues:qrCodeString];
            [self handleQRCodeModel:qrCodeModel];
        }];
        self.scanImageView.image = image;
    }];
}

- (IBAction)startCameraLight:(UIButton *)sender {
    
    [self.manage startLight];
    
    sender.selected = !sender.isSelected;
}

- (void)handleQRCodeModel:(YZHScanQRCodeModel *)codeModel {
    
    if (YZHIsString(codeModel.accid)) {
        switch (codeModel.type) {
            case 0: // 用户
                if (!self.isSkip) {
                    self.isSkip = YES;
                    
                    YZHVoidBlock complection = ^ {
                        [YZHRouter openURL:kYZHRouterAddressBookDetails info:@{
                                                                               @"userId": codeModel.accid
                                                                               }];
                    };
                    [self closeQRCodeCompletion:complection];
                }
                    break;
                case 1: // 群聊
                    if (!self.isSkip) {
                        self.isSkip = YES;
                        
                        YZHVoidBlock complection = ^ {
                            [YZHRouter openURL:kYZHRouterCommunityCardIntro info:@{
                                                                                   @"teamId": codeModel.accid,
                                                                                   kYZHRouteSegue: kYZHRouteSegueModal,
                                                                                   kYZHRouteSegueNewNavigation: @(YES)
                                                                                   }];
                        };

                        [self closeQRCodeCompletion:complection];
                    }
                        break;
                    case 2:  // 支付
                    if (!self.isSkip) {
                        self.isSkip = YES;
                        YZHVoidBlock complection = ^ {
                            YZHDiscountVC* discountVC = [[YZHDiscountVC alloc] init];
                            NSString *url = [NSString stringWithFormat:@"https://yolotest.yzhchain.com/yylm-web/html/payment.html?%@", codeModel.accid];
                            discountVC.url = url;
                            [[UIViewController yzh_findTopViewController].navigationController pushViewController:discountVC animated:YES];
                        };
                        [self closeQRCodeCompletion:complection];
                        
                    }
                        break;
                    default:
                    // Value Accid 为空
                    if (!self.isSkip) {
                        self.isSkip = YES;
                        [YZHAlertManage showAlertMessage:@"暂无法识别此类型二维码"];
                        //防止多次弹框, 过 5S 之后将值修改回来. 否则无法进行其他跳转
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.isSkip = NO;
                        });
                    }
                        break;
        }
    } else {
        // Value Accid 为空
        if (!self.isSkip) {
            self.isSkip = YES;
            [YZHAlertManage showAlertMessage:@"暂无法识别此类型二维码"];
            //防止多次弹框, 过 5S 之后将值修改回来. 否则无法进行其他跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isSkip = NO;
            });
        }
    }
}


#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

#pragma mark - 7.GET & SET

- (YZHScanQRCodeMaskView *)maskView {
    
    if (!_maskView) {
        _maskView = [[YZHScanQRCodeMaskView alloc] initWithFrame:self.view.bounds];
    }
    return _maskView;
}

#pragma mark -- Line Animation

//- (NSTimer *)lineTimer {
//
//    if (!_lineTimer) {
//        _lineTimer = [NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(startScanWithLineAnimation) userInfo:nil repeats:YES];
//    }
//    return _lineTimer;
//}

- (void)startScanWithLineAnimation {
    
        CABasicAnimation* frameAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        frameAnimation.fromValue = @(self.scanLineImageView.y);
        frameAnimation.byValue = @(self.scanImageView.height / 2);
        frameAnimation.toValue = @(self.scanImageView.height);
        frameAnimation.duration = 1;
        //设置动画重复次数
        frameAnimation.repeatCount = MAXFLOAT;
        frameAnimation.autoreverses = YES;
        frameAnimation.removedOnCompletion = NO;
        //添加动画到layer
        [self.scanLineImageView.layer addAnimation:frameAnimation forKey:@"frameAnimation"];
}

- (void)stopScanWithLineAnimation {
    
    [self.scanLineImageView.layer removeAnimationForKey:@"frameAnimation"];
}

- (void)closeQRCodeCompletion:(YZHVoidBlock)completion {
    
    [self stopScanWithLineAnimation];
    [self dismissViewControllerAnimated:NO completion:^{
        completion ? completion () : NULL;
    }];
}

@end
