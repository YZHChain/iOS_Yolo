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

@interface YZHIMLoginData : NSObject

@property (nonatomic, copy)  NSString *account;
@property (nonatomic, copy)  NSString *token;
@property (nonatomic, assign) BOOL isAutoLogin;

@end

@interface YZHUserLoginManage : NSObject

@property (nonatomic, strong) YZHIMLoginData* currentLoginData;

+ (instancetype)sharedManager;

- (void)userLoginWithView:(UIView *)view Account:(NSString *)account andPassword:(NSString *)password successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (void)IMServerLoginWithAccount:(NSString *)account token:(NSString *)token successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (void)executeLogincheckout;

@end

NS_ASSUME_NONNULL_END
