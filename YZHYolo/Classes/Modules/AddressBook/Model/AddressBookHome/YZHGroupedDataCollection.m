//
//  YZHGroupedDataCollection.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHGroupedDataCollection.h"

@interface Pair : NSObject

@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;

@end

@implementation Pair

- (instancetype)initWithFirst:(id)first second:(id)second {
    self = [super init];
    if(self) {
        _first = first;
        _second = second;
    }
    return self;
}

@end

@interface YZHGroupedDataCollection () {
    NSMutableOrderedSet *_specialGroupTtiles; //特殊非字符标题集合
    NSMutableOrderedSet *_specialGroups; //特殊非字符标题Model集合
    NSMutableOrderedSet *_groupTtiles;   //全体标题集合
    NSMutableOrderedSet *_groups; //成员与标题集合
}

@end

@implementation YZHGroupedDataCollection

- (instancetype)init
{
    self = [super init];
    if(self) {
        _specialGroupTtiles = [[NSMutableOrderedSet alloc] init];
        _specialGroups = [[NSMutableOrderedSet alloc] init];
        _groupTtiles = [[NSMutableOrderedSet alloc] init];
        _groups = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (NSArray *)sortedGroupTitles
{
    return [_groupTtiles array];
}

- (void)setMembers:(NSArray *)members {
    
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    //将全体成员一次取出, 保存到以 Key 为 首字母 value 为 成员Model 的可变数组
    for (id<YZHGroupMemberProtocol>member in members) {
        if ([[member memberId] isEqualToString:me]) {
            continue;
        }
        NSString *groupTitle = [member groupTitle];
        NSMutableArray *groupedMembers = [tmp objectForKey:groupTitle];
        if(!groupedMembers) {
            groupedMembers = [NSMutableArray array];
        }
        [groupedMembers addObject:member];
        [tmp setObject:groupedMembers forKey:groupTitle];
    }
    [_groupTtiles removeAllObjects];
    [_groups removeAllObjects];
    // 遍历字典, 取出每个 Key, 保存到 _groupTtitles 中.
    // Value 以 Pair 对象的形式保存到 _groups 方便后续排序
    @weakify(self)
    [tmp enumerateKeysAndObjectsUsingBlock:^(NSString *groupTitle, NSMutableArray *groupedMembers, BOOL *stop) {
        @strongify(self)
        unichar character = [groupTitle characterAtIndex:0];
        if (character >= 'A' && character <= 'Z') {
            [self->_groupTtiles addObject:groupTitle];
        }else{
            [self->_groupTtiles addObject:@"#"];
        }
        [self->_groups addObject:[[Pair alloc] initWithFirst:groupTitle second:groupedMembers]];
    }];
    [self sort];
}

- (void)addGroupMember:(id<YZHGroupMemberProtocol>)member
{
    NSString *groupTitle = [member groupTitle];
    NSInteger groupIndex = [_groupTtiles indexOfObject:groupTitle];
    Pair *pair = [_groups objectAtIndex:groupIndex];
    if(!pair) {
        NSMutableArray *members = [NSMutableArray array];
        pair = [[Pair alloc] initWithFirst:groupTitle second:members];
    }
    NSMutableArray *members = pair.second;
    [members addObject:member];
    [_groupTtiles addObject:groupTitle];
    [_groups addObject:pair];
    [self sort];
}

- (void)removeGroupMember:(id<YZHGroupMemberProtocol>)member{
    NSString *groupTitle = [member groupTitle];
    NSInteger groupIndex = [_groupTtiles indexOfObject:groupTitle];
    Pair *pair = [_groups objectAtIndex:groupIndex];
    [pair.second removeObject:member];
    if (![pair.second count]) {
        [_groups removeObject:pair];
    }
    [self sort];
}

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members {
    Pair *pair = [[Pair alloc] initWithFirst:title second:members];
    [_specialGroupTtiles addObject:title];
    [_specialGroups addObject:pair];
}

- (id<YZHGroupMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath {
    
    NSArray *members = nil;
    //由于未将第一个分区加入;
    NSInteger groupIndex = indexPath.section - 1;
    if(groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        members = pair.second;
    }
    NSInteger memberIndex = indexPath.row;
    if (memberIndex < 0 || memberIndex >= members.count) {
        return nil;
    } else {
        return [members objectAtIndex:indexPath.row];
    }
}

- (id<YZHGroupMemberProtocol>)atMemberOfIndex:(NSIndexPath *)indexPath {
    NSArray *members = nil;
    NSInteger groupIndex = indexPath.section;
    if(groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        members = pair.second;
    }
    NSInteger memberIndex = indexPath.row;
    if (memberIndex < 0 || memberIndex >= members.count) {
        return nil;
    } else {
        return [members objectAtIndex:indexPath.row];
    }
}

- (id<YZHGroupMemberProtocol>)sharedMemberOfIndex:(NSIndexPath *)indexPath {
    
    NSArray *members = nil;
    //由于未将第一个分区加入; 暂时先把逻辑写到这里, 后面需将其拆分出去,否则严重影响复用.
    NSInteger groupIndex = indexPath.section;
    if(groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        members = pair.second;
    }
    NSInteger memberIndex = indexPath.row;
    if (memberIndex < 0 || memberIndex >= members.count) {
        return nil;
    } else {
        return [members objectAtIndex:indexPath.row];
    }
}
// 带标题字符数量
- (NSInteger)groupTitleCount
{
    //全体标题加上其他非标题的模块
    return _groupTtiles.count;
}

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex
{
    NSArray *members = nil;
//    if(groupIndex >= 0 && groupIndex < _specialGroups.count) {
//        Pair *pair = [_specialGroups objectAtIndex:groupIndex];
//        members = pair.second;
//    }
    if(groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        members = pair.second;
    }
    return members.count;
}

- (void)sort
{
    [self sortGroupTitle];
    [self sortGroupMember];
}

- (void)sortGroupTitle {
    //标题排序
    [_groupTtiles sortUsingComparator:_groupTitleComparator];
    //集合内使其按标题来进行排序
    [_groups sortUsingComparator:^NSComparisonResult(Pair *pair1, Pair *pair2) {
        return self->_groupTitleComparator(pair1.first, pair2.first);
    }];
}

- (void)sortGroupMember {
    //遍历集合内对象,依次取出每个对象中的成员数组,在对数组进行排序,规则为每个成员展示名字的全体拼音。
    [_groups enumerateObjectsUsingBlock:^(Pair *obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *groupedMembers = obj.second;
        [groupedMembers sortUsingComparator:^NSComparisonResult(id<YZHGroupMemberProtocol> member1, id<YZHGroupMemberProtocol> member2) {
            return self->_groupMemberComparator([member1 sortKey], [member2 sortKey]);
        }];
    }];
}

- (void)setGroupTitleComparator:(NSComparator)groupTitleComparator
{
    _groupTitleComparator = groupTitleComparator;
    [self sortGroupTitle];
}

- (void)setGroupMemberComparator:(NSComparator)groupMemberComparator
{
    _groupMemberComparator = groupMemberComparator;
    [self sortGroupMember];
}

@end
