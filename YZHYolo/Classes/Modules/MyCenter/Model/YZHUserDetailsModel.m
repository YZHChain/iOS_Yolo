//
//  YZHUserDetailsModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserDetailsModel.h"

#import "YZHUserModelManage.h"
@implementation YZHUserDetailsModel

- (BOOL )hasPhotoImage {
    
    if (YZHIsString(self.userIMData.userInfo.avatarUrl)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)hasNickName {
    
    if (YZHIsString(self.userIMData.userInfo.nickName)) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)yoloID {
    
    if (self.userInfoExt) {
        if (YZHIsString(_userInfoExt.userYolo.yoloID)) {
            _yoloID = _userInfoExt.userYolo.yoloID;
        } else {
            _yoloID = @"YOLO默认用户";
        }
    } else {
            _yoloID = @"YOLO默认用户";
    }
    return _yoloID;
}

- (YZHUserInfoExtManage *)userInfoExt {
    
    _userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    return _userInfoExt;
}

@end
