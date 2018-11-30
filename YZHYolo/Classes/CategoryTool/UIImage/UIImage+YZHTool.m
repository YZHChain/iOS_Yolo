//
//  UIImage+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIImage+YZHTool.h"
#import "YZHAlertManage.h"

@implementation UIImage (YZHTool)

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color{
    
   CGSize size = CGSizeMake(1.0f, 1.0f);
   return [self yzh_getImageWithColor:color withSize:size];
    
}

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color withSize:(CGSize)size{
    
    if (size.width == 0 || size.height == 0) {
        CGSize defaultSize = CGSizeMake(100, 100);
        size = defaultSize;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

// 扫描二维码图形
+ (NSArray<CIFeature *> *)yzh_readQRCodeFromImage:(UIImage *)image successfulBlock:(_Nullable readQRCodeComplete)successfulBlock {
    // 创建一个CIImage对象
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    // 二维码识别
    // 注意这里的CIDetectorTypeQRCode
    NSArray<CIFeature *> *features = [detector featuresInImage:ciImage];
    // 识别后的结果集,默认读取第一个
    if ([features.firstObject isKindOfClass:[CIQRCodeFeature class]]) {
        successfulBlock ? successfulBlock(features.firstObject) : NULL;
    } else {
        [YZHAlertManage showAlertMessage:@"暂无法识别此类型二维码"];
    }
    
    return features;
}
//TODO
//- (void)yzh_loadImageFinished:(UIImage *)image completionTarget:(id)completionTarget
//{
//    UIImageWriteToSavedPhotosAlbum(image, completionTarget, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)completionTarget);
//}

@end
