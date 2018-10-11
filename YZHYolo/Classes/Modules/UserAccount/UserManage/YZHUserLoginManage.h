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

@interface YZHUserLoginManage : NSObject

- (void)userLoginWithView:(UIView *)view Account:(NSString *)account andPassword:(NSString *)password successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHVoidBlock)failureCompletion;
- (void)IMServerLoginWithAccount:(NSString *)account token:(NSString *)token successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHVoidBlock)failureCompletion;
@end

NS_ASSUME_NONNULL_END
