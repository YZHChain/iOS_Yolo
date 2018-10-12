//
//  YZHMyInformationModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationModel.h"

@implementation YZHMyInformationModel

@end


@implementation YZHMyInformationContentModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"content": @"YZHMyInformationModel"
             };
}

@end

@implementation YZHMyInformationListModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"content": @"YZHMyInformationContentModel"
                 };
}

- (NSMutableArray<YZHMyInformationContentModel *> *)list {
    
    if (!_list) {
        NSArray* list = @[
                          @{@"content": @[@{
                                              @"title":@"手机号",
                                              @"subtitle":@"18574352255",
                                              @"image":@"",
                                              @"route":@"",
                                              @"cellType" :@"0",
                                    }]},
                          @{@"content": @[@{
                                              @"title":@"头像",
                                              @"subtitle":@"",
                                              @"image":@"my_myinformationCell_headPhoto_default",
                                              @"route":kYZHRouterMyInformationPhoto,
                                              @"cellType" :@"1",
                                              }
                                          ]},
                          @{@"content": @[@{
                                              @"title":@"昵称",
                                              @"subtitle":@"",
                                              @"image":@"my_cover_cell_about",
                                              @"route":kYZHRouterMyInformationSetName,
                                              @"cellType" :@"2",
                                              },@{
                                              @"title":@"YOLO 号",
                                              @"subtitle":@"8855842",
                                              @"image":@"my_cover_cell_about",
                                              @"route":kYZHRouterMyInformationYoloID,
                                              @"cellType" :@"2",
                                              }]},
                          @{@"content": @[@{
                                              @"title":@"性别",
                                              @"subtitle":@"女",
                                              @"image":@"my_informationCell_gender_girl",
                                              @"route":kYZHRouterMyInformationSetGender,
                                              @"cellType" :@"3",
                                              },@{
                                              @"title":@"地区",
                                              @"subtitle":@"中国,上海",
                                              @"image":@"my_cover_cell_about",
                                              @"route":kYZHRouterMyInformationMyPlace,
                                              @"cellType" :@"2",
                                              }]},
                          @{@"content": @[@{
                                              @"title":@"我的二维码",
                                              @"subtitle":@"",
                                              @"image":@"my_informationCell_QRCode",
                                              @"route":kYZHRouterMyInformationMyQRCode,
                                              @"cellType" :@"4",
                                              }]},
                          ];
        _list = [YZHMyInformationContentModel YZH_objectArrayWithKeyValuesArray:list];
    }
    return _list;
}

@end
