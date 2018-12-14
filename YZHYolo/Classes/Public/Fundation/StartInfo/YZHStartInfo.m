//
//  YZHStartInfo.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHStartInfo.h"

#import "YZHUserLoginManage.h"
#import "YZHUserDataManage.h"

@interface YZHStartInfo()

@end

@implementation YZHStartInfo

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)checkUserEveryDayTask {
    
    NSDate* taskCompleDate = [[[YZHUserDataManage sharedManager] currentUserData] taskCompleDate];
    if (taskCompleDate) {
        NSDate* currentTime = [NSDate date];
        NSTimeInterval currentTimeinter = [currentTime timeIntervalSince1970] * 1;
        NSTimeInterval compleTimeInter = [taskCompleDate timeIntervalSince1970] * 1;
        NSTimeInterval timeDifference = compleTimeInter - currentTimeinter;
        if (timeDifference >= (60 * 60 * 24)) {
            [self executeEveryDayIntegralTask];
        }
    } else {
        [self executeEveryDayIntegralTask];
    }
}

- (void)executeEveryDayIntegralTask {

    NSInteger firendNum = [[[NIMSDK sharedSDK] userManager] myFriends].count;
    NSArray* allMyTeams = [[[NIMSDK sharedSDK] teamManager] allMyTeams];
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    NSMutableArray* userGroupInfos = [[NSMutableArray alloc] init];
    for (NIMTeam* team in allMyTeams) {
        BOOL isMyTeam = NO;
        BOOL isPublic = NO;
        NSInteger teamMembers = team.memberNumber;
        NSString* teamId = team.teamId;
        if ([userId isEqualToString:team.owner]) {
            isMyTeam = YES;
        }
        if (team.joinMode == NIMTeamJoinModeNoAuth) {
            isPublic = YES;
        }
        NSDictionary* userGroupInfo = @{
            @"groupId": teamId,
            @"mine": [NSNumber numberWithBool:isMyTeam],
            @"open": [NSNumber numberWithBool:isPublic],
            @"personNum": [NSNumber numberWithInteger:teamMembers],
            };
        [userGroupInfos addObject:userGroupInfo];
    }
    NSString* yoloNo = [[[YZHUserLoginManage sharedManager] currentLoginData] yoloId];
    NSDictionary* dic = @{
                        @"friendNum": [NSNumber numberWithInteger:firendNum],
                        @"userGroupInfos": userGroupInfos,
                        @"yoloNo": yoloNo
                        };
    YZHUserDataManage* dateManage = [YZHUserDataManage sharedManager];
    [[YZHNetworkService shareService] POSTNetworkingResource:PATH_INTEGRL_COLLARTASK params:dic successCompletion:^(id obj) {
        
        NSDate *compleDate = [NSDate date];
        dateManage.currentUserData.taskCompleDate = compleDate;
        [dateManage setCurrentUserData:dateManage.currentUserData];
        
    } failureCompletion:^(NSError *error) {
        
        dateManage.currentUserData.taskCompleDate = nil;
        [dateManage setCurrentUserData:dateManage.currentUserData];
    }];
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
