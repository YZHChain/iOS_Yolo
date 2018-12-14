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

- (void)screeningAllPrivateRecebtSessionRecentSession:(NSMutableArray<NIMRecentSession* > *)allRecentSession {
    NSLog(@"私聊列表排序");
    if (allRecentSession.count) {
        [self screeningTagSessionAllRecentSession:allRecentSession];
        [self sortTagTeamRecentSession];
    }
    NSLog(@"私聊列表排序结束");
}

#pragma mark -- Team

- (void)screeningTagSessionAllTeamRecentSession:(NSMutableArray<NIMRecentSession* > *)allRecentSession {
    
    [self updateTeamDefaultTags];
    
    [self.lockTeamRecentSession removeAllObjects];
    //用于保存,存在标签的回话.
    _tagsTeamRecentSession = [self defaultTeamTagsRecentSession];
    
    //检查本地扩展字段.
    for (NSInteger i = 0; i < allRecentSession.count; i++) {
        NIMRecentSession* recentSession = allRecentSession[i];
        YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
        //不比较未分类,直接存到到最后
        NSInteger tagCount = self.tagsTeamRecentSession.count;
        // BUG
        for (NSInteger y = 0; y < tagCount; y++) {
            //先检查是否包含置顶,如果包含则不需要考虑标签,之前假如到第一组
            if (teamExt.team_top) {
                [self.tagsTeamRecentSession.firstObject addObject:recentSession];
                break;
            } else {
                [self.tagsTeamRecentSession.firstObject removeObject:recentSession];
            }
            //如果群属于上锁, 并且非置顶, 则加入到第二个分区.
            if (teamExt.team_lock && teamExt.team_top == NO) {
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
//    // 去掉不包含回话的空标签数组.
//    for (NSInteger i = 0; i < self.tagsTeamRecentSession.count; ) {
//        if (self.tagsTeamRecentSession[i].count == 0) {
//            [self.tagsTeamRecentSession removeObjectAtIndex:i];
//        } else {
//            i++;
//        }
//    }
}
// 对默认列表进行排序, 
- (void)screeningDefaultSessionAllTeamRecentSession:(NSMutableArray<NIMRecentSession* > *)allRecentSession {
    
        [self.lockTeamRecentSession removeAllObjects];
    
        //将最新回话里面所有设置上锁, 非置顶的群回话抽取出来.
        self.TeamRecentSession = [allRecentSession mutableCopy];
        self.topTeamCount = 0;
        //计算置顶个数.与上锁群个数
        for (NSInteger i = 0; i < self.TeamRecentSession.count; i++) {
            NIMRecentSession* recentSession = self.TeamRecentSession[i];
            YZHTeamExtManage* teamExt = [YZHTeamExtManage teamExtWithTeamId:recentSession.session.sessionId];
            if (teamExt.team_top) {
                ++ self.topTeamCount;
            } else if (teamExt.team_lock) {
                //直接添加到上锁群回话列表中
                if (self.lockTeamRecentSession.count) {
                    [self.lockTeamRecentSession addObject:recentSession];
                } else {
                    self.lockTeamRecentSession = [[NSMutableArray alloc] init];
                    [self.lockTeamRecentSession addObject:recentSession];
                }
                [self.TeamRecentSession removeObject:recentSession];
                i--;
            }
        }
        //先检查是否存在置顶,如果存在并且有上锁群,则插入到第二行,否则在最前
        if (self.topTeamCount) {
            if (self.lockTeamRecentSession.count) {
                self.tagsTeamRecentSession[1] = self.lockTeamRecentSession;
            }
        } else {
            if (self.lockTeamRecentSession.count) {
                self.tagsTeamRecentSession[0] = self.lockTeamRecentSession;
            }
        }
        // 去掉不包含回话的数组.
        for (NSInteger i = 0; i < self.tagsTeamRecentSession.count;) {
            if (self.tagsTeamRecentSession[i].count == 0) {
                [self.tagsTeamRecentSession removeObjectAtIndex:i];
            } else {
                i++;
            }
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

- (void)customSortTeamRecents:(NSMutableArray *)recentSessions
{
    // 这里只需要遍历一次即可.然后等收到群通知时,在进行编译.
    for (NSInteger i = 0 ; i < recentSessions.count; i++) {
        NIMRecentSession* recentSession = recentSessions[i];
        BOOL isSessionTypeTeam = NO;
        if (recentSession.session.sessionType == NIMSessionTypeTeam) {
            isSessionTypeTeam = YES;
        }
        if (!isSessionTypeTeam) {
            [recentSessions removeObjectAtIndex:i];
            i--;
        }
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[recentSessions copy]];
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
    [self setValue:array forKey:@"TeamRecentSession"];
}


- (void)screeningAllTeamRecentSession:(NSMutableArray<NIMRecentSession *> *)allRecentSession {
    
    if (allRecentSession.count) {
        NSLog(@"群聊排序开始");
        [self screeningTagSessionAllTeamRecentSession:allRecentSession];
        [self sortTagTeamRecentSession];
        [self screeningDefaultSessionAllTeamRecentSession:allRecentSession];
        [self customSortTeamRecents:self.TeamRecentSession];
        NSLog(@"群聊排序结束");
    }
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
    [tagsArray addObject:@"无分类群"];
    
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
