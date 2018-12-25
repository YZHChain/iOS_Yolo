//
//  YZHTeamUpdataModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamUpdataModel.h"

#import "YZHTeamInfoExtManage.h"
@implementation YZHTeamUpdataModel

- (instancetype)initWithTeamId:(NSString *)teamId isCreatTeam:(BOOL)isCreatTeam {
    
    self = [super init];
    if (self) {
        _teamId = teamId;
        _isCreatTeam = isCreatTeam;
        [self configurationParams];
    }
    return self;
}

- (void)configurationParams {
    
    NSMutableDictionary* mutableDic = [[NSMutableDictionary alloc] init];
    
    NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId];
    YZHTeamInfoExtManage* teamInfoExt = [[YZHTeamInfoExtManage alloc] initTeamExtWithTeamId:self.teamId];
    
    [mutableDic setValue:[NSNumber numberWithBool:_isCreatTeam] forKey:@"teamCreate"];
    if (YZHIsString(team.avatarUrl)) {
        [mutableDic setValue:team.avatarUrl forKey:@"teamIcon"];
    }
    if (YZHIsString(_teamId)) {
        [mutableDic setValue:_teamId ? _teamId : @"" forKey:@"teamId"];
    }
    //群标签
    if (teamInfoExt.labelArray.count) {
        [mutableDic setValue:teamInfoExt.labelArray forKey:@"teamLabel"];
    }
    if (YZHIsString(team.teamName)) {
        [mutableDic setValue:team.teamName forKey:@"teamName"];
    }
    // 所有人都可以邀请为 1 即公开群.  TODO: 公开群使用 加入 模型来判断 还是使用验证方式.
    [mutableDic setValue:[NSNumber numberWithBool:!team.joinMode] forKey:@"teamOpen"];
    
    if (YZHIsString(team.owner)) {
        [mutableDic setValue:team.owner forKey:@"teamOwner"];
    }
    // 是否为招募群
    [mutableDic setValue:[NSNumber numberWithBool:teamInfoExt.recruit.isValid ? YES : NO] forKey:@"teamRecruit"];
    //TODO 招募群信息.
    if (YZHIsString(teamInfoExt.recruit.content)) {
        [mutableDic setValue:teamInfoExt.recruit.content forKey:@"teamRecruitMsg"];
    }
    //是否为共享群
    [mutableDic setValue:[NSNumber numberWithBool:NO] forKey:@"teamShare"];
    

    self.params = mutableDic.copy;
}

@end
