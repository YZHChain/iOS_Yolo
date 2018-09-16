//
//  YZHThemeManage.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHThemeManage.h"

@implementation YZHThemeManage

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"themeitems": [YZHThemeItemModel class]
             };
}

- (NSArray* )defaultTheme{
    
    NSArray* themeArray = @[@{
                            @"image": @"image",
                            @"selectedImage":  @"image",
                            @"color": @"#a4aab3",
                            @"selectedColor": @"#a4aab3",
                            },
                          @{
                            @"image": @"image",
                            @"selectedImage":  @"image",
                            @"color": @"#a4aab3",
                            @"selectedColor": @"#a4aab3",
                            },
                          @{
                            @"image": @"image",
                            @"selectedImage":  @"image",
                            @"color": @"#a4aab3",
                            @"selectedColor": @"#a4aab3",
                            },
                          @{
                            @"image": @"image",
                            @"selectedImage":  @"image",
                            @"color": @"#a4aab3",
                            @"selectedColor": @"#a4aab3",
                            },
                            @{
                            @"image": @"image",
                            @"selectedImage":  @"image",
                            @"color": @"#a4aab3",
                            @"selectedColor": @"#a4aab3",},];
    
    return themeArray;
    
}

- (NSArray<YZHThemeItemModel *> *)themeitems{
    
    if (_themeitems == nil) {
        
        _themeitems = [YZHThemeItemModel YZH_objectArrayWithKeyValuesArray:[self defaultTheme]];
    }
    return _themeitems;
}

@end
