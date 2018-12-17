//
//  YZHSearchModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchModel.h"

#import "NTESSessionUtil.h"
#import "YZHTeamExtManage.h"
#import "YZHGroupedContacts.h"

@implementation YZHSearchModel

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"teamId": @"tId",
             @"teamName": @"tName",
             @"teamIcon": @"tIcon"
             };
}

@end

@implementation YZHSearchRecruitModel

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"teamId": @"id",
             @"teamName": @"name",
             @"teamIcon": @"url",
             @"teamOwner": @"owner",
             @"recuitContent": @"info",
             };
}

@end

@interface YZHSearchListModel()

@property (nonatomic, strong) NSMutableArray<NIMRecentSession *>*  allPrivateRecentSession;
@property (nonatomic, strong) NSMutableArray<NIMRecentSession *>*  allTeamRecentSession;
@property (nonatomic, strong) NSMutableArray<NIMTeam *> *allTeam;
@property (nonatomic, strong) YZHGroupedContacts* contacts;

@end

@implementation YZHSearchListModel

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"recommendArray": [YZHSearchModel class],
             @"searchArray": [YZHSearchModel class],
             @"recommendRecruitArray": [YZHSearchRecruitModel class],
             @"searchRecruitArray": [YZHSearchRecruitModel class],
             };
}

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"recommendArray": @"beans",
             @"searchArray": @"beans",
             @"recommendRecruitArray": @"beans",
             @"searchRecruitArray": @"beans",
             };
}

- (void)searchTeamKeyText:(NSString *)keyText {
    
    [self.searchTeams removeAllObjects];
    for (NIMTeam* team in self.allTeam) {
        if ([team.teamName containsString: keyText]) {
            [self.searchTeams addObject:team];
        }
    }
}

- (void)searchTeamRecentSessionKeyText:(NSString *)keyText {
    
    [self.searchRecentSession removeAllObjects];
    for (NIMRecentSession* recentSession in self.allTeamRecentSession) {
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:recentSession.session.sessionId];
        if ([team.teamName containsString: keyText]) {
            [self.searchRecentSession addObject:recentSession];
        }
    }
}

//- (void)searchTeamTag:(NSString *)tagName {
//
//    [self.searchRecentSession removeAllObjects];
//    for (NIMRecentSession* recentSession in self.allTeamRecentSession) {
//        YZHTeamExtManage* teamExtManage = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
//        if ([tagName isEqualToString:@"无分类群"]) {
//            if (!YZHIsString(teamExtManage.team_tagName)) {
//                [self.searchRecentSession addObject:recentSession];
//            }
//        } else {
//            if ([teamExtManage.team_tagName isEqualToString:tagName]) {
//                [self.searchRecentSession addObject:recentSession];
//            }
//        }
//
//    }
//}

- (void)searchTeamTag:(NSString *)tagName {

    [self.searchTeams removeAllObjects];
    for (NIMTeam* team in self.allTeam) {
        YZHTeamExtManage* teamExtManage = [YZHTeamExtManage teamExtWithTeamId:team.teamId];
        if ([tagName isEqualToString:@"无分类群"]) {
            if (!YZHIsString(teamExtManage.team_tagName)) {
                [self.searchTeams addObject:team];
            }
        } else {
            if ([teamExtManage.team_tagName isEqualToString:tagName]) {
                [self.searchTeams addObject:team];
            }
        }
    }
}


- (void)searchPrivateKeyText:(NSString *)keyText {
    
    [self.searchRecentSession removeAllObjects];
    for (NIMRecentSession* recentSession in self.allPrivateRecentSession) {
        NIMUser* user = [[[NIMSDK sharedSDK] userManager] userInfo:recentSession.session.sessionId];
        if ([user.userInfo.nickName containsString: keyText]) {
            [self.searchRecentSession addObject:recentSession];
        }
    }
}

- (void)searchPrivateContentKeyText:(NSString *)keyText {
    
    [self.searchRecentContentSession removeAllObjects];
    
}

- (void)searchFirendTag:(NSString *)tagName {
    
    [self.searchFirends removeAllObjects];
    
    NSMutableArray* searchResult = [self.contacts searchFirendTagName:tagName];
    self.searchFirends = searchResult.count ? searchResult : nil;
}

- (void)searchFirendKeyText:(NSString *)keyText {
    
    [self.searchFirends removeAllObjects];
    
    NSMutableArray* searchResult = [self.contacts searchFirendKeyText:keyText];
    self.searchFirends = searchResult.count ? searchResult : nil;
}

- (NSMutableArray<NIMRecentSession *> *)searchRecentSession {
    
    if (!_searchRecentSession) {
        _searchRecentSession = [[NSMutableArray alloc] init];
    }
    return _searchRecentSession;
}

- (NSMutableArray<NIMRecentSession *>* )allPrivateRecentSession {
    
    if (!_allPrivateRecentSession) {
        _allPrivateRecentSession = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
        [self customSortRecents:_allPrivateRecentSession isTeam:NO];
    }
    return _allPrivateRecentSession;
}

- (NSMutableArray<NIMRecentSession *>* )allTeamRecentSession {
    
    if (!_allTeamRecentSession) {
        _allTeamRecentSession = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
        [self customSortRecents:_allTeamRecentSession isTeam:YES];
//        NSArray<NIMTeam*>* myAllTeam = [[[NIMSDK sharedSDK] teamManager] allMyTeams];
//        for (NIMTeam* team in myAllTeam) {
//            BOOL containTeam = NO;
//            for (NIMRecentSession* recentSession in _allTeamRecentSession) {
//                if ([recentSession.session.sessionId isEqualToString:team.teamId]) {
//                    containTeam = YES;
//                    break;
//                }
//            }
//            if (containTeam) {
//                NIMRecentSession* recentSession = [[NIMRecentSession alloc] init]
//
//
//            }
//        }
    }
    return _allTeamRecentSession;
    
}

- (void)customSortRecents:(NSMutableArray *)recentSessions isTeam:(BOOL)isTeam
{
    // 这里只需要遍历一次即可.然后等收到群通知时,在进行编译.
    for (NSInteger i = 0 ; i < recentSessions.count; i++) {
        NIMRecentSession* recentSession = recentSessions[i];
        BOOL isSearchType = NO;
        if (isTeam) {
            if (recentSession.session.sessionType == NIMSessionTypeTeam) {
                isSearchType = YES;
            }
        } else {
            if (recentSession.session.sessionType == NIMSessionTypeP2P) {
                isSearchType = YES;
            }
        }
        if (!isSearchType) {
            [recentSessions removeObjectAtIndex:i];
            i--;
        }
    }
    NSMutableArray<NIMRecentSession*> *array = [[NSMutableArray alloc] initWithArray:[recentSessions copy]];
    [array sortUsingComparator:^NSComparisonResult(NIMRecentSession *obj1, NIMRecentSession *obj2) {
        NSInteger score1 = [NTESSessionUtil recentSessionIsMark:obj1 type:NTESRecentSessionMarkTypeTop]? 10 : 0;
        NSInteger score2 = [NTESSessionUtil recentSessionIsMark:obj2 type:NTESRecentSessionMarkTypeTop]? 10 : 0;
        if (obj1.lastMessage.timestamp > obj2.lastMessage.timestamp)
        {
            score1 += 1;
        }
        else if (obj1.lastMessage.timestamp < obj2.lastMessage.timestamp)
        {
            score2 += 1;
        }
        if (score1 == score2)
        {
            return NSOrderedSame;
        }
        return score1 > score2? NSOrderedAscending : NSOrderedDescending;
    }];
    if (isTeam) {
        self.allTeamRecentSession = array;
    } else {
        self.allPrivateRecentSession = array;
    }
}

- (YZHGroupedContacts *)contacts {
    
    if (!_contacts) {
        _contacts = [[YZHGroupedContacts alloc] init];
    }
    return _contacts;
}

- (NSMutableArray<YZHContactMemberModel *> *)searchFirends {
    
    if (!_searchFirends) {
        _searchFirends = [[NSMutableArray alloc] init];
    }
    return _searchFirends;
}

- (NSMutableArray<NIMTeam *> *)searchTeams {
    
    if (!_searchTeams) {
        _searchTeams = [[NSMutableArray alloc] init];
    }
    return _searchTeams;
}

- (NSMutableArray<NIMTeam *> *)allTeam {
    
    if (!_allTeam) {
        _allTeam = [[[NIMSDK sharedSDK] teamManager] allMyTeams].mutableCopy;
    }
    return _allTeam;
}

- (NSMutableArray<NIMRecentSession *> *)searchRecentContentSession {
    
    if (!_searchRecentContentSession) {
        _searchRecentContentSession = [[NSMutableArray alloc] init];
        
    }
    return _searchRecentContentSession;
}

@end
