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
        _yoloID = @"Yolo用户";
    }
    return _yoloID;
}

@end

@implementation YZHUserGroupTagModel


@end

@implementation YZHUserCustomTagModel


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
    } else {
        //TODO: 空处理.
        userInfoExtManage = [[YZHUserInfoExtManage alloc] init];
    }
    return userInfoExtManage;
}

+ (instancetype)targetUserInfoExtWithUserId:(NSString *)userId {
    
    NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    YZHUserInfoExtManage* userInfoExtManage;
    if (YZHIsString(user.userInfo.ext)) {
        userInfoExtManage = [YZHUserInfoExtManage YZH_objectWithKeyValues:user.userInfo.ext];
    } else {
        [self updateUserWithUserId:userId];
    }
    
    return userInfoExtManage;
}

+ (void)updateUserWithUserId:(NSString *)userId {
    
    [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        [self targetUserInfoExtWithUserId:userId];
    }];
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"place": @"area",
             @"privateSetting": @"privacySetting"
             };
}

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"customTags": [YZHUserCustomTagModel class],
             @"groupTags": [YZHUserGroupTagModel class]
             };
}

- (NSString *)userInfoExtString {
    
    return [self mj_JSONString];
}

- (NSArray<YZHUserGroupTagModel *> *)groupTags {
    
    if (_groupTags == 0) {
        
        NSArray* tagNameArray = @[@"工作群", @"亲人群", @"朋友群"
                                  ];
        NSMutableArray* groupTagModel = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 3; i++) {
            YZHUserGroupTagModel* defaultModel = [[YZHUserGroupTagModel alloc] init];
            defaultModel.isDefault = YES;
            defaultModel.tagName = tagNameArray[i];
            [groupTagModel addObject:defaultModel];
        }
        _groupTags = groupTagModel.copy;
    }
    return _groupTags;
}

- (NSArray<YZHUserCustomTagModel *> *)customTags {
    
    if (_customTags.count == 0) {
        
        NSArray* tagNameArray = @[@"☆标好友", @"家人", @"同事"
                                  ];
        NSMutableArray* customTagModel = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 3; i++) {
            YZHUserGroupTagModel* defaultModel = [[YZHUserGroupTagModel alloc] init];
            defaultModel.isDefault = YES;
            defaultModel.tagName = tagNameArray[i];
            [customTagModel addObject:defaultModel];
        }
        _customTags = customTagModel.copy;
    }
    return _customTags;
}

- (NSString *)qrCode {
    
    if (!_qrCode) {
        _qrCode = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    }
    return _qrCode;
}

@end
