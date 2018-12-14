//
//  YZHTeamExtManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamExtManage.h"

@implementation YZHTeamExtManage

+ (instancetype)targetTeamExtWithTeamId:(NSString *)teamId targetId:(NSString *)targetId {
    
     NIMTeamMember* teamMember = [[[NIMSDK sharedSDK] teamManager] teamMember:targetId inTeam:teamId];
//    if (!teamMember) {
//        [[[NIMSDK sharedSDK] teamManager] fetchTeamMembers:teamId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
//            for (NIMTeamMember* member in members) {
//                [member.userId isEqualToString:targetId];
//                teamMember = member;
//                break;
//            }
//        }];
//    }
    NSString* teamExtString = teamMember.customInfo;
    
    if (YZHIsString(teamExtString)) {
        YZHTeamExtManage* teamExtManage = [YZHTeamExtManage YZH_objectWithKeyValues:teamExtString];
        return teamExtManage;
    } else {
        return [[YZHTeamExtManage alloc] initWithDefault];
    }
}

+ (instancetype)teamExtWithTeamId:(NSString* )teamId {
    
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    NIMTeamMember* teamMember = [[[NIMSDK sharedSDK] teamManager] teamMember:userId inTeam:teamId];
    NSString* teamExtString = teamMember.customInfo;
    if (YZHIsString(teamExtString)) {
        YZHTeamExtManage* teamExtManage = [YZHTeamExtManage YZH_objectWithKeyValues:teamExtString];
        return teamExtManage;
    } else {
        return [[YZHTeamExtManage alloc] initWithDefault];
    }
}

- (instancetype)initWithDefault {
    
    self = [super init];
    if (self) {
        _team_add_friend = YES;
        _team_p2p_chat = YES;
        _team_lock = NO;
        _team_tagName = nil;
        _team_top = NO;
    }
    return self;
}

@end
