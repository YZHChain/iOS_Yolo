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

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
        NIMTeam* team = [[[NIMSDK sharedSDK] teamManager] teamById:_groupID];
        _avatarUrl = team.avatarUrl ? team.avatarUrl : @"team_cell_photoImage_default";
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
