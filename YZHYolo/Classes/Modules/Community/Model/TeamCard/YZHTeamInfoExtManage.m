//
//  YZHTeamInfoExtManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamInfoExtManage.h"

@implementation YZHTeamRecruit

- (instancetype)initWithContent:(NSString *)content {
    
    self = [super init];
    if (self) {
        if (YZHIsString(content)) {
            
            _content = content;
            _isValid = YES;
            
            NSDate *date = [NSDate date];
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy年MM月dd号 HH:mm:ss";
            NSString *dateString = [fmt stringFromDate:date];
            
            _sendTime = dateString;
        } else {
            _content = @"";
            _isValid = NO;
            _sendTime = @"";
            
        }
        //配置时间
    }
    return self;
}

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
        self = [self configuration];
    }
    return self;
}

- (instancetype)configuration {
    
    //如何确保每次读取到的都是最新的？
    NSString* teamInfoExt = [[[NIMSDK sharedSDK] teamManager] teamById:_teamId].clientCustomInfo;
    if (YZHIsString(teamInfoExt)) {
        return [self YZH_setKeyValues:teamInfoExt];
    } else {
        return [[YZHTeamInfoExtManage alloc] initCreatTeamWithTeamLabel:nil recruit:nil];
    }
}

- (instancetype)initCreatTeamWithTeamLabel:(NSArray* )teamLabel recruit:(YZHTeamRecruit* )recruit {
    
    self = [super init];
    if (self) {
        _labelArray = teamLabel;
        _recruit = recruit;
        [self creatTeamConfiguration];
    }
    return self;
}

- (void)creatTeamConfiguration {
    
    if (YZHIsArray(_labelArray)) {
        self.labelArray = _labelArray;
    }
    self.recruit = _recruit ? _recruit : nil;
    self.sendTeamCard = YES; // 默认可发送名片
    self.isShareTeam = NO; // 暂时设置成 NO.
    self.function = @"1"; //高级群
    self.addAndChat = @"1"; // 允许
    
}

@end


