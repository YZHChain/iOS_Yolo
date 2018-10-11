//
//  YZHQRCodeManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHQRCodeManage : NSObject

@property (nonatomic, weak) id<AVCaptureMetadataOutputObjectsDelegate> metadatadelegate;

- (void)configurationVideoPreviewLayerWithScanImageView:(UIView *)scanImageView;
- (void)startScanVideo;
- (void)stopScanVideo;
- (void)startLight;
+ (BOOL)getAuthorization;

@end

NS_ASSUME_NONNULL_END
