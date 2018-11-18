//
//  UIButton+CollectionCellStyle.m
//  CollectionViewClassifyMenu
//
//  Created by https://github.com/ChenYilong on 15/4 / 2.
//  Copyright (c)  http://weibo.com/luohanchenyilong/ . All rights reserved.
//

#import "UIButton+CollectionCellStyle.h"
#import "CYLParameterConfiguration.h"
#import "UIImage+YZHTool.h"

@implementation UIButton (CollectionCellStyle)

- (void)cyl_generalStyle {
    self.layer.cornerRadius = 2.0;
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)cyl_homeStyle {
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    [self setTitleColor:[UIColor yzh_backgroundThemeGray] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    UIImage *imageHighlighted = [[self class] cyl_imageWithColor:[UIColor colorWithRed:18 / 255.0 green:133 / 255.0 blue:117 / 255.0 alpha:1]];
    [self setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
//    self.layer.borderColor = [UIColor colorWithRed:18 / 255.0 green:133 / 255.0 blue:117 / 255.0 alpha:1].CGColor;
}

- (void)cyl_redStyle {
    self.titleLabel.font = CYLTagTitleFont;
    [self setTitleColor:[UIColor colorWithRed:160 / 255.0 green:15 / 255.0 blue:85 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    UIImage *imageHighlighted  = [[self class] cyl_imageWithColor:[UIColor colorWithRed:18 / 255.0 green:133 / 255.0 blue:117 / 255.0 alpha:1]];
    [self setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
    self.layer.borderColor = [UIColor colorWithRed:160 / 255.0 green:15 / 255.0 blue:85 / 255.0 alpha:1].CGColor;
}

- (void)cyl_chengNiStyle {
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = YES;
    UIImage *imageNormal = [[self class] cyl_imageWithColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1]];
    [self setBackgroundImage:imageNormal forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont yzh_commonStyleWithFontSize:13];
    [self setTitleColor:[UIColor yzh_sessionCellGray] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    UIImage *imageHighlighted  = [UIImage yzh_getImageWithColor:YZHColorRGBAWithRGBA(0, 186, 203, 1)];
    
    [self setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
    [self setBackgroundImage:imageHighlighted forState:UIControlStateSelected];
}

+ (UIImage *)cyl_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
