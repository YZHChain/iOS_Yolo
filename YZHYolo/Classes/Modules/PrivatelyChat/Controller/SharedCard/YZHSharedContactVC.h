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

typedef NS_ENUM(NSUInteger, YZHForwardContactType) {
    YZHForwardContactTypePersonageCard = 1,
    YZHForwardContactTypeTeamCard,
};

NS_ASSUME_NONNULL_BEGIN

@interface YZHSharedContactVC : YZHBaseViewController

@property (nonatomic, assign) YZHSharedContactType sharedType;
@property (nonatomic, assign) YZHForwardContactType forwardType;
@property (nonatomic, assign) BOOL isForward; //是否为转发, 否则属于分享添加好友
@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, copy) void (^sharedPersonageCardBlock)(YZHUserCardAttachment* );
@property (nonatomic, copy) void (^sharedTeamCardBlock)(YZHTeamCardAttachment* );
@property (nonatomic, copy) void (^forwardMessageToUserBlock)(NSString* );
@property (nonatomic, copy) void (^forwardMessageToTeamBlock)(NSString* );
@property (nonatomic, copy) YZHVoidBlock addFriendSuccessful;

@end

NS_ASSUME_NONNULL_END
