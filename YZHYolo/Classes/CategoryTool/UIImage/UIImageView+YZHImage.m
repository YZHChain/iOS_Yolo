//
//  UIImageView+YZHImage.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIImageView+YZHImage.h"

#import "UIImageView+WebCache.h"
#import "UIImageView+CornerRadius.h"

@implementation UIImageView (YZHImage)

- (void)yzh_setImageWithString:(NSString *)aString
{
    [self yzh_setImageWithString:aString placeholder:nil];
}

- (void)yzh_setImageWithString:(NSString *)aString placeholder:(NSString * __nullable)placeholder
{
    UIImage *placeholderImage;
    if (placeholder.length) {
        placeholderImage = [UIImage imageNamed:placeholder];
    }
    NSURL *url = [NSURL URLWithString:aString];
    //加载本地图片
    if (url == nil || url.scheme.length == 0 || [url.scheme isEqualToString:@"yzhYolo"]) {
        NSString *imageName = [[aString componentsSeparatedByString:@"://"] lastObject];
        if ([UIImage imageNamed:imageName] == nil) {
            [self setImage:placeholderImage];
        } else {
            [self setImage:[UIImage imageNamed:imageName]];
        }
    }
    //加载网络图片
    else {
        [self sd_setImageWithURL:url placeholderImage:placeholderImage];
    }
}

- (void)yzh_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    
    UIImage* currentImage = self.image;
    [self zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType];
    self.image = currentImage;
}

@end
