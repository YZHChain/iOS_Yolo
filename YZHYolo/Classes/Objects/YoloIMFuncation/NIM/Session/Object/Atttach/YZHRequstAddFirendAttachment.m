//
//  YZHRequstAddFirendAttachment.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHRequstAddFirendAttachment.h"

@implementation YZHRequstAddFirendAttachment

- (nonnull NSString *)encodeAttachment {
    
    NSDictionary* dict = @{
                           CustomMessageType: @(CustomMessageTypeRequstAddFirend),
                           CustomMessageData: @{
                                   @"addFirendTitle": self.addFirendTitle ? self.addFirendTitle : @"",
                                   }
                           };
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return content;
}

#pragma mark -- YZHCustomAttachmentInfo

- (NSString *)cellContent:(NIMMessage *)message {
    
    return @"YZHRequstAddFirendContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    
    return CGSizeMake(width, 50);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)shouldShowAvatar:(NIMMessage *)message {
    
    return NO;
}

@end
