//
//  YZHSessionCustomLayoutConfign.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSessionCustomLayoutConfign.h"

@implementation YZHSessionCustomLayoutConfign

- (NSString *)cellContent:(NIMMessage *)message {
    
    id<YZHCustomAttachmentInfo> info = [self infoWithMessage:message];
    return [info cellContent:message];
}

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    
    id<YZHCustomAttachmentInfo> info = [self infoWithMessage:message];
    
    return [info contentSize:message cellWidth:cellWidth];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark -- YZHCustomAttachmentInfo
// 是否需要展示头像
-(BOOL)shouldShowAvatar:(NIMMessage *)message {
    
    id<YZHCustomAttachmentInfo> info = [self infoWithMessage:message];
    //未重写则默认显示.
    if ([info respondsToSelector:@selector(shouldShowAvatar:)]) {
        return [info shouldShowAvatar:message];
    } else {
        return YES;
    }
}

#pragma mark -- Util

- (id<YZHCustomAttachmentInfo>)infoWithMessage:(NIMMessage *)message {
    
    NIMCustomObject *object = (NIMCustomObject* )message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    
    return (id<YZHCustomAttachmentInfo>)object.attachment;
}

@end
