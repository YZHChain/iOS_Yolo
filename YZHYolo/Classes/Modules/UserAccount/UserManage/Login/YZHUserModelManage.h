//
//  YZHUserModelManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHUserYoloModel : NSObject

@property (nonatomic, assign) NSInteger hasSetting;
@property (nonatomic, copy) NSString* yoloID;

@end

@interface YZHUserGroupTagModel : NSObject

@property (nonatomic, copy) NSString* tagName;
@property (nonatomic, assign) BOOL isDefault;

@end

@interface YZHUserPlaceModel : NSObject

@property (nonatomic, assign) NSInteger selectCity;
@property (nonatomic, assign) NSInteger selectProvince;
@property (nonatomic, assign) NSInteger selectCountry;
@property (nonatomic, copy) NSString* complete;
@property (nonatomic, assign) BOOL isFacilityLocation;

@end

@interface YZHUserCustomTagModel : NSObject

@property (nonatomic, copy) NSString* tagName;
@property (nonatomic, assign) BOOL isDefault;

@end

@interface YZHUserPrivateSettingModel : NSObject

@property (nonatomic, assign) BOOL allowAdd;
@property (nonatomic, assign) BOOL addVerify;
@property (nonatomic, assign) BOOL allowPhoneAdd;
@property (nonatomic, copy) NSString* groupPassword;

@end

@interface YZHUserInfoExtManage : NSObject

@property (nonatomic, strong) YZHUserPlaceModel* place;
@property (nonatomic, strong) NSArray<YZHUserCustomTagModel* > *customTags;
@property (nonatomic, strong) NSArray<YZHUserGroupTagModel* > *groupTags;
@property (nonatomic, strong) YZHUserYoloModel* userYolo;
@property (nonatomic, strong) YZHUserPrivateSettingModel* privateSetting;
@property (nonatomic, copy) NSString* qrCode;

+ (instancetype)currentUserInfoExt;
+ (instancetype)targetUserInfoExtWithUserId:(NSString* )userId;
- (NSString* )userInfoExtString;

@end

NS_ASSUME_NONNULL_END
