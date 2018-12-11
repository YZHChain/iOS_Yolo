//
//  YZHAboutYoloModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAboutYoloModel.h"

@implementation YZHAboutYoloModel

@end

@implementation YZHAboutYoloContentModel

+ (NSDictionary *)YZH_objectClassInArray {
    return @{
             @"content" : @"YZHAboutYoloModel"
             };
}

@end

@implementation YZHAboutYoloListModel

+ (NSDictionary *)YZH_objectClassInArray {
    return @{
             @"content" : @"YZHAboutYoloModel"
             };
}


- (NSArray<YZHAboutYoloContentModel *> *)list {
    
    if (!_list) {
        NSString* version = @"v1.0.0";
        NSArray* contenArray = @[
                                 @{@"content": @[@{@"title": @"关于YOLO",
                                                   @"subtitle":@"",
                                                   @"route": @"YZHAboutYoloWebVC"
                                                   },
                                                 @{@"title": @"当前版本",
                                                   @"subtitle":version,
                                                   @"route": @""
                                                   
                                                   }]},
                                 @{@"content": @[@{@"title": @"特色介绍",
                                                   @"subtitle":@"",
                                                   @"route": @"YZHAboutCharacteristicVC"
                                                   
                                                   },
                                                 @{@"title": @"常见问题",
                                                   @"subtitle":@"",
                                                   @"route": @"YZHAboutCommonVC"
                                                   
                                                   }],},
                                 @{@"content": @[@{@"title": @"投诉反馈",
                                                   @"subtitle":@"",
                                                   @"route": @"YZHAboutFeedBackVC"
                                                   
                                                   },],}
                                 ];
        _list = [YZHAboutYoloContentModel YZH_objectArrayWithKeyValuesArray:contenArray];
        
    }
    return _list;
}

@end

