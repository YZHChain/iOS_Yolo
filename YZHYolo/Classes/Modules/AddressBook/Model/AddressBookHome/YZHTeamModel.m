//
//  YZHTeamModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamModel.h"

@implementation YZHTeamModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        //获取群组列表
        [self update];
    }
    return self;
}

- (void)update {
    
    NSMutableArray* mutableTeamArray = [[NSMutableArray alloc] init];
    for (NIMTeam* team in [NIMSDK sharedSDK].teamManager.allMyTeams) {
        [mutableTeamArray addObject:team];
    }
    self.allTeamModel = mutableTeamArray.copy;
}

@end
