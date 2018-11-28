//
//  YZHCreateTeamAdditionVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/31.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHCreateTeamAdditionVC : YZHBaseViewController

@property (nonatomic, copy) void (^clickCreatTeamBlock)(NSString* _Nullable recruitText);

@end

NS_ASSUME_NONNULL_END
