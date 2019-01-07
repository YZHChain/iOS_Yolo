//
//  YZHTagContactManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTagContactManage.h"

#import "NIMKitInfoFetchOption.h"
#import "YZHContactMemberModel.h"
#import "YZHUserModelManage.h"

@interface YZHTagContactManage()

@end

@implementation YZHTagContactManage {
    
    NSMutableDictionary* _groupMutableDictionary;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
//        self.groupMemberComparator = ^NSComparisonResult(NSString *key1, NSString *key2) {
//            return [key1 compare:key2];
//        };
        [self update];
    }
    return self;
}

- (void)update {
    
    NSMutableArray *contacts = [NSMutableArray array];
    for (NIMUser* user in [NIMSDK sharedSDK].userManager.myFriends) {
        //去除黑名单成员
        if ([[NIMSDK sharedSDK].userManager isUserInBlackList:user.userId]) {
            continue;
        }
        NIMKitInfoFetchOption* infoFetchOption = [[NIMKitInfoFetchOption alloc] initWithIsAddressBook:YES];
        NIMKitInfo* kitInfo = [[NIMKit sharedKit] infoByUser:user.userId option:infoFetchOption];
        YZHContactMemberModel* memberModel = [[YZHContactMemberModel alloc] initWithInfo:kitInfo];
        [contacts addObject:memberModel];
    }
    [self setMembers:contacts];
}

- (void)setMembers:(NSArray *)members {
    
    //分类.
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    //将全体成员一次取出, 保存到以 Key 为 首字母 value 为 成员Model 的可变数组
    for (id<YZHGroupMemberProtocol>member in members) {
        if ([[member memberId] isEqualToString:me]) {
            continue;
        }
        NSString *groupTitle = [member groupTagTitle];
        NSMutableArray *groupedMembers = [tmp objectForKey:groupTitle];
        if(!groupedMembers) {
            groupedMembers = [NSMutableArray array];
        }
        [groupedMembers addObject:member];
        [tmp setObject:groupedMembers forKey:groupTitle];
        
    }
    _groupMutableDictionary = tmp;
    [self configurationData];
}

- (void)configurationData {
    
    [self configurationTagName];
    [self configurationTagContacts];
}

- (void)configurationTagName {
    
    self.tagNameArray = [[NSMutableArray alloc] init];
    
    YZHUserInfoExtManage* userInfoExt = [YZHUserInfoExtManage currentUserInfoExt];
    
//    [userInfoExt.groupTags enumerateObjectsUsingBlock:^(YZHUserGroupTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.tagNameArray addObject:obj.tagName];
//    }];
    
    [userInfoExt.customTags enumerateObjectsUsingBlock:^(YZHUserCustomTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tagNameArray addObject:obj.tagName];
    }];
    [self.tagNameArray addObject:@"其他好友"];
    
}

- (void)configurationTagContacts {
    
    self.tagContacts = [[NSMutableArray alloc] initWithCapacity:self.tagNameArray.count];
    self.showTagNameArray = [[NSMutableArray alloc] init];
    for (NSString* tagName in self.tagNameArray) {
        NSLog(@"循环%@", tagName);
        NSMutableArray* contentContacts = [_groupMutableDictionary objectForKey:tagName];
        if (contentContacts) {

            [self.tagContacts addObject:contentContacts];
            [self.showTagNameArray addObject:tagName];
        }
    }
    for (NSString* tagName in _groupMutableDictionary.allKeys) {
        if (![self.tagNameArray containsObject:tagName]) {
            NSMutableArray* contentContacts = [_groupMutableDictionary objectForKey:tagName];
            for (id obj in contentContacts) {
                [self.tagContacts.lastObject addObject:obj];
            }
        }
    }
}

@end
