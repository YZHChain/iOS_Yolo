//
//  YZHBlackContacts.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBlackContacts.h"

#import "NIMKitInfoFetchOption.h"
#import "YZHContactMemberModel.h"

@implementation YZHBlackContacts

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.groupTitleComparator = ^NSComparisonResult(NSString* obj1, NSString* obj2) {
            if ([obj1 isEqualToString:@"#"]) {
                return NSOrderedDescending;
            }
            if ([obj2 isEqualToString:@"#"]) {
                return NSOrderedAscending;
            }
            return [obj1 compare:obj2];
        };
        self.groupMemberComparator = ^NSComparisonResult(NSString *key1, NSString *key2) {
            return [key1 compare:key2];
        };
        //获取好友列表
        [self update];
    }
    return self;
}

- (void)update {
    
    NSMutableArray *contacts = [NSMutableArray array];
    for (NIMUser* user in [NIMSDK sharedSDK].userManager.myBlackList) {
        NIMKitInfoFetchOption* infoFetchOption = [[NIMKitInfoFetchOption alloc] initWithIsAddressBook:YES];
        NIMKitInfo* kitInfo = [[NIMKit sharedKit] infoByUser:user.userId option:infoFetchOption];
        YZHContactMemberModel* memberModel = [[YZHContactMemberModel alloc] initWithInfo:kitInfo];
        [contacts addObject:memberModel];
    }
    [self setMembers:contacts];
}


@end
