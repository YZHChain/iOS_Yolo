//
//  UIColor+YZHColorStyle.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YZHColorStyle)

+ (UIColor *)yzh_colorWithHexString:(NSString *)color; //颜色字符串转换为颜色
+ (UIColor *)yzh_backgroundDarkBlue; // 常用主题深蓝色;
+ (UIColor *)yzh_backgroundThemeGray; //  常用主题灰色;


@end
