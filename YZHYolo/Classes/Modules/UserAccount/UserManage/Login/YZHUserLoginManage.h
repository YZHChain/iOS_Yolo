//
//  YZHUserLoginManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHPublic.h"
#import "YZHLoginModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHIMLoginData : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *account; // IM平台登录账号
@property (nonatomic, copy) NSString *token;   // IM平台Token
@property (nonatomic, copy) NSString *yoloId;  // Yolo 号.
@property (nonatomic, copy) NSString *mnemonicWord; //助记词
@property (nonatomic, copy) NSString *userId;  // Yolo 账号 与 自己后台交互时使用
@property (nonatomic, copy) NSString *phoneNumber; //电话号码.
@property (nonatomic, copy) NSString *appKey; // IM Appkey
@property (nonatomic, assign) BOOL isAutoLogin;
@property (nonatomic, copy) NSString *userAccount; // 用户直接登录账号
@property (nonatomic, copy) NSString *userPassword;  // 用户直接登录密码

@end

@interface YZHUserLoginManage : NSObject

@property (nonatomic, strong, nullable) YZHIMLoginData* currentLoginData;

+ (instancetype)sharedManager;

- (void)userLoginWithView:(UIView *)view Account:(NSString *)account andPassword:(NSString *)password successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (void)IMServerLoginWithAccount:(NSString *)account token:(NSString *)token userLoginModel:(YZHLoginModel* )userLoginModel successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;

- (void)executeLogincheckout;
- (void)executeHandInputLogin;
@end

NS_ASSUME_NONNULL_END
