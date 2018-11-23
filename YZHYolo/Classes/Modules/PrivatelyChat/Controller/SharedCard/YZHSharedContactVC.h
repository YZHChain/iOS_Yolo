//
//  YZHSharedContactVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHUserCardAttachment.h"
#import "YZHTeamCardAttachment.h"
typedef NS_ENUM(NSUInteger, YZHSharedContactType) {
    YZHSharedContactTypePersonageCard = 1,
    YZHSharedContactTypeTeamCard,
    YZHSharedContactTypeTeamAddFriend,
};

NS_ASSUME_NONNULL_BEGIN

@interface YZHSharedContactVC : YZHBaseViewController

@property (nonatomic, assign) YZHSharedContactType sharedType;
@property (nonatomic, copy) void (^sharedPersonageCardBlock)(YZHUserCardAttachment* );
@property (nonatomic, copy) void (^sharedTeamCardBlock)(YZHTeamCardAttachment* );

@end

NS_ASSUME_NONNULL_END
