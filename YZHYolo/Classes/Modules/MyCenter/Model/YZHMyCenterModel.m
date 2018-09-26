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
             @"content": @"YZHMyCenterModel"
             };
}

@end

@implementation YZHMyCenterListModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"list": @"YZHMyCenterContentModel"
             };
}

@end
