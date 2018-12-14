//
//  UIColor+YZHColorStyle.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIColor+YZHColorStyle.h"

@implementation UIColor (YZHColorStyle)

+ (UIColor *)yzh_backgroundDarkBlue {
    
    return [UIColor colorWithRed: 0.0/ 255.0f green: 19.0/ 255.0f blue: 51.0/ 255.0f alpha:1.0f];
}

+ (UIColor *)yzh_backgroundThemeGray {
    
    return [UIColor colorWithRed: 239.0/ 255.0f green: 239.0/ 255.0f blue: 239.0/ 255.0f alpha: 1.0f];
}

+ (UIColor *)yzh_separatorLightGray {
    
    return [UIColor colorWithRed: 193.0/ 255.0f green: 193.0/ 255.0f blue: 193.0/ 255.0f alpha: 1.0f];
}

+ (UIColor *)yzh_fontShallowBlack {
    
    return [UIColor colorWithRed: 62.0/ 255.0f green: 58.0/ 255.0f blue: 57.0/ 255.0f alpha: 1.0f];
}

+ (UIColor *)yzh_fontThemeBlue {
    
    return [UIColor colorWithRed: 0.0/ 255.0f green: 186.0/ 255.0f blue: 203.0/ 255.0f alpha: 1.0f];
}

+ (UIColor *)yzh_buttonBackgroundGreen {
    
    return [UIColor colorWithRed: 42.0/ 255.0f green: 107.0/ 255.0f blue: 250.0/ 255.0f alpha: 1.0f];
}

+ (UIColor *)yzh_buttonBackgroundRed {
    
    return [UIColor colorWithRed: 227/255.0 green: 41/255.0 blue: 63/255.0 alpha: 1];
}

+ (UIColor *)yzh_buttonBackgroundPinkRed {
    
    return [UIColor colorWithRed: 255/255.0 green: 94/255.0 blue: 134/255.0 alpha: 1];
}

+(UIColor *)yzh_sessionCellGray {
    
    return [UIColor colorWithRed: 142/255.0 green: 142/255.0 blue: 142/255.0 alpha:1];
}

+(UIColor *)yzh_sessionCellBackgroundGray {
    
    return [UIColor colorWithRed: 249/255.0 green: 249/255.0 blue: 249/255.0 alpha:1];
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)yzh_setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    // CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    //  https://juejin.im/post/5a30f53e51882554b8378b0b
    gradientLayer.colors = @[(__bridge id)[UIColor yzh_colorWithHexString:fromHexColorStr].CGColor,(__bridge id)[UIColor yzh_colorWithHexString:toHexColorStr].CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1, 1);
    
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1, 1);
//
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1, 0);
    
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}


//十六进制颜色转换
+ (UIColor *)yzh_colorWithHexString:(NSString *)color
{
    //需要先判断color是否为空或null
    if (color == nil || color == NULL) {
        return [UIColor clearColor];;
    }
    if ([color isKindOfClass:[NSNull class]]) {
        return [UIColor clearColor];;
    }
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
