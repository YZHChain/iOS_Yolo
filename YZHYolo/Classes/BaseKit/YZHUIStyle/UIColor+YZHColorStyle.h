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
+ (UIColor *)yzh_separatorLightGray;  // 分割线浅灰色;
+ (UIColor *)yzh_fontShallowBlack;   //  常用字体浅黑色;
+ (UIColor *)yzh_buttonBackgroundGreen; // 常用按钮背景绿
+ (UIColor *)yzh_buttonBackgroundRed;  //  按钮背景红

@end
