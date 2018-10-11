//
//  YZHUserLoginManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserLoginManage.h"

#import "UIViewController+YZHTool.h"

@implementation YZHUserLoginManage

- (void)userLoginWithView:(UIView *)view Account:(NSString *)account andPassword:(NSString *)password successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHVoidBlock)failureCompletion {
    
    NSDictionary* parameter = @{@"account"  :account,
                                @"password" :password
                                };
    YZHProgressHUD* hud = [YZHProgressHUD showLoadingOnView:view text:nil];
    @weakify(self)
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_USER_LOGIN_LOGINVERIFY params:parameter successCompletion:^(id obj) {
        @strongify(self)
        [self serverloginSuccessWithResponData:obj];
    } failureCompletion:^(NSError *error) {
        //TODO: 失败处理
        [hud hideWithAPIError:error];
    }];
}

// 后台登录成功处理
- (void)serverloginSuccessWithResponData:(id)responData{
    // 缓存.
    YZHLoginModel* userLoginModel = [YZHLoginModel YZH_objectWithKeyValues:responData];
    NSString* account = userLoginModel.acctId;
    NSString* token = userLoginModel.token;
    
    [self IMServerLoginWithAccount:account token:token successCompletion:^{
        
    } failureCompletion:^{
        
    }];
}

- (void)IMServerLoginWithAccount:(NSString *)account token:(NSString *)token successCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHVoidBlock)failureCompletion {
    
    // 请求登录云信.
    [[[NIMSDK sharedSDK] loginManager] login:account token:token completion:^(NSError * _Nullable error) {
        if (error == nil) {
            successCompletion ? successCompletion() : NULL;
            [self IMServerLoginSuccessWithResponData:nil];
        } else {
            // 错误提示 TODO:
            failureCompletion ? failureCompletion() : NULL;
            [YZHProgressHUD showAPIError:error];
        }
    }];
}

// 网易IM信登录成功处理
- (void)IMServerLoginSuccessWithResponData:(id)responData{
    //暂时先到主要,后面还需要加上从云信获取信息的逻辑
    [UIViewController yzh_userLoginSuccessToHomePage];
}

@end
