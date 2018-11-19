//
//  YZHTeamCardAttachment.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHTeamCardAttachment.h"

@implementation YZHTeamCardAttachment

- (NSString *)encodeAttachment {
    
    NSDictionary *dict = @{
                           CustomMessageType : @( CustomMessageTypeTeamCard),
                           CustomMessageData : @{ @"groupID" : self.groupID? self.groupID : @"",
                                       @"groupName" : self.groupName?self.groupName : @"",
                                       @"groupSynopsis": self.groupSynopsis?
                                       self.groupSynopsis : @"",
                                       @"groupUrl": self.groupUrl?
                                       self.groupUrl : @"",                 }
                           };
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return content;
}

#pragma mark -- YZHCustomAttachmentInfo

- (NSString *)cellContent:(NIMMessage *)message {
    
    return @"YZHTeamCardContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    return CGSizeMake(250, 123);
}

#pragma mark Get Set

- (NSString *)titleName {
    
    if (!_titleName) {
        _titleName = @"群名片分享";
    }
    return _titleName;
}

- (NSString *)avatarUrl {
    
    if (!_avatarUrl) {
        //先读取本地,本地没有,在去服务器下拉.TODOTODO
        //        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[self.account] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        //            if (!error) {
        //                self->_avatarUrl = users.firstObject.userInfo.avatarUrl ? users.firstObject.userInfo.avatarUrl : @"addBook_cover_cell_photo_default";
        //            }
        //        }];
//        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:_groupID];
        _avatarUrl = @"team_createTeam_avatar_icon_normal";
    }
    return _avatarUrl;
}

- (BOOL)canBeRevoked {
    
    return YES;
}

- (BOOL)canBeForwarded {
    
    return YES;
}

@end
