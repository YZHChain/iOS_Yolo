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
                            @"image": @"tabBar_community_default",
                            @"selectedImage":  @"tabBar_community_selected",
                            @"color": @"#8E8E8E",
                            @"selectedColor": @"#00BACB",
                            },
                          @{
                            @"image": @"tabBar_chat_default",
                            @"selectedImage":  @"tabBar_chat_selected",
                            @"color": @"#8E8E8E",
                            @"selectedColor": @"#00BACB",
                            },
                          @{
                            @"image": @"tabBar_address_default",
                            @"selectedImage":  @"tabBar_address_selected",
                            @"color": @"#8E8E8E",
                            @"selectedColor": @"#00BACB",
                            },
                          @{
                            @"image": @"tabBar_discover_default",
                            @"selectedImage":  @"tabBar_discover_selected",
                            @"color": @"#8E8E8E",
                            @"selectedColor": @"#00BACB",
                            },
                            @{
                            @"image": @"tabBar_mycenter_default",
                            @"selectedImage":  @"tabBar_mycenter_selected",
                            @"color": @"#8E8E8E",
                            @"selectedColor": @"#00BACB",},];
    
    return themeArray;
    
}

- (NSArray<YZHThemeItemModel *> *)themeitems{
    
    if (_themeitems == nil) {
        
        _themeitems = [YZHThemeItemModel YZH_objectArrayWithKeyValuesArray:[self defaultTheme]];
    }
    return _themeitems;
}

@end
