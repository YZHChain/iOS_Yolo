//
//  YZHTabBarModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTabBarModel.h"
#import "YZHPublic.h"
#import "YZHThemeManage.h"

@implementation YZHTabBarModel

@end

@implementation YZHTabBarItems

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"itemsModel": [YZHTabBarModel class]
             };
}

- (NSArray* )defaultItems{
    
    YZHThemeManage* themeManage = [[YZHThemeManage alloc] init];
    NSArray* itemsArray = @[@{@"title": @"社群",
                              @"viewController": @"YZHCommunityVC",
                              @"hasNavigation": @"1",
                              @"image": themeManage.themeitems[0].image,
                              @"selectedImage": themeManage.themeitems[0].selectedImage,
                              @"color": themeManage.themeitems[0].color,
                              @"selectedColor": themeManage.themeitems[0].selectedColor,
                              },
                            @{@"title": @"会话",
                              @"viewController": @"YZHPrivatelyChatVC",
                              @"hasNavigation": @"1",
                              @"image": themeManage.themeitems[1].image,
                              @"selectedImage": themeManage.themeitems[1].selectedImage,
                              @"color": themeManage.themeitems[1].color,
                              @"selectedColor": themeManage.themeitems[1].selectedColor,
                              },
                            @{@"title": @"通讯录",
                              @"viewController": @"YZHAddressVC",
                              @"hasNavigation": @"1",
                              @"image": themeManage.themeitems[2].image,
                              @"selectedImage": themeManage.themeitems[2].selectedImage,
                              @"color": themeManage.themeitems[2].color,
                              @"selectedColor": themeManage.themeitems[2].selectedColor,
                              },
                            @{@"title": @"广场",
                              @"viewController": @"YZHDiscoverVC",
                              @"hasNavigation": @"1",
                              @"image": themeManage.themeitems[3].image,
                              @"selectedImage": themeManage.themeitems[3].selectedImage,
                              @"color": themeManage.themeitems[3].color,
                              @"selectedColor": themeManage.themeitems[3].selectedColor,
                              },
                            @{@"title": @"我的",
                              @"viewController": @"YZHMyCenterVC",
                              @"hasNavigation": @"1",
                              @"image": themeManage.themeitems[4].image,
                              @"selectedImage": themeManage.themeitems[4].selectedImage,
                              @"color": themeManage.themeitems[4].color,
                              @"selectedColor": themeManage.themeitems[4].selectedColor,
                              },];
    
    return itemsArray;
}


#pragma mark -- GET&&SET

- (NSArray<YZHTabBarModel *> *)itemsModel{
    if (_itemsModel == nil) {
        _itemsModel =  [YZHTabBarModel YZH_objectArrayWithKeyValuesArray: [self defaultItems]];
    }
    return _itemsModel;
}

@end


