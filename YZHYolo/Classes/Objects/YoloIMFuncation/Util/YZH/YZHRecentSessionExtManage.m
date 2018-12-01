//
//  YZHRecentSessionExtManage.m
//  NIM
//
//  Created by Jersey on 2018/10/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "YZHRecentSessionExtManage.h"
#import "NTESSessionUtil.h"
#import "YZHTargetUserDataManage.h"
#import "YZHUserModelManage.h"
#import "YZHTeamExtManage.h"

@implementation YZHRecentSeesionExtModel

@end

@implementation YZHRecentSessionExtManage

#pragma mark -- Sort

- (void)screeningTagSessionAllRecentSession:(NSMutableArray<NIMRecentSession *> *)allRecentSession {
    
    [self updataDefaultTags];
    _tagsRecentSession = [self defaultTagsRecentSession];
    _currentSessionTags = [self defaultCurrentSessionTags];
    NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
        //检查本地扩展字段.
    for (NSInteger i = 0; i < allRecentSession.count; i++) {
        NIMRecentSession* recentSession = allRecentSession[i];
        //不比较未分类,直接存到到最后
        NSInteger tagCount = self.tagsRecentSession.count;
        // BUG
        for (NSInteger y = 0; y < tagCount; y++) {
            //先检查是否包含置顶,如果包含则不需要考虑标签,之前假如到第一组
            if ([[recentSession.localExt objectForKey:markTypeTopkey] boolValue] == YES) {
                [self.tagsRecentSession.firstObject addObject:recentSession];
                break;
            } else {
                [self.tagsRecentSession.firstObject removeObject:recentSession];
            }
            NSString* tagName = self.defaultTags[y];
            NSString* sessionTagName = [self getSessionExtTagNameWithRecentSession:recentSession];
            BOOL isSessionTypeP2P = recentSession.session.sessionType == NIMSessionTypeP2P;
            // 查找到之后终止循环,防止重复添加。
            if ([tagName isEqualToString:sessionTagName] && isSessionTypeP2P) {
                
                [self.tagsRecentSession[y] addObject:recentSession];
                break;
            } else if(sessionTagName.length == 0 && isSessionTypeP2P) {
                [self.tagsRecentSession.lastObject addObject:recentSession];
                break;
            }
        }
    }
    // 去掉不包含回话的空标签数组.
    for (NSInteger i = 0; i < self.tagsRecentSession.count; ) {
        if (self.tagsRecentSession[i].count == 0) {
            [self.tagsRecentSession removeObjectAtIndex:i];
        } else {
            i++;
        }
    }
}

- (void)sortTagRecentSession {
    
    NSMutableArray* recentSessionArray;
    for (NSInteger i = 0; i < self.tagsRecentSession.count; i++) {
        //将每个标签包含的会话取出进行排序.
        recentSessionArray = self.tagsRecentSession[i];
        [recentSessionArray sortUsingComparator:^NSComparisonResult(NIMRecentSession *obj1, NIMRecentSession *obj2) {
            //每个标签内只比较最后一条消息时间
            if (obj1.lastMessage.timestamp > obj2.lastMessage.timestamp) {
                
                return NSOrderedAscending;
            } else if (obj1.lastMessage.timestamp < obj2.lastMessage.timestamp) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
    };
}

#pragma mark -- Team

- (void)screeningTagSessionAllTeamRecentSession:(NSMutableArray<NIMRecentSession* > *)allRecentSession {
    
    [self updateTeamDefaultTags];
    
    [self.lockTeamRecentSession removeAllObjects];
    //用于保存,存在标签的回话.
    _tagsTeamRecentSession = [self defaultTeamTagsRecentSession];
    
    NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
    //检查本地扩展字段.
    for (NSInteger i = 0; i < allRecentSession.count; i++) {
        NIMRecentSession* recentSession = allRecentSession[i];
        YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
        //不比较未分类,直接存到到最后
        NSInteger tagCount = self.tagsTeamRecentSession.count;
        // BUG
        for (NSInteger y = 0; y < tagCount; y++) {
            //先检查是否包含置顶,如果包含则不需要考虑标签,之前假如到第一组
            if ([[recentSession.localExt objectForKey:markTypeTopkey] boolValue] == YES || teamExt.team_top) {
                [self.tagsTeamRecentSession.firstObject addObject:recentSession];
                break;
            } else {
                [self.tagsTeamRecentSession.firstObject removeObject:recentSession];
            }
            //如果群属于上锁, 并且非置顶, 则加入到第二个分区.
            if (teamExt.team_lock && [[recentSession.localExt objectForKey:markTypeTopkey] boolValue] == NO) {
                //直接添加到上锁群回话列表中
                if (self.lockTeamRecentSession.count) {
                    [self.lockTeamRecentSession addObject:recentSession];
                } else {
                    self.lockTeamRecentSession = [[NSMutableArray alloc] init];
                    [self.lockTeamRecentSession addObject:recentSession];
                }
                self.tagsTeamRecentSession[1] = self.lockTeamRecentSession; //添加上锁列表
                break;
            } else {
                [self.tagsTeamRecentSession[1] removeObject:recentSession];
                [self.lockTeamRecentSession removeObject:recentSession];
            }
            NSString* tagName = self.teamDefaultTags[y];
            NSString* sessionTagName = [self getSessionExtTagNameWithTeamRecentSession:recentSession];
            BOOL isSessionTypeTeam = recentSession.session.sessionType == NIMSessionTypeTeam;
            // 查找到之后终止循环,防止重复添加。
            if ([tagName isEqualToString:sessionTagName] && isSessionTypeTeam) {
                
                [self.tagsTeamRecentSession[y] addObject:recentSession];
                break;
            } else if(sessionTagName.length == 0 && isSessionTypeTeam) { //未设置标签的群则直接添加到最后一组.
                [self.tagsTeamRecentSession.lastObject addObject:recentSession];
                break;
            }
        }
    }
    // 去掉不包含回话的空标签数组.
    for (NSInteger i = 0; i < self.tagsTeamRecentSession.count; ) {
        if (self.tagsTeamRecentSession[i].count == 0) {
            [self.tagsTeamRecentSession removeObjectAtIndex:i];
        } else {
            i++;
        }
    }
}
// 对默认列表进行排序, 
- (void)screeningDefaultSessionAllTeamRecentSession:(NSMutableArray<NIMRecentSession* > *)allRecentSession {
    
    NSInteger number = 0;
    if (number == 0) {
        NSLog(@"所有回话%ld", allRecentSession.count);
        NSLog(@"所有锁回话%ld", self.lockTeamRecentSession.count);
        NSLog(@"所有默认回话%ld", self.TeamRecentSession.count);
        [self.lockTeamRecentSession removeAllObjects];
        //将最新回话里面所有设置上锁, 非置顶的群回话抽取出来.
        self.TeamRecentSession = [allRecentSession mutableCopy];
        self.topTeamCount = 0;
        //计算置顶个数.
        
        //置顶只使用 用户对群自定义字段 team_top 判断
//        NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
        @weakify(self)
        [self.TeamRecentSession enumerateObjectsUsingBlock:^(NIMRecentSession * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            //需要计算当前回话一共有多少个置顶群,
            YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:obj.session.sessionId];
//             || [[obj.localExt objectForKey:markTypeTopkey] boolValue] == YES
            if (teamExt.team_top) {
                ++ self.topTeamCount;
            }
//            [[obj.localExt objectForKey:markTypeTopkey] boolValue] == NO ||
            if ((teamExt.team_lock && (teamExt.team_top == NO))) {
                [self.TeamRecentSession removeObject:obj];
                //直接添加到上锁群回话列表中
                if (self.lockTeamRecentSession.count) {
                    [self.lockTeamRecentSession addObject:obj];
                } else {
                    self.lockTeamRecentSession = [[NSMutableArray alloc] init];
                    [self.lockTeamRecentSession addObject:obj];
                }
                NSLog(@"总个数:%ld", allRecentSession.count);
            }
        }];
        if (self.topTeamCount) {
            self.tagsTeamRecentSession[1] = self.lockTeamRecentSession;
        } else {
            self.tagsTeamRecentSession[0] = self.lockTeamRecentSession;
        }
        NSLog(@"所有回话%ld", allRecentSession.count);
        NSLog(@"所有锁回话%ld", self.lockTeamRecentSession.count);
        NSLog(@"所有默认回话%ld", self.TeamRecentSession.count);
        //置顶群有个专门的地方保存.
//        ++number;
    } else {
        
    }
    
}
// 社群列表时间排序.
- (void)sortTagTeamRecentSession {
    
    NSMutableArray* recentSessionArray;
    for (NSInteger i = 0; i < self.tagsTeamRecentSession.count; i++) {
            //将每个标签包含的会话取出进行排序.
            recentSessionArray = self.tagsTeamRecentSession[i];
            [recentSessionArray sortUsingComparator:^NSComparisonResult(NIMRecentSession *obj1, NIMRecentSession *obj2) {
                //每个标签内只比较最后一条消息时间
                if ([obj1 isKindOfClass:[NIMRecentSession class]] && [obj2 isKindOfClass:[NIMRecentSession class]]) {
                    if (obj1.lastMessage.timestamp > obj2.lastMessage.timestamp) {
                        return NSOrderedAscending;
                    } else if (obj1.lastMessage.timestamp < obj2.lastMessage.timestamp) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                } else {
                    //TODO:上锁群排序. 还需要往里面继续循一圈
                    return NSOrderedAscending;
                }
            }];
    };
}
//TODO:
- (void)checkSessionUserTagWithTeamRecentSession:(NIMRecentSession* )recentSession {
    
    if (recentSession.session.sessionType == NIMSessionTypeTeam) {
        YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
        NSString* userExt = teamExt.team_tagName;
        if (YZHIsString(userExt)) {
            NSData* jsonData = [userExt dataUsingEncoding:NSUTF8StringEncoding];
            NSError* error;
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                if (dic[@"team_tagName"]) {
                    NSDictionary *localExt = recentSession.localExt?:@{};
                    NSMutableDictionary *dict = [localExt mutableCopy];
                    [dict setObject:dic[@"team_tagName"] forKey:@"team_tagName"];
                    localExt = dict.copy;
                    NSDictionary* recentSessionLocExt = recentSession.localExt;
                    if (![recentSessionLocExt isEqualToDictionary:localExt]) {
                        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession];
                    }
                }
            }
        }
    }
}

#pragma mark -- updateRecentSession

- (void)checkSessionUserTagWithRecentSession:(NIMRecentSession* )recentSession {
    if (recentSession.session.sessionType == NIMSessionTypeP2P) {
        NIMUser* user = [[NIMSDK sharedSDK].userManager userInfo:recentSession.session.sessionId];
        NSString* userExt = user.ext;
        if (YZHIsString(userExt)) {
            NSData* jsonData = [userExt dataUsingEncoding:NSUTF8StringEncoding];
            NSError* error;
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                if (dic[@"friend_tagName"]) {
                    NSDictionary *localExt = recentSession.localExt?:@{};
                    NSMutableDictionary *dict = [localExt mutableCopy];
                    [dict setObject:dic[@"friend_tagName"] forKey:@"friend_tagName"];
                    localExt = dict.copy;
                    NSDictionary* recentSessionLocExt = recentSession.localExt;
                    if (![recentSessionLocExt isEqualToDictionary:localExt]) {
                        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recentSession];
                    }
                }
            }
        }
    }
}

#pragma SET & GET

- (NSMutableArray<NSMutableArray<NIMRecentSession *> *> *)defaultTagsRecentSession {
    
    _tagsRecentSession = [[NSMutableArray alloc] initWithCapacity:self.defaultTags.count];
    for (NSInteger i = 0; i < self.defaultTags.count; i++) {
        NSMutableArray<NIMRecentSession* >*  recentSessionArray = [[NSMutableArray alloc] init];
        [_tagsRecentSession addObject:recentSessionArray];
    }
    return _tagsRecentSession;
}

- (NSMutableArray<NSDictionary *> *)defaultCurrentSessionTags {
    
    _currentSessionTags = [[NSMutableArray alloc] initWithCapacity:self.defaultTags.count];
    for (NSInteger i = 0; i < self.defaultTags.count; i++) {
        NSDictionary * dic = [NSDictionary dictionary];
        [_currentSessionTags addObject:dic];
    }
    return _currentSessionTags;
}

//群聊
- (NSMutableArray<NSMutableArray<NIMRecentSession *> *> *)defaultTeamTagsRecentSession {
    
    _tagsTeamRecentSession = [[NSMutableArray alloc] initWithCapacity:self.teamDefaultTags.count];
    for (NSInteger i = 0; i < self.teamDefaultTags.count; i++) {
        NSMutableArray<NIMRecentSession* >*  recentSessionArray = [[NSMutableArray alloc] init];
        [_tagsTeamRecentSession addObject:recentSessionArray];
    }
    return _tagsTeamRecentSession;
}

- (NSMutableArray<NSDictionary *> *)defaultTeamCurrentSessionTags {
    
    _teamCurrentSessionTags = [[NSMutableArray alloc] initWithCapacity:self.teamDefaultTags.count];
    for (NSInteger i = 0; i < self.teamDefaultTags.count; i++) {
        NSDictionary * dic = [NSDictionary dictionary];
        [_teamCurrentSessionTags addObject:dic];
    }
    return _teamCurrentSessionTags;
}

//- (NSArray<NIMUser *> *)myFriends {
//    
//    if (!_myFriends) {
//        _myFriends = [[NIMSDK sharedSDK].userManager myFriends];
//    }
//    return _myFriends;
//}

- (void)updataDefaultTags {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    NSMutableArray* tagsArray = [[NSMutableArray alloc] init];
//    for (YZHUserGroupTagModel* groupTags in userInfoExt.groupTags) {
//        [tagsArray addObject:groupTags.tagName];
//    }
    for (YZHUserGroupTagModel* customTags in userInfoExt.customTags) {
        [tagsArray addObject:customTags.tagName];
    }
    [tagsArray insertObject:@"置顶" atIndex:0];
    [tagsArray addObject:@"无好友标签"];
    
    self.defaultTags = tagsArray.copy;
}

- (void)updateTeamDefaultTags {
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    NSMutableArray* tagsArray = [[NSMutableArray alloc] init];
    for (YZHUserGroupTagModel* customTags in userInfoExt.groupTags) {
        [tagsArray addObject:customTags.tagName];
    }
    [tagsArray insertObject:@"置顶" atIndex:0];
    [tagsArray insertObject:@"上锁群" atIndex:1];
    [tagsArray addObject:@"无分类社群"];
    
    self.teamDefaultTags = tagsArray.copy;
}

- (NSString* )getSessionExtTagNameWithRecentSession:(NIMRecentSession* )recentSession {
    // 优化
    YZHRecentSeesionExtModel* extModel = [[YZHRecentSeesionExtModel alloc] init];
    extModel.tagName = recentSession.localExt[@"friend_tagName"];
    
    return extModel.tagName;
}

- (NSString* )getSessionExtTagNameWithTeamRecentSession:(NIMRecentSession* )recentSession {
    // 优化
    YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
    
    return teamExt.team_tagName;
}

- (BOOL)checkoutContainLockTeamRecentSessions:(NSMutableArray<NIMRecentSession *> *)recentSessions {
    
    NIMRecentSession* recentSession = recentSessions.firstObject;
    YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
//    NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
//    [[recentSession.localExt objectForKey:markTypeTopkey] boolValue] == NO ||
    //最近回话或者群成员自定义信息 的置顶字段为 NO 时,则
    if (teamExt.team_top == NO) {
        if (teamExt.team_lock) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (BOOL)checkoutContainTopOrLockTeamRecentSession:(NIMRecentSession* )recentSession {
    
    YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
//    NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
//    [[recentSession.localExt objectForKey:markTypeTopkey] boolValue] == YES ||
    if (teamExt.team_top || teamExt.team_lock) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkoutContainTopTeamRecentSession:(NIMRecentSession* )recentSession {
    
    YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
//    NSString *markTypeTopkey = [NTESSessionUtil keyForMarkType:NTESRecentSessionMarkTypeTop];
//    [[recentSession.localExt objectForKey:markTypeTopkey] boolValue] == YES ||
    if (teamExt.team_top) {
        return YES;
    } else {
        return NO;
    }
}

@end
