//
//  YZHMyCenterModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyCenterModel.h"

@implementation YZHMyCenterModel

@end

@implementation YZHMyCenterContentModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"content": [YZHMyCenterModel class]
             };
}
@end

@implementation YZHMyCenterListModel

+ (NSDictionary *)YZH_objectClassInArray{

    return @{
             @"content": [YZHMyCenterContentModel class]
             };
}

- (NSMutableArray<YZHMyCenterContentModel *> *)list {
    
    if (!_list) {
        NSArray* list = @[@{@"content": @[@{
                                              @"title":@"我的YOLO积分",
                                              @"image":@"my_cover_cell_integral",
                                              @"route":kYZHRouterMyIntegral,
                                              @"type" :@"1",
                                              @"subtitle": @"9999",
                                              },
                                          @{
                                              @"title":@"优惠卷消费",
                                              @"image":@"my_cover_cell_discounts",
                                              @"route":kYZHRouterAboutYolo,
                                              @"type" :@"1",
                                              },
                                          @{
                                              @"title":@"便民服务",
                                              @"image":@"my_cover_cell_server",
                                              @"route":kYZHRouterAboutYolo,
                                              @"type" :@"1",
                                              }]},
                              @{@"content": @[@{
                                        @"title":@"隐私设置",
                                        @"image":@"my_cover_cell_setting_privacy",
                                        @"route":kYZHRouterPrivacySetting,
                                        @"type" :@"1",
                                        },
                               @{
                                          @"title":@"关于",
                                          @"image":@"my_cover_cell_about",
                                          @"route":kYZHRouterAboutYolo,
                                          @"type" :@"1",
                                          }]},
                                @{@"content": @[@{
                                          @"title":@"设置",
                                          @"image":@"my_cover_cell_setting",
                                          @"route":kYZHRouterSettingCenter,
                                          @"type" :@"1",
                                          }]}
                              ];
        _list = [YZHMyCenterContentModel YZH_objectArrayWithKeyValuesArray:list];
    }
    return _list;
}

@end
