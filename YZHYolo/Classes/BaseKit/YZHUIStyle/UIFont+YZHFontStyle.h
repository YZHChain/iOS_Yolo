//
//  UIFont+YZHFontStyle.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* kYZHFontStyleSHSCN_Regular;
extern NSString* kYZHFontStyleSHSCN_Light;
extern NSString* kYZHFontStyleSHSCN_Normal;

@interface UIFont (YZHFontStyle)

+ (UIFont *)yzh_commonFontStyle;
+ (UIFont *)yzh_commonStyleWithFontSize:(CGFloat)fontSize;
+ (UIFont *)yzh_commonLightStyleWithFontSize:(CGFloat)fontSize;
+ (UIFont *)yzh_styleName:(NSString *)name fontSize:(CGFloat)size;

@end
