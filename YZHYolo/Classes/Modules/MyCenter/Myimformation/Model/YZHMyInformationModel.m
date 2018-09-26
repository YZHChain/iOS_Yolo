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
             @"list": @"YZHMyInformationContentModel"
                 };
}

@end
