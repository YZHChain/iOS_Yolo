//
//  UIImage+YZHImage.h
//  yzhHYolo
//
//  Created by Jersey on 2018/10/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YZHImage)

+ (UIImage *)yzh_imageWithString:(NSString *)aString;
+ (UIImage *)yzh_imageWithString:(NSString *)aString size:(CGSize)size;
+ (UIImage *)yzh_imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)yzh_imageForTabBarItem;
- (UIImage *)yzh_imageForTabBarBackground;
- (UIImage *)yzh_imageForNavBarBackground;

@end

NS_ASSUME_NONNULL_END
