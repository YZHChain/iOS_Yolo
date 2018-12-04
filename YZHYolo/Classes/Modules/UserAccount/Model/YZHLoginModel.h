//
//  YZHLoginModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHLoginModel : NSObject

@property (nonatomic, copy) NSString* appKey; //第三方平台分配的appkey
@property (nonatomic, copy) NSString* userId; //用户 Id
@property (nonatomic, copy) NSString* mnemonicWord; //助记词
@property (nonatomic, copy) NSString* acctId; //用户对应第三方平台acctId
@property (nonatomic, copy) NSString* token; //用户对应第三方平台token
@property (nonatomic, copy) NSString* orderFlag;
@property (nonatomic, copy) NSString* yoloNo; //yoloNo 平台号码
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* userAccount;   // 用户直接登录账号
@property (nonatomic, copy) NSString* userPassword;  // 用户直接登录密码

@end

NS_ASSUME_NONNULL_END
