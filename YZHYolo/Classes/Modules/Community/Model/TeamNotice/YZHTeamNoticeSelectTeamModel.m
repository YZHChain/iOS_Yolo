//
//  YZHTeamNoticeSelectTeamModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamNoticeSelectTeamModel.h"

@implementation YZHTeamNoticeSelectTeamModel

- (instancetype)initWithTeamId:(NSString *)teamId {
    
    self = [super init];
    if (self) {
        _teamId = teamId;
        [self configurition];
    }
    return self;
}

- (void)configurition {
    
    NSMutableArray<NIMTeam *> *allMyTeams =  [[[[NIMSDK sharedSDK] teamManager] allMyTeams] mutableCopy];
   
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    [allMyTeams enumerateObjectsUsingBlock:^(NIMTeam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.owner isEqualToString:userId]) {
            [allMyTeams removeObject:obj];
        }
    }];
    [allMyTeams enumerateObjectsUsingBlock:^(NIMTeam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.teamId isEqualToString:self.teamId]) {
            self.currentTeamPath = [NSIndexPath indexPathForRow:idx inSection:0];
        }
    }];
    
    self.allMyOnwerTeam = allMyTeams.copy;
}

@end
