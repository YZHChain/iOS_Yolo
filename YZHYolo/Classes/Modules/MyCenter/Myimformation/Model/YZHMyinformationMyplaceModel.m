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

- (void)checkoutUserPlaceData {
    
    //判断当前User 扩展字段查询是否有历史记录.
    if (YZHIsString(self.userPlaceModel.complete)) {
        //如果有地址位置记录,则分两种情况.
        if (self.userPlaceModel.isFacilityLocation) {
            [self facilityLocationTypeWithSortCountries];
        } else {
            //位置是在列表中选择的.
            [self selectedPlaceTypeWithSortCountries];
        }
    } else {
        //如果无记录则直接读取默认列表即可;
        self.sortCountries = [self.countries copy];
    }
}
// 手动选择方式保存的上次地理位置, 则以这种方式直接排序.
- (void)selectedPlaceTypeWithSortCountries {
    
    self.sortCountries = [self.countries mutableCopy];
    
    //先找上次所选国家,并将其位置调整到第一位
    if (self.userPlaceModel.selectCountry < self.countries.count) {
        //将选中位置移动到第一位;
        [self.sortCountries insertObject:self.countries[self.userPlaceModel.selectCountry] atIndex:0];
        [self.sortCountries removeObjectAtIndex:self.userPlaceModel.selectCountry + 1];
    }
    //查找省份
    if (self.userPlaceModel.selectProvince < self.sortCountries.firstObject.provinces.count && self.sortCountries.firstObject.provinces.count > 1) {
        [self.sortCountries.firstObject.provinces insertObject:self.sortCountries.firstObject.provinces[self.userPlaceModel.selectProvince] atIndex: 0];
        [self.sortCountries.firstObject.provinces removeObjectAtIndex: self.userPlaceModel.selectProvince + 1];
    }
    if (self.userPlaceModel.selectCity < self.sortCountries.firstObject.provinces.firstObject.citys.count && self.sortCountries.firstObject.provinces.firstObject.citys.count > 1) {
        [self.sortCountries.firstObject.provinces.firstObject.citys insertObject:self.sortCountries.firstObject.provinces.firstObject.citys[self.userPlaceModel.selectCity] atIndex: 0];
        [self.sortCountries.firstObject.provinces.firstObject.citys removeObjectAtIndex: self.userPlaceModel.selectCity + 1];
    }
}
// 通过定位的方式进行保存的上次地理位置, 则以这种方式来进行排序.
- (void)facilityLocationTypeWithSortCountries {
    
    //TODO: 暂时以无记录方式展示;
    self.sortCountries = [self.countries mutableCopy];
}

- (void)updataUserPlaceData {
    
    if (self.isFacilityLocation) {
        
        self.userPlaceModel.selectCountry = 0;
        self.userPlaceModel.selectProvince = 0;
        self.userPlaceModel.selectCity = 0;
        self.userPlaceModel.isFacilityLocation = self.isFacilityLocation;
        //TODO
        self.userPlaceModel.complete = self.complete;
    } else {
        //拼接地理位置
        NSMutableString* placeMutableStrig = [[NSMutableString alloc] init];
        if (self.selectCountry != 0) {
            self.userPlaceModel.selectCountry = self.selectCountry;
            self.userPlaceModel.selectProvince = self.selectProvince;
            self.userPlaceModel.selectCity = self.selectCity;
            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].name)) {
                [placeMutableStrig appendString:[NSString stringWithFormat:@"%@",self.countries[self.userPlaceModel.selectCountry].name]];
            }
            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].name)) {
                [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].name]];
            }
            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].citys[self.userPlaceModel.selectCity].name)) {
                [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].citys[self.userPlaceModel.selectCity].name]];
            }
        } else {
            self.userPlaceModel.selectCountry = self.selectCountry;
            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].name)) {
                [placeMutableStrig appendString:[NSString stringWithFormat:@"%@",self.countries[0].name]];
            }
            //省份需要校验
            if (self.selectProvince > self.userPlaceModel.selectProvince) {
                self.userPlaceModel.selectProvince = self.selectProvince;
            } else if (self.selectProvince == 0) {
                //不需要改变.
            } else {
                self.userPlaceModel.selectProvince = self.selectProvince - 1;
            }
            if (self.selectProvince == 0) {
                if (YZHIsString(self.countries[0].provinces[0].name)) {
                    [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[0].provinces[0].name]];
                }
                //省份需要校验
                if (self.selectCity > self.userPlaceModel.selectCity) {
                    self.userPlaceModel.selectCity = self.selectCity;
                } else if (self.selectCity == 0) {
                    //不需要改变.
                } else {
                    self.userPlaceModel.selectCity = self.selectCity - 1;
                }
                if (self.selectCity == 0) {
                    if (YZHIsString(self.countries[0].provinces[0].citys[0].name)) {
                        [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[0].provinces[0].citys[0].name]];
                    }
                } else {
                    if (YZHIsString(self.countries[0].provinces[0].citys[self.userPlaceModel.selectCity].name)) {
                        [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[0].provinces[0].citys[self.userPlaceModel.selectCity].name]];
                    }
                }
            } else {
                self.userPlaceModel.selectCity = self.selectCity;
                if (YZHIsString(self.countries[0].provinces[self.userPlaceModel.selectProvince].name)) {
                    [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[0].provinces[self.userPlaceModel.selectProvince].name]];
                }
                
                if (self.selectCity == 0) {
                    if (YZHIsString(self.countries[0].provinces[self.userPlaceModel.selectProvince].citys[0].name)) {
                        [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[0].provinces[self.userPlaceModel.selectProvince].citys[0].name]];
                    }
                } else {
                    if (YZHIsString(self.countries[0].provinces[self.userPlaceModel.selectProvince].citys[self.userPlaceModel.selectCity].name)) {
                        [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[0].provinces[self.userPlaceModel.selectProvince].citys[self.userPlaceModel.selectCity].name]];
                    }
                }
                
            }
        }
        //拼接地理位置
        self.userPlaceModel.complete = [placeMutableStrig copy];
        self.userPlaceModel.isFacilityLocation = self.isFacilityLocation;
//        if (self.selectCountry != self.userPlaceModel.selectCountry || self.selectProvince != self.userPlaceModel.selectProvince ||
//            self.selectCity !=
//            self.userPlaceModel.selectCity) {
//            //执行地理位置更新
//            self.userPlaceModel.selectCountry = self.selectCountry;
//            self.userPlaceModel.selectProvince = self.selectProvince;
//            self.userPlaceModel.selectCity = self.selectCity;
//            self.userPlaceModel.isFacilityLocation = self.isFacilityLocation;
//            //拼接地理位置
//            NSMutableString* placeMutableStrig = [[NSMutableString alloc] init];
//            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].name)) {
//                [placeMutableStrig appendString:[NSString stringWithFormat:@"%@",self.countries[self.userPlaceModel.selectCountry].name]];
//                _jumpNumber = 2;
//            }
//            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].name)) {
//                [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].name]];
//                _jumpNumber ++;
//            }
//            if (YZHIsString(self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].citys[self.userPlaceModel.selectCity].name)) {
//                [placeMutableStrig appendString:[NSString stringWithFormat:@"·%@",self.countries[self.userPlaceModel.selectCountry].provinces[self.userPlaceModel.selectProvince].citys[self.userPlaceModel.selectCity].name]];
//                _jumpNumber ++;
//            }
//            //拼接地理位置
//            self.userPlaceModel.complete = [placeMutableStrig copy];
//        }
    }
}

#pragma mark -- Get && Set

//- (YZHUserInfoExtManage *)userInfoExt {
//    
//    if (!_userInfoExt) {
//        _userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
//    }
//    return _userInfoExt;
//}
//
//- (YZHUserPlaceModel *)userPlaceModel {
//    
//    if (!_userPlaceModel) {
//        _userPlaceModel = self.userInfoExt.place;
//    }
//    return _userPlaceModel;
//}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
        self.userPlaceModel = self.userInfoExt.place;
    }
    return self;
}

@end


