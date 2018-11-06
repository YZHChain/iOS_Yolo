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

@interface YZHUserGroupTagsModel : NSObject

@property (nonatomic, copy) NSString* tagName;
@property (nonatomic, assign) BOOL isDefault;

@end

@interface YZHUserPlaceModel : NSObject

@property (nonatomic, assign) NSInteger selectCity;
@property (nonatomic, assign) NSInteger selectProvince;
@property (nonatomic, assign) NSInteger selectCountry;
@property (nonatomic, copy) NSString* complete;

@end

@interface YZHUserCustomTagsModel : NSObject

@property (nonatomic, assign) NSInteger tagName;
@property (nonatomic, copy) NSString* isDefault;

@end

@interface YZHUserInfoExtManage : NSObject

@property (nonatomic, strong) YZHUserPlaceModel* place;
@property (nonatomic, strong) NSArray<YZHUserCustomTagsModel* > *customTags;
@property (nonatomic, strong) NSArray<YZHUserGroupTagsModel* > *groupTags;
@property (nonatomic, strong) YZHUserYoloModel* userYolo;
@property (nonatomic, strong) NSString* qrCode;

+ (instancetype)currentUserInfoExt;
- (NSString* )userInfoExtString;

@end

NS_ASSUME_NONNULL_END
