//
//  YZHMyinformationMyplaceModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHLocationCityModel : NSObject

@property(nonatomic, copy)NSString* name;

@end

@interface YZHLocationProvinceModel : NSObject

@property(nonatomic, copy)NSString* name;
@property(nonatomic, strong)NSArray<YZHLocationCityModel* >* citys;

@end

@interface YZHLocationCountrieModel : NSObject

@property(nonatomic, copy)NSString* name;
@property(nonatomic, strong)NSArray<YZHLocationProvinceModel* >* provinces;

@end

@interface YZHLocationWorldModel : NSObject

@property(nonatomic, strong)NSArray<YZHLocationCountrieModel* >* countries;

@end

NS_ASSUME_NONNULL_END
