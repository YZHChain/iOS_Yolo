//
//  UIImage+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIImage+YZHTool.h"

@implementation UIImage (YZHTool)

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color{
    
   CGSize size = CGSizeMake(1.0f, 1.0f);
   return [self yzh_getImageWithColor:color withSize:size];
    
}

+ (UIImage *)yzh_getImageWithColor:(UIColor *)color withSize:(CGSize)size{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
