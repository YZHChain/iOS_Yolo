//
//  YZHAddBookFirendModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookFirendModel.h"

@implementation YZHAddBookFirendModel

@end

@implementation YZHFirendContentModel

+ (NSDictionary *)YZH_objectClassInArray{

    return @{
             @"list": [YZHAddBookFirendModel class]
             };
}


- (NSArray<YZHAddBookFirendModel *> *)list {
    
    if (!_list) {
        _list = [YZHAddBookFirendModel YZH_objectArrayWithKeyValuesArray:[self defaultList]];
    }
    return _list;
}

- (NSArray* )defaultList {
    
    NSArray* list = @[
                      @{@"title": @"扫一扫"},
                      @{@"title": @"手机联系人"},
                      @{@"title": @"搜索进群"}];
    return list;
}

@end
