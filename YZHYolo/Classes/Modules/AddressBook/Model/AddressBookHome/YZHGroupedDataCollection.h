//
//  YZHGroupedDataCollection.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YZHGroupMemberProtocol <NSObject>

- (NSString *)groupTitle;
- (NSString *)groupTagTitle;
- (NSString *)memberId;
- (id)sortKey;

@end

@interface YZHGroupedDataCollection : NSObject

@property (nonatomic, strong) NSArray *members;
@property (nonatomic, readonly) NSArray *sortedGroupTitles;
@property (nonatomic, copy) NSComparator groupTitleComparator;
@property (nonatomic, copy) NSComparator groupMemberComparator;
//@property (nonatomic, strong) NSMutableOrderedSet* groupTtiles;
//@property (nonatomic, strong) NSMutableOrderedSet* groups;

- (void)addGroupMember:(id<YZHGroupMemberProtocol>)member;
- (void)removeGroupMember:(id<YZHGroupMemberProtocol>)member;
- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members;

//- (NSString *)titleOfGroup:(NSInteger)groupIndex;
//
//- (NSArray *)membersOfGroup:(NSInteger)groupIndex;
//
//- (NSArray *)atMembersOfGroup:(NSInteger)groupIndex;
// 获取所有群联系人列表
- (NSMutableArray *)teamMemberArray;
// 适用于通讯联系人,展示列表. 传入的Section 做了处理.
- (id<YZHGroupMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath;
// 适用于AtManage 联系人,展示列表.
- (id<YZHGroupMemberProtocol>)atMemberOfIndex:(NSIndexPath *)indexPath;
// 使用于 TeamMember 管理,列表展示.
- (id<YZHGroupMemberProtocol>)teamMemberOfIndex:(NSIndexPath *)indexPath;

- (id<YZHGroupMemberProtocol>)sharedMemberOfIndex:(NSIndexPath *)indexPath;

//- (id<YZHGroupMemberProtocol>)memberOfId:(NSString *)uid;

- (NSInteger)groupMemberCount;
- (NSInteger)groupTitleCount;
// 适用于通讯联系人,展示列表. 传入的Section 做了处理.
- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex;
// 通讯录好友列表搜索
- (NSMutableArray<YZHContactMemberModel *>*)searchFirendKeyText:(NSString *)keyText;
- (NSMutableArray<YZHContactMemberModel *>*)searchFirendTagName:(NSString *)tagName;

- (void)setTeamMembers:(NSArray *)members; //设置成员, 不用过滤自己.

@end

NS_ASSUME_NONNULL_END
