//
//  YZHAtMemberModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAtMemberModel.h"

@implementation YZHAtMemberModel

- (instancetype)initWithTeamId:(NSString *)teamId {
    
    self = [super init];
    if (self) {
        _teamId = teamId;
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
    }
    return self;
}

- (BOOL)isManage {
    
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    NSString* teamManage = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId].owner;
    bool isManage = [userId isEqual:teamManage];

    return isManage;
}
@end
