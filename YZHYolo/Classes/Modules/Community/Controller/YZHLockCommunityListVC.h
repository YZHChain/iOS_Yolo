//
//  YZHLockCommunityListVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/30.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "NIMSessionListViewController.h"

#import "YZHRecentSessionExtManage.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHLockCommunityListVC : NIMSessionListViewController

@property (nonatomic, strong) YZHRecentSessionExtManage* recentSessionExtManage;

- (instancetype)initWithRecentSessionExtManage:(YZHRecentSessionExtManage *)recentSessionExtManage;
@end

NS_ASSUME_NONNULL_END
