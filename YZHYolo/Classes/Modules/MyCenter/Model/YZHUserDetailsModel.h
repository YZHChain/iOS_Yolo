//
//  YZHUserDetailsModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/13.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHUserModelManage.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHUserDetailsModel : NSObject

@property (nonatomic, copy) NSString* yoloID;
@property (nonatomic, copy) NSString* phoneNum;
@property (nonatomic, copy) NSString* QRCodeResult;
@property (nonatomic, assign) BOOL hasPhotoImage;
@property (nonatomic, assign) BOOL hasNickName;
@property (nonatomic, strong) NIMUser* userIMData;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;

@end

NS_ASSUME_NONNULL_END
