//
//  YZHTeamCardIntroModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardIntroModel.h"

#import "YZHTeamInfoExtManage.h"
@implementation YZHTeamCardIntroModel

- (instancetype)initWithTeamId:(NSString *)teamId {
    
    self = [super init];
    if (self) {
        _teamId = [teamId copy];
        
        [self configuration];
    }
    return self;
}

- (void)configuration {
 
    NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:_teamId];
//    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
//    NIMTeamMember* member = [[[NIMSDK sharedSDK] teamManager] teamMember:userId inTeam:_teamId];
    YZHTeamInfoExtManage* teamInfoExtManage = [YZHTeamInfoExtManage YZH_objectWithKeyValues:team.clientCustomInfo];
    self.teamModel = team;
    self.teamOwner = team.owner;
    NIMUser* teamOwner = [[[NIMSDK sharedSDK] userManager] userInfo:self.teamOwnerName];
    self.teamOwnerName = teamOwner.userInfo.nickName;
    
    YZHTeamHeaderModel* headerModel = [[YZHTeamHeaderModel alloc] init];
    headerModel.teamName = team.teamName;
    headerModel.teamSynopsis = team.intro;
    headerModel.avatarImageName = team.avatarUrl;
    headerModel.labelArray = teamInfoExtManage.labelArray;
    headerModel.canEdit = NO;
    headerModel.viewClass = @"YZHTeamCardHeaderView";
    headerModel.teamId = _teamId;
    
    self.headerModel = headerModel;
}

@end
