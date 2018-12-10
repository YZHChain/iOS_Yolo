//
//  YZHSearchModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchModel.h"

@implementation YZHSearchModel

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"teamId": @"tId",
             @"teamName": @"tName",
             @"teamIcon": @"tIcon"
             };
}

@end

@implementation YZHSearchListModel

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"recommendArray": [YZHSearchModel class],
             @"searchArray": [YZHSearchModel class]
             };
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"recommendArray": @"beans",
             @"searchArray": @"beans"
             };
}


@end
