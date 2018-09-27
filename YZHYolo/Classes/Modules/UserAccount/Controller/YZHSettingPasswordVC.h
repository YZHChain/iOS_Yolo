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
    YZHSettingPasswordTypeFind,
} YZHSettingPasswordType;
@interface YZHSettingPasswordVC : YZHBaseViewController

@property(nonatomic, copy)NSString* phoneNum;
@property(nonatomic, assign)YZHSettingPasswordType settingPasswordType;

@end
