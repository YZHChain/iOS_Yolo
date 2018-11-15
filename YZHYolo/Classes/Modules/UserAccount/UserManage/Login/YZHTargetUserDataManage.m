//
//  YZHTargetUserDataManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTargetUserDataManage.h"

@implementation YZHTargetUserExtManage

+ (instancetype)targetUserExtWithUserId:(NSString *)userId {
    
    NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    YZHTargetUserExtManage* userExtManage = [[self alloc] init];
    //非好友关系时需要,需要拉取最新.
    if (YZHIsString(user.ext)) {
        userExtManage = [YZHTargetUserExtManage YZH_objectWithKeyValues:user.ext];
    } else {
        if (!user.userInfo) {
            [[[NIMSDK sharedSDK] userManager] fetchUserInfos:@[userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
                if (!error) {
                    [self targetUserExtWithUserId:userId];
                }
            }];
        }
    }
    
    return userExtManage;
}

@end
