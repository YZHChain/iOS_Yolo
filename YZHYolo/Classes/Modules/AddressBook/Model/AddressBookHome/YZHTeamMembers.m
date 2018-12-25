//
//  YZHTeamMembers.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMembers.h"

@implementation YZHTeamMembers
{
    NSString* _teamId;
}

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

@end
