//
//  YZHSpeedyResponseAttachment.m
//  YZHYolo
//
//  Created by Jersey on 2018/11/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSpeedyResponseAttachment.h"

#import "M80AttributedLabel.h"
#import "M80AttributedLabel+NIMKit.h"
#import "YZHSessionMsgConverter.h"

@interface YZHSpeedyResponseAttachment()

@property (nonatomic,strong) M80AttributedLabel *label;

@end

@implementation YZHSpeedyResponseAttachment

- (nonnull NSString *)encodeAttachment {
    
    NSDictionary* dict = @{
                           CustomMessageType: @(CustomMessageTypeSpeedyRespond),
                           CustomMessageData: @{
                                   
                                   @"titleText": self.titleText ? self.titleText : @"",
                                   @"senderUserId": self.senderUserId ? self.senderUserId : @"",
                                   @"teamNickName": self.teamNickName? self.teamNickName : @"",
                                   @"sendUserName": self.senderUserName? self.senderUserName : @"",
                                   @"isSender": [NSNumber numberWithBool:self.isSender],
                                   @"canGet": [NSNumber numberWithBool:_isReceive],
                                   @"isResponse": [NSNumber numberWithBool:_isResponse],
                                   @"canFinish": [NSNumber numberWithBool:_isHandle],
                                   }
                           };
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString* content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return content;
}

- (instancetype)initWithTitleText:(NSString *)titleText senderUserId:(NSString *)senderUserId teamNickName:(nonnull NSString *)teamNickName senderUserName:(NSString *)senderUserName {
    self = [super init];
    if (self) {
        _titleText = titleText;
        _senderUserId = senderUserId;
        _teamNickName = teamNickName;
        _senderUserId = senderUserName;
        _isReceive = NO;
        _isResponse = NO;
        _isHandle = NO;
        _isSender = YES;
    }
    return self;
}
#pragma mark -- YZHCustomAttachmentInfo

- (NSString *)cellContent:(NIMMessage *)message {
    
    return @"YZHSpeedyResponseContentView";
}
// 计算内容视图大小, 最终Cell 大小会在NIMSessionTableAdapter.m 里面计算. 加上 内容视图与Cell 边距等.
- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width {
    NSString *text = message.text;
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:message];
    self.label.font = setting.font;
    
    [self.label nim_setText:text];
    CGFloat msgBubbleMaxWidth    = (width - 130);
    CGFloat bubbleLeftToContent  = 14;
    CGFloat contentRightToBubble = 14;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
    
    CGSize contentSize = [self.label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    if (!self.isSender && contentSize.width <= 165) {
        return CGSizeMake(165, contentSize.height);
    } else {
        return contentSize;
    }
}

- (BOOL)canBeRevoked {
    
    return YES;
}

- (BOOL)canBeForwarded {
    
    return NO;
}

- (BOOL)isSender {
    
    NSString* userId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    if ([self.senderUserId isEqualToString:userId]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Private
- (M80AttributedLabel *)label
{
    if (_label) {
        return _label;
    }
    _label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
    return _label;
}

@end
