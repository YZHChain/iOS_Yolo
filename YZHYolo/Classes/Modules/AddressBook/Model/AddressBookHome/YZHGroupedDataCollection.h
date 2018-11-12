//
//  YZHGroupedDataCollection.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YZHGroupMemberProtocol <NSObject>

- (NSString *)groupTitle;
- (NSString *)memberId;
- (id)sortKey;

@end

@interface YZHGroupedDataCollection : NSObject

@property (nonatomic, strong) NSArray *members;
@property (nonatomic, readonly) NSArray *sortedGroupTitles;
@property (nonatomic, copy) NSComparator groupTitleComparator;
@property (nonatomic, copy) NSComparator groupMemberComparator;

- (void)addGroupMember:(id<YZHGroupMemberProtocol>)member;

- (void)removeGroupMember:(id<YZHGroupMemberProtocol>)member;

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members;

//
- (NSString *)titleOfGroup:(NSInteger)groupIndex;
//
- (NSArray *)membersOfGroup:(NSInteger)groupIndex;

- (id<YZHGroupMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath;
//
- (id<YZHGroupMemberProtocol>)memberOfId:(NSString *)uid;

- (NSInteger)groupTitleCount;

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex;

@end

NS_ASSUME_NONNULL_END
