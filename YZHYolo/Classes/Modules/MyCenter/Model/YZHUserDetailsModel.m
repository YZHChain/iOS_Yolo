//
//  YZHUserDetailsModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserDetailsModel.h"

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

@end
