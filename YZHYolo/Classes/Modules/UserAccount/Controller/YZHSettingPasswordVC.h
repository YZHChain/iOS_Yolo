//
//  YZHSettingPasswordVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

typedef enum : NSUInteger {
    YZHSettingPasswordTypeRegister = 0,
    YZHSettingPasswordTypeFind, //通过助记词
} YZHSettingPasswordType;
@interface YZHSettingPasswordVC : YZHBaseViewController

@property(nonatomic, copy)NSString* phoneNum; //原先是手机号码, 新版注册流程统一都是 YoloId
@property(nonatomic, copy)NSString* inviteCode; //邀请码.
@property(nonatomic, assign)YZHSettingPasswordType settingPasswordType;

//PATH_USER_SECRETKEYUPDATEPWD

@end
