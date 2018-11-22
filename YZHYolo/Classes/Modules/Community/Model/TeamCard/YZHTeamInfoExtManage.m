//
//  YZHTeamInfoExtManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamInfoExtManage.h"

@implementation YZHTeamRecruit



@end

@implementation YZHTeamInfoExtManage

+ (NSDictionary *)YZH_replacedKeyFromPropertyName {
    
    return @{
             @"labelArray": @"label",
             @"isShareTeam": @"sharedTeam"
             };
}

+ (NSDictionary *)YZH_objectClassInArray {
    
    return @{
             @"labelArray": [NSString class]
             };
}

- (instancetype)initTeamExtWithTeamId:(NSString *)teamId {
    
    self = [super init];
    if (self) {
        _teamId = teamId;
        [self configuration];
    }
    return self;
}

- (void)configuration {
    
    
}

@end


