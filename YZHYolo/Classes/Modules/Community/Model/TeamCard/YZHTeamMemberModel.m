//
//  YZHTeamMemberModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamMemberModel.h"

@implementation YZHTeamMemberModel

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
    bool isManage = [userId isEqual:self.teamOwner];
    
    return isManage;
}

- (NSString *)teamOwner {
    
    if (!_teamOwner) {
       NSString* teamManage = [[[NIMSDK sharedSDK] teamManager] teamById:self.teamId].owner;
        _teamOwner = teamManage;
    }
    return _teamOwner;
}

- (NSArray<YZHContactMemberModel *> *)memberArray {
    
    if (!_memberArray) {
        
        _memberArray = [self teamMemberArray];
    }
    return _memberArray;
}

@end
