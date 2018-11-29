//
//  YZHTeamNoticeModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeModel.h"

@implementation YZHTeamNoticeModel

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"sendTime": @"createTime",
             @"announcement": @"noticeContent",
             @"noticeId": @"id",
             };
}

@end

@implementation YZHTeamNoticeList

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"noticeArray": @"list"
             };
}

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"noticeArray": [YZHTeamNoticeModel class]
             };
}

@end
