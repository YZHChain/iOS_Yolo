//
//  YZHMyinformationMyplaceModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHUserModelManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHLocationCityModel : NSObject

@property(nonatomic, copy)NSString* name;

@end

@interface YZHLocationProvinceModel : NSObject

@property(nonatomic, copy)NSString* name;
@property(nonatomic, strong)NSMutableArray<YZHLocationCityModel* >* citys;

@end

@interface YZHLocationCountrieModel : NSObject

@property(nonatomic, copy)NSString* name;
@property(nonatomic, strong)NSMutableArray<YZHLocationProvinceModel* >* provinces;

@end

@interface YZHLocationWorldModel : NSObject

@property (nonatomic, strong) NSMutableArray<YZHLocationCountrieModel* >* countries;
@property (nonatomic, strong) NSMutableArray<YZHLocationCountrieModel* >* sortCountries;

@property (nonatomic, assign) NSInteger selectCountry;
@property (nonatomic, assign) NSInteger selectProvince;
@property (nonatomic, assign) NSInteger selectCity;
@property (nonatomic, copy) NSString* complete;
@property (nonatomic, assign) BOOL isFacilityLocation;
@property (nonatomic, strong) YZHUserPlaceModel* userPlaceModel;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;
@property (nonatomic, assign) NSInteger jumpNumber;

- (void)checkoutUserPlaceData;
- (void)updataUserPlaceData;

@end

NS_ASSUME_NONNULL_END
