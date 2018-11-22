//
//  YZHTeamExtManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 用户对目标群的自定义扩展
@interface YZHTeamExtManage : NSObject

@property (nonatomic, assign) BOOL team_add_friend;
@property (nonatomic, assign) BOOL team_p2p_chat;
@property (nonatomic, assign) BOOL team_lock;
@property (nonatomic, copy) NSString* team_tagName;

+ (instancetype)teamExtWithTeamId:(NSString* )teamId;
+ (instancetype)targetTeamExtWithTeamId:(NSString* )teamId targetId:(NSString *)targetId;
@end

NS_ASSUME_NONNULL_END
