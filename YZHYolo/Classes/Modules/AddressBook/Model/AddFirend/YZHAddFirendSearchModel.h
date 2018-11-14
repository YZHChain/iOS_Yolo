//
//  YZHAddFirendSearchModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHContactMemberModel.h"
#import "YZHUserModelManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddFirendSearchModel : NSObject

@property (nonatomic, copy) NSString* yoloId;
@property (nonatomic, copy) NSString* phoneNumber;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, assign) BOOL isMyFriend; //
@property (nonatomic, assign) BOOL allowAdd; //
@property (nonatomic, assign) BOOL isMySelf;
@property (nonatomic, assign) BOOL needVerfy;
@property (nonatomic, strong) NIMUser* user;
@property (nonatomic, strong) YZHContactMemberModel* memberModel;
@property (nonatomic, strong) YZHUserInfoExtManage* userInfoExt;
@property (nonatomic, copy) NSString* addText;

- (void)configurationUserData;

@end

NS_ASSUME_NONNULL_END
