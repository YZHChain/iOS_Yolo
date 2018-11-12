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
    if (YZHIsString(user.ext)) {
        userExtManage = [YZHTargetUserExtManage YZH_objectWithKeyValues:user.ext];
    }

    
    return userExtManage;
}

@end
