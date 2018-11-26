//
//  YZHCellLayoutConfign.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCellLayoutConfign.h"

#import "YZHSessionCustomLayoutConfign.h"

@interface YZHCellLayoutConfign()

@property (nonatomic, strong) NSArray *messageTypes;
@property (nonatomic, strong) YZHSessionCustomLayoutConfign* sessionCustomLayoutConfign;
@end

@implementation YZHCellLayoutConfign

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _messageTypes = @[
                          @"YZHUserCardAttachment",
                          @"YZHTeamCardAttachment",
                          @"YZHSpeedyResponseAttachment",
                          @"YZHAddFirendAttachment",
                          @"YZHRequstAddFirendAttachment",
                          ];
        _sessionCustomLayoutConfign = [[YZHSessionCustomLayoutConfign alloc] init];
    }
    return self;
}

#pragma mark - NIMCellLayoutConfig
//Cell 大小
- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width{
    
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedUserCustomMessage:message] && [[_sessionCustomLayoutConfign infoWithMessage:message] respondsToSelector:@selector(contentSize:cellWidth:)])
    {
        return [_sessionCustomLayoutConfign contentSize:width message:message];
    }

    //如果没有特殊需求，就走默认处理流程
    return [super contentSize:model
                    cellWidth:width];
}

- (NSString *)cellContent:(NIMMessageModel *)model{
    
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedUserCustomMessage:message] && [[_sessionCustomLayoutConfign infoWithMessage:message] respondsToSelector:@selector(cellContent:)]) {
        return [_sessionCustomLayoutConfign cellContent:message];
    }
    //如果没有特殊需求，就走默认处理流程
    return [super cellContent:model];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model
{
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedUserCustomMessage:message] && [[_sessionCustomLayoutConfign infoWithMessage:message] respondsToSelector:@selector(contentViewInsets:)]) {
        return [_sessionCustomLayoutConfign contentViewInsets:message];
    }
    //如果没有特殊需求，就走默认处理流程
    return [super contentViewInsets:model];
}

//Jersey IM:设置气泡在 Cell 的间距.
- (UIEdgeInsets)cellInsets:(NIMMessageModel *)model
{
   return [super cellInsets:model];
}

// 是否展示头像.
- (BOOL)shouldShowAvatar:(NIMMessageModel *)model {
    
    NIMMessage *message = model.message;
    //检查是不是当前支持的自定义消息类型
    if ([self isSupportedUserCustomMessage:message]) {
        return [_sessionCustomLayoutConfign shouldShowAvatar:message];
    }
    //如果没有特殊需求，就走默认处理流程
    return [super shouldShowAvatar:model];
}

#pragma mark - misc

- (BOOL)isSupportedUserCustomMessage:(NIMMessage *)message
{
    NIMCustomObject *object = (NIMCustomObject* )message.messageObject;
    return [object isKindOfClass:[NIMCustomObject class]] &&
    [_messageTypes indexOfObject:NSStringFromClass([object.attachment class])] != NSNotFound;
}

@end

