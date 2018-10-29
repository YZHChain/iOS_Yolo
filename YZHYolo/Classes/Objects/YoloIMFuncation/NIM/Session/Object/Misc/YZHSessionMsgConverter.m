//
//  YZHSessionMsgConverter.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSessionMsgConverter.h"

@implementation YZHSessionMsgConverter

+ (NIMMessage*)msgWithText:(NSString*)text
{
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text        = text;
    return textMessage;
}

//+ (NIMMessage*)msgWithImage:(UIImage*)image
//{
//    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
//    return [NTESSessionMsgConverter generateImageMessage:imageObject];
//}
//
//+ (NIMMessage *)msgWithImagePath:(NSString*)path
//{
//    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithFilepath:path];
//    return [NTESSessionMsgConverter generateImageMessage:imageObject];
//}

+ (NIMMessage *)generateImageMessage:(NIMImageObject *)imageObject
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    imageObject.displayName = [NSString stringWithFormat:@"图片发送于%@",dateString];
    NIMImageOption *option  = [[NIMImageOption alloc] init];
    option.compressQuality  = 0.8;
    imageObject.option = option;
    NIMMessage *message     = [[NIMMessage alloc] init];
    message.messageObject   = imageObject;
    message.apnsContent = @"发来了一张图片";
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.scene = NIMNOSSceneTypeMessage;
    message.setting = setting;
    return message;
}


+ (NIMMessage*)msgWithAudio:(NSString*)filePath
{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = audioObject;
    message.apnsContent = @"发来了一段语音";
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.scene = NIMNOSSceneTypeMessage;
    message.setting = setting;
    return message;
}

+ (NIMMessage*)msgWithVideo:(NSString*)filePath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:filePath];
    videoObject.displayName = [NSString stringWithFormat:@"视频发送于%@",dateString];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = videoObject;
    message.apnsContent = @"发来了一段视频";
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.scene = NIMNOSSceneTypeMessage;
    message.setting = setting;
    return message;
}

+ (NIMMessage *)msgWithTip:(NSString *)tip
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMTipObject *tipObject    = [[NIMTipObject alloc] init];
    message.messageObject      = tipObject;
    message.text               = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    setting.shouldBeCounted    = NO;
    message.setting            = setting;
    return message;
}

+ (NIMMessage *)msgWithUserCard:(YZHUserCardAttachment* )attachment {
    
    NIMMessage* message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    //推送文案
    message.apnsContent = [NSString stringWithFormat:@"%@发来了名片", attachment.userName];
    
    return message;
}

+ (NIMMessage *)msgWithTeamCard:(YZHTeamCardAttachment *)attachment {
    
    NIMMessage* message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    //推送文案
    message.apnsContent = [NSString stringWithFormat:@"%@发来了名片", attachment.groupName];
    return message;
}

+ (NIMMessage *)msgWithAddFirend:(YZHAddFirendAttachment *)attachment {
    
    NIMMessage* message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    //推送文案
//    message.apnsContent = [NSString stringWithFormat:@"%@发来了名片", attachment.groupName];
    return message;
}

+ (NIMMessage *)msgWithRequstAddFirend:(YZHRequstAddFirendAttachment *)attachment {
    
    NIMMessage* message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    return message;
}
@end
