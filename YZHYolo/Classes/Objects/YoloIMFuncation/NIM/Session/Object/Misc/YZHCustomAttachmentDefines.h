//
//  YZHCustomAttachmentDefines.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#ifndef YZHCustomAttachmentDefines_h
#define YZHCustomAttachmentDefines_h

typedef NS_ENUM(NSInteger,YZHCustomMessageType){
    CustomMessageTypeJanKenPon  = 1, //剪子石头布
    CustomMessageTypeSnapchat   = 2, //阅后即焚
    CustomMessageTypeChartlet   = 3, //贴图表情
    CustomMessageTypeWhiteboard = 4, //白板会话
    CustomMessageTypeRedPacket  = 5, //红包消息
    CustomMessageTypeRedPacketTip = 6, //红包提示消息
    CustomMessageTypeUserCard    = 10, //用户名片分享
    CustomMessageTypeTeamCard    = 11, //群名片分享
    
    CustomMessageTypeAddFirend   = 30, //添加好友
    CustomMessageTypeRequstAddFirend   = 31,
};

#define CustomMessageType             @"type"
#define CustomMessageData             @"data"


#endif /* YZHCustomAttachmentDefines_h */

@protocol YZHCustomAttachmentInfo <NSObject>

@optional

- (NSString *)cellContent:(NIMMessage *)message;

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message;

- (UIEdgeInsets)cellInsets:(NIMMessage *)message;

- (NSString *)formatedMessage;

- (UIImage *)showCoverImage;

- (BOOL)shouldShowAvatar:(NIMMessage *)message;

- (void)setShowCoverImage:(UIImage *)image;

- (BOOL)canBeRevoked;

- (BOOL)canBeForwarded;

@end
