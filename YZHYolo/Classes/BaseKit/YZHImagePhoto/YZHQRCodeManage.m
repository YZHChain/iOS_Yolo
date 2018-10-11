//
//  YZHQRCodeManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHQRCodeManage.h"

@interface YZHQRCodeManage()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession* caputreSession;
@property (nonatomic, strong) AVCaptureDevice* captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput* caputerInput;
@property (nonatomic, strong) AVCaptureMetadataOutput* captureMetaOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* captureVideoLayer;
@property (nonatomic, assign) BOOL configurationComplete;

@end

@implementation YZHQRCodeManage

- (void)startScanVideo {
    
    //先配置.
    [self configurationCaputreSession];
    [self.caputreSession startRunning];
}

- (void)stopScanVideo {
    
    [self.caputreSession stopRunning];
}

#pragma mark -- Extension Function

- (void)startLight {
        //TODO:版本兼容.
        //Fallback on earlier versions
        //也可以直接用_videoDevice,但是下面这种更好
        AVCaptureDevice *captureDevice = self.captureDevice;
        NSError *error;
        BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
        if (!lockAcquired) {
            NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
        } else {
            // 检测当前设备是否支持开灯
            if ([captureDevice isTorchModeSupported:AVCaptureTorchModeOn]) {
                [self.caputreSession beginConfiguration];
                
                if (captureDevice.flashMode == AVCaptureFlashModeOff) {
                    [captureDevice setTorchMode:AVCaptureTorchModeOn];
                    [captureDevice setFlashMode:AVCaptureFlashModeOn];
                } else {
                    [captureDevice setTorchMode:AVCaptureTorchModeOff];
                    [captureDevice setFlashMode:AVCaptureFlashModeOff];
                }
                
                [captureDevice unlockForConfiguration];
                
                [self.caputreSession commitConfiguration];
                [self.caputreSession startRunning];
            } else {
              // 提示设备损坏.
            }

        }
}

-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice = self.captureDevice;
    NSError *error;
    
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [self.caputreSession beginConfiguration];
        [captureDevice unlockForConfiguration];
        propertyChange(captureDevice);
        [self.caputreSession commitConfiguration];
    }
}

#pragma mark -- configuration

- (void)configurationCaputreSession {
    
    if (self.configurationComplete == NO) {
        [self.caputreSession beginConfiguration];
        
        if ([self.caputreSession canAddInput:self.caputerInput]) {
            [self.caputreSession addInput:_caputerInput];
        }
        if ([self.caputreSession canAddOutput:self.captureMetaOutput]) {
            [self.caputreSession addOutput:_captureMetaOutput];
            // TODO: _captureMetaOutput.availableMetadataObjectTypes 为空时会抛出异常最好写个 异常捕获.当为 nil 时;
            // 这是个大坑,如果不在 CaptureSession  addoutPut 之前进行设置的话无效的,必须要等添加之后才能设置
            // 必须要等添加之后设置才有效.
            if (_captureMetaOutput.availableMetadataObjectTypes) {
                _captureMetaOutput.metadataObjectTypes = _captureMetaOutput.availableMetadataObjectTypes;
            } else {
                NSLog(@"设备不支持");
            }
            
            AVCaptureConnection *captureConnection = [_captureMetaOutput connectionWithMediaType:AVMediaTypeVideo];
            // TODO:不知道咋样才支持 -.-
            if ([captureConnection isVideoStabilizationSupported]) {
                captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
            // TODO:不知道干嘛的
            captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
        }
        [self.caputreSession commitConfiguration];
        self.configurationComplete = YES;
    }
}

- (void)configurationVideoPreviewLayerWithScanImageView:(UIView *)scanImageView {
    
    AVCaptureVideoPreviewLayer* captureVideoLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.caputreSession];
    captureVideoLayer.frame = scanImageView.layer.bounds;
    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    captureVideoLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    captureVideoLayer.position = CGPointMake(scanImageView.width * .5f ,scanImageView.height * .5f);
    
    CALayer *layer = scanImageView.layer;
    layer.masksToBounds = true;
    [layer addSublayer:captureVideoLayer];
    
    [scanImageView layoutIfNeeded];
}

#pragma mark -- Lazy Loading

- (AVCaptureSession *)caputreSession {
    
    if (!_caputreSession) {
        _caputreSession = [[AVCaptureSession alloc] init];
        if ([_caputreSession canSetSessionPreset:AVCaptureSessionPresetInputPriority]) {
            [_caputreSession setSessionPreset:AVCaptureSessionPresetInputPriority];
        }
    }
    return _caputreSession;
}

- (AVCaptureDevice *)captureDevice {
    
    if (!_captureDevice) {
        // 方法二
//        NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
//        AVCaptureDevice *captureDevice = devices.firstObject;
//        
//        for (AVCaptureDevice *device in devices ) {
//            if (device.position == position) {
//                captureDevice = device;
//                break;
//            }
//        }
        //TODO: 设备配置.
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

- (AVCaptureDeviceInput *)caputerInput {
    
    if (!_caputerInput) {
        NSError* error;
        _caputerInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
        if (error) {
            //TODO: 输入源创建失败.可能是设备原因.
        }
    }
    return _caputerInput;
}

- (AVCaptureMetadataOutput *)captureMetaOutput {
    
    if (!_captureMetaOutput) {
        _captureMetaOutput = [[AVCaptureMetadataOutput alloc] init];
        if (self.metadatadelegate) {
            // TODO:线程
            [_captureMetaOutput setMetadataObjectsDelegate:self.metadatadelegate queue:dispatch_get_main_queue()];
        }
    }
    return _captureMetaOutput;
}

+ (BOOL)getAuthorization {
    //此处获取摄像头授权
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
        {
            return YES;
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        {
            __block BOOL succeed;
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                succeed = granted;
                if(granted){    //用户授权成功
                    return;
                } else {        //用户拒绝授权
                    return;
                }
            }];
            return succeed;
            break;
        }
        default:                                    //用户拒绝授权/未授权
        {
            return NO;
            break;
        }
    }
}

@end
