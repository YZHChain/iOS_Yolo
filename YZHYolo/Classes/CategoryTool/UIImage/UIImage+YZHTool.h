//
//  UIImage+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^readQRCodeComplete)(CIFeature * feature);
@interface UIImage (YZHTool)

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color;

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color withSize:(CGSize)size;
// 扫描二维码图形
+ (NSArray<CIFeature *> *)yzh_readQRCodeFromImage:(UIImage *)image successfulBlock:(_Nullable readQRCodeComplete)successfulBlock;
@end

NS_ASSUME_NONNULL_END
