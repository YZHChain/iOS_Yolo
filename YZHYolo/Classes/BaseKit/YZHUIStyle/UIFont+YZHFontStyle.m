//
//  UIFont+YZHFontStyle.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

NSString* kYZHFontStyleSHSCN_Regular = @"SourceHanSansCN-Regular";
NSString* kYZHFontStyleSHSCN_Light = @"SourceHanSansCN-Light";   //细字体风格名,通过外部导入到项目中
NSString* kYZHFontStyleSHSCN_Normal = @"SourceHanSansCN-Normal"; //粗体字体风格名,通过外部导入到项目中
#import "UIFont+YZHFontStyle.h"

@implementation UIFont (YZHFontStyle)

+ (UIFont *)yzh_commonFontStyleFontSize:(CGFloat )fontSize {
    
    UIFont * font = [UIFont fontWithName:@"PingFang HK" size:fontSize];
    
    return font;
}

+ (UIFont *)yzh_commonFontStyle {
    
    UIFont * font = [UIFont fontWithName:kYZHFontStyleSHSCN_Normal size: 15];
    
    return font;
}

+ (UIFont *)yzh_commonStyleWithFontSize:(CGFloat)fontSize {
    
    UIFont* font = [UIFont fontWithName:kYZHFontStyleSHSCN_Normal size:fontSize];
    
    return font;
}

+ (UIFont *)yzh_commonLightStyleWithFontSize:(CGFloat)fontSize {
    
    UIFont* font = [UIFont fontWithName:kYZHFontStyleSHSCN_Light size:fontSize];
    
    return font;
}

+ (UIFont *)yzh_styleName:(NSString *)name fontSize:(CGFloat)size {
    
    UIFont* font = [UIFont fontWithName:name size:size];
    
    return font;
}

@end
