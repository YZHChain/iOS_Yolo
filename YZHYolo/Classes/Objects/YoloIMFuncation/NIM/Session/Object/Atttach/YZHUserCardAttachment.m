//
//  YZHUserCardAttachment.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHUserCardAttachment.h"

#import "YZHCustomAttachmentDefines.h"
@implementation YZHUserCardAttachment

- (NSString *)encodeAttachment {
    
    NSDictionary *dict = @{
                           CustomMessageType : @(CustomMessageTypeUserCard),
                               CustomMessageData : @{ @"userName" : self.userName? self.userName : @"",
                                       @"yoloID" : self.yoloID?self.yoloID : @"",
                                       @"account": self.account?
                                       self.account : @"",
                                                      @"avatarUrl":self.avatarUrl ? self.avatarUrl : @""
                                       }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
    
}

#pragma mark -- YZHCustomAttachmentInfo

- (NSString *)cellContent:(NIMMessage *)message {
    
    return @"YZHUserCardContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    //此消息宽高固定.
    return CGSizeMake(250, 97);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark -- GET SET

-(NSString *)avatarUrl {
    
    if (!_avatarUrl) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:_account];
        _avatarUrl = user.userInfo.avatarUrl ? user.userInfo.avatarUrl : @"addBook_cover_cell_photo_default";
    }
    return _avatarUrl;
}

- (NSString *)titleName {
    
    if (!_titleName) {
        _titleName = @"名片分享";
    }
    return _titleName;
}

- (BOOL)canBeRevoked {
 
    return YES;
}

- (BOOL)canBeForwarded {
    
    return YES;
}
@end
