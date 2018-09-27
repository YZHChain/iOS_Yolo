//
//  YZHMyinformationMyplaceModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyinformationMyplaceModel.h"

@implementation YZHLocationCityModel

+ (NSDictionary *)YZH_replacedKeyFromPropertyName{
    
    return @{
             @"name": @"Name"
             };
}

@end

@implementation YZHLocationProvinceModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"citys": @"YZHLocationCityModel"
             };
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName{
    
    return @{
             @"name": @"Name",
             @"citys": @"City",
             };
}

@end

@implementation YZHLocationCountrieModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"provinces": @"YZHLocationProvinceModel"
             };
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName{
    
    return @{
             @"name": @"Name",
             @"provinces": @"State",
             };
}

@end

@implementation YZHLocationWorldModel

+ (NSDictionary *)YZH_objectClassInArray{
    
    return @{
             @"countries": @"YZHLocationCountrieModel"
             };
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName{
    
    return @{
             @"countries": @"CountryRegion"
             };
}

@end


