//
//  UIImage+YZHImage.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIImage+YZHImage.h"

@implementation UIImage (YZHImage)

+ (UIImage *)yzh_imageWithString:(NSString *)aString
{
    if (aString.length == 0) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:aString];
    //加载本地图片
    if (url==nil || url.scheme.length==0 || [url.scheme isEqualToString:@"yeamoney"]) {
        NSString *imageName = [[aString componentsSeparatedByString:@"://"] lastObject];
        return [UIImage imageNamed:imageName];
    }
    //加载网络图片
    else {
        return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:aString];
    }
}

+ (UIImage *)yzh_imageWithString:(NSString *)aString size:(CGSize)size
{
    return [[UIImage yzh_imageWithString:aString] yzh_imageScaledToSize:size];
}

- (UIImage *)yzh_imageForTabBarItem
{
    CGFloat normalWidth = 25; //标准宽高
    CGFloat maxWidth = normalWidth * 3; //最大宽高
    
    UIImage *image = self;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    //宽高过大时缩放到最大宽高
    if (width>maxWidth || height>maxWidth) {
        CGFloat scale = maxWidth / (width>height ? width : height);
        image = [image yzh_imageScaledToSize:CGSizeMake(width*scale, height*scale)];
    }
    
    width = image.size.width;
    height = image.size.height;
    CGFloat addHeight = height - normalWidth;
    //高大于标准宽高时，生成上移后的图片，防止遮挡住UITabBarItem的文字
    if (addHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height + addHeight), NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, width, height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (UIImage *)yzh_imageForTabBarBackground
{
    CGFloat normalHeight = 49; //标准高
    CGFloat normalWidth = [UIScreen mainScreen].bounds.size.width; //标准宽
    CGFloat maxHeight = normalHeight * 2; //最大高
    
    CGFloat height = self.size.height;
    CGFloat scaleHeight = height;
    //高过大或过小
    if (height > maxHeight) {
        scaleHeight = maxHeight;
    } else if (height < normalHeight) {
        scaleHeight = normalHeight;
    }
    //生成图片
    UIImage *image = [self yzh_imageScaleAspectFillToSize:CGSizeMake(normalWidth, scaleHeight)];
    
    return image;
}

- (UIImage *)yzh_imageForNavBarBackground
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 64;
    UIImage *image = [self yzh_imageScaleAspectFillToSize:CGSizeMake(width, height)];
    
    return image;
}

#pragma mark - Private Method

- (UIImage *)yzh_imageScaleAspectFillToSize:(CGSize)size
{
    UIImage *image = self;
    CGFloat ratio = image.size.width / image.size.height;
    CGFloat toRatio = size.width / size.height;
    CGFloat scaleWidth = size.width;
    CGFloat scaleHeight = size.height;
    //长宽比例不等
    if (ratio > toRatio) {
        scaleWidth = scaleHeight * ratio;
    } else if (ratio < toRatio) {
        scaleHeight = scaleWidth / ratio;
    }
    //生成图片
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGRect rect = CGRectMake((size.width-scaleWidth)/2, (size.height-scaleHeight)/2, scaleWidth, scaleHeight);
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)yzh_imageScaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)yzh_imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

