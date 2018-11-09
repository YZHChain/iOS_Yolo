//
//  YZHUserModelManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserModelManage.h"

@implementation YZHUserYoloModel

- (NSString *)yoloID {
    
    if (!_yoloID) {
        _yoloID = @"Yolo";
    }
    return _yoloID;
}

@end

@implementation YZHUserGroupTagsModel


@end

@implementation YZHUserCustomTagsModel


@end

@implementation YZHUserPlaceModel


@end

@implementation YZHUserPrivateSettingModel


@end

@implementation YZHUserInfoExtManage

//- (instancetype)init {
//
//    self = [super init];
//    if (self) {
//        NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
//        if (YZHIsString(user.userInfo.ext)) {
//            self = [YZHUserInfoExtManage YZH_objectWithKeyValues:user.userInfo.ext];
//        }
//    }
//    return self;
//}

+ (instancetype)currentUserInfoExt {

    NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    YZHUserInfoExtManage* userInfoExtManage;
    if (YZHIsString(user.userInfo.ext)) {
        userInfoExtManage = [YZHUserInfoExtManage YZH_objectWithKeyValues:user.userInfo.ext];
    };
    return userInfoExtManage;
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"place": @"area",
             @"privateSetting": @"privacySetting"
             };
}

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"customTags": [YZHUserCustomTagsModel class],
             @"groupTags": [YZHUserGroupTagsModel class]
             };
}

- (NSString *)userInfoExtString {
    
    return [self mj_JSONString];
}

@end
