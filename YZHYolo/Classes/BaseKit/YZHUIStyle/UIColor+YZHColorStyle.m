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

+ (UIColor *)yzh_buttonBackgroundGreen {
    
    return [UIColor colorWithRed: 42.0/ 255.0f green: 107.0/ 255.0f blue: 250.0/ 255.0f alpha: 1.0f];
}

+ (UIColor *)yzh_buttonBackgroundRed {
    
    return [UIColor colorWithRed:227/255.0 green:41/255.0 blue:63/255.0 alpha:1];
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
