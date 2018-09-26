//
//  UIImage+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YZHTool)

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color;
+ (UIImage *)yzh_getImageWithColor:(UIColor *)color withSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
