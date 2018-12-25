//
//  YZHChatContentUtil.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHChatContentUtil.h"

#import "YZHServicesConfig.h"
@implementation YZHChatContentUtil

+ (void)checkoutContentContentTeamId:(NSString *)teamId completion:(void(^)(NIMTeam *team))completion {
    
    if ([teamId containsString:kYZHTeamURLHostKey] && [teamId containsString:@"teamId"]) {
        NSString* teamIdBase64 = [teamId componentsSeparatedByString:@"teamId="].lastObject;
        NSData* decodedData = [[NSData alloc] initWithBase64EncodedString:teamIdBase64 options:0];
        NSString* teamIdString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:teamIdString completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
            if (!error) {
                completion ? completion(team) : NULL;
            } else {
                completion ? completion(nil) : NULL;
            }
        }];
    } else {
        completion ? completion(nil) : NULL;
    }
}

+ (NSString *)createTeamURLWithTeamId:(NSString *)teamId {
    
    NSData *teamIdData =  [teamId dataUsingEncoding:NSUTF8StringEncoding];
    NSString* teamIdBase64String = [teamIdData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString* urlServerString;
    //只有 DEBUG 时,才会切环境,否则默认都是使用正式服务地址.
#if DEBUG
    //  配置测试服,会检测是否开启、
    urlServerString = [YZHServicesConfig debugTestServerConfig];
#else
    urlServerString = [YZHServicesConfig stringForKey:kYZHAppConfigServerAddr];
#endif
    NSString* teamURL = [NSString stringWithFormat:@"%@/yolo-web/html/register/community.html?teamId=%@",urlServerString , teamIdBase64String];
    
    return teamURL;
}

@end
