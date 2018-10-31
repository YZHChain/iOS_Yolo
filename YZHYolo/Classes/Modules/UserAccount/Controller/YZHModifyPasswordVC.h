//
//  YZHModifyPasswordVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/15.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YZHModifyPasswordTypePhone = 0, //手机号修改
    YZHModifyPasswordTypeOriginalPW, //原密码修改
} YZHModifyPasswordType;
@interface YZHModifyPasswordVC : YZHBaseViewController

@end

NS_ASSUME_NONNULL_END
