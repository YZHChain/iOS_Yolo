//
//  YZHThemeItemModel.m
//  YZHYolo
//
//  Created by 😘王艳 on 2018/9/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHThemeItemModel.h"

@implementation YZHThemeItemModel

#pragma mark - GET & SET

- (NSString *)color {
    return _color ? _color : @"#a4aab3";
}

- (NSString *)selectColor {
    return _selectedColor ? _selectedColor : @"#ef5853";
}

@end
