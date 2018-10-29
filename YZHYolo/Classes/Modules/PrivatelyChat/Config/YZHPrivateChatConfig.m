//
//  YZHPrivateChatConfig.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHPrivateChatConfig.h"
#import "NIMMediaItem.h"
#import "NTESBundleSetting.h"
//#import "NTESSnapchatAttachment.h"
//#import "NTESWhiteboardAttachment.h"
#import "NSString+NTES.h"
#import "NIMSessionConfig.h"
#import "UIImage+NIMKit.h"

@interface YZHPrivateChatConfig()

@end

@implementation YZHPrivateChatConfig

- (NSArray *)mediaItems
{
    NSArray *defaultMediaItems = [NIMKit sharedKit].config.defaultMediaItems;
    
    NIMMediaItem *janKenPon = [NIMMediaItem item:@"onTapMediaItemJanKenPon:"
                                     normalImage:[UIImage imageNamed:@"icon_jankenpon_normal"]
                                   selectedImage:[UIImage imageNamed:@"icon_jankenpon_pressed"]
                                           title:@"石头剪刀布"];
    
    NIMMediaItem *fileTrans = [NIMMediaItem item:@"onTapMediaItemFileTrans:"
                                     normalImage:[UIImage imageNamed:@"icon_file_trans_normal"]
                                   selectedImage:[UIImage imageNamed:@"icon_file_trans_pressed"]
                                           title:@"文件传输"];
    
    NIMMediaItem *tip       = [NIMMediaItem item:@"onTapMediaItemTip:"
                                     normalImage:[UIImage imageNamed:@"bk_media_tip_normal"]
                                   selectedImage:[UIImage imageNamed:@"bk_media_tip_pressed"]
                                           title:@"提示消息"];
    
    NIMMediaItem *audioChat =  [NIMMediaItem item:@"onTapMediaItemAudioChat:"
                                      normalImage:[UIImage imageNamed:@"btn_media_telphone_message_normal"]
                                    selectedImage:[UIImage imageNamed:@"btn_media_telphone_message_pressed"]
                                            title:@"实时语音"];
    
    NIMMediaItem *videoChat =  [NIMMediaItem item:@"onTapMediaItemVideoChat:"
                                      normalImage:[UIImage imageNamed:@"btn_bk_media_video_chat_normal"]
                                    selectedImage:[UIImage imageNamed:@"btn_bk_media_video_chat_pressed"]
                                            title:@"视频聊天"];
    
    NIMMediaItem *teamMeeting =  [NIMMediaItem item:@"onTapMediaItemTeamMeeting:"
                                        normalImage:[UIImage imageNamed:@"btn_media_telphone_message_normal"]
                                      selectedImage:[UIImage imageNamed:@"btn_media_telphone_message_pressed"]
                                              title:@"视频通话"];
    
//    NIMMediaItem *snapChat =   [NIMMediaItem item:@"onTapMediaItemSnapChat:"
//                                      normalImage:[UIImage imageNamed:@"bk_media_snap_normal"]
//                                    selectedImage:[UIImage imageNamed:@"bk_media_snap_pressed"]
//                                            title:@"阅后即焚"];
    
    NIMMediaItem *whiteBoard = [NIMMediaItem item:@"onTapMediaItemWhiteBoard:"
                                      normalImage:[UIImage imageNamed:@"btn_whiteboard_invite_normal"]
                                    selectedImage:[UIImage imageNamed:@"btn_whiteboard_invite_pressed"]
                                            title:@"白板"];
    
    NIMMediaItem *redPacket  = [NIMMediaItem item:@"onTapMediaItemRedPacket:"
                                      normalImage:[UIImage imageNamed:@"icon_redpacket_normal"]
                                    selectedImage:[UIImage imageNamed:@"icon_redpacket_pressed"]
                                            title:@"红包"];
    
    NIMMediaItem *teamReceipt  = [NIMMediaItem item:@"onTapMediaItemTeamReceipt:"
                                        normalImage:[UIImage imageNamed:@"icon_team_receipt_normal"]
                                      selectedImage:[UIImage imageNamed:@"icon_team_receipt_pressed"]
                                              title:@"已读回执"];
    
    BOOL isMe   = _session.sessionType == NIMSessionTypeP2P
    && [_session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    NSArray *items = @[];
    return [self defaultMediaItems];
    if (isMe)
    {
        items = @[janKenPon,fileTrans,tip];
    }
    else if(_session.sessionType == NIMSessionTypeTeam)
    {
        items = @[janKenPon,teamMeeting,fileTrans,tip,teamReceipt,redPacket];
    }
    else
    {
        items = @[janKenPon,audioChat,videoChat,fileTrans,whiteBoard,tip,redPacket];
    }
    
    
    return [defaultMediaItems arrayByAddingObjectsFromArray:items];
    
}
//Jersey: 关闭处理已读消息回执
- (BOOL)shouldHandleReceipt{
    return NO;
}

- (NSArray<NSNumber *> *)inputBarItemTypes{
    if (self.session.sessionType == NIMSessionTypeP2P && [[NIMSDK sharedSDK].robotManager isValidRobot:self.session.sessionId])
    {
        //和机器人 点对点 聊天
        return @[
                 @(NIMInputBarItemTypeTextAndRecord),
                 ];
        
    }
    return @[
             @(NIMInputBarItemTypeVoice),
             @(NIMInputBarItemTypeTextAndRecord),
             @(NIMInputBarItemTypeEmoticon),
             @(NIMInputBarItemTypeMore)
             ];
}
/*
- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
    if (type == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        id attachment = object.attachment;
        
        if ([attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
            return NO;
        }
    }
    
    
    
    return type == NIMMessageTypeText ||
    type == NIMMessageTypeAudio ||
    type == NIMMessageTypeImage ||
    type == NIMMessageTypeVideo ||
    type == NIMMessageTypeFile ||
    type == NIMMessageTypeLocation ||
    type == NIMMessageTypeCustom;
}
 */

- (NSArray<NIMInputEmoticonCatalog *> *)charlets
{
    return [self loadChartletEmoticonCatalog];
}

- (BOOL)disableProximityMonitor{
    return [[NTESBundleSetting sharedConfig] disableProximityMonitor];
}

- (BOOL)autoFetchAttachment {
    return [[NTESBundleSetting sharedConfig] autoFetchAttachment];
}

- (NIMAudioType)recordType
{
    return [[NTESBundleSetting sharedConfig] usingAmr] ? NIMAudioTypeAMR : NIMAudioTypeAAC;
}


- (NSArray *)loadChartletEmoticonCatalog{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"NIMKitResource.bundle"
                                         withExtension:nil];
    //TODO 异常捕获
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSArray  *paths   = [bundle pathsForResourcesOfType:nil inDirectory:@""];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSString *path in paths) {
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            NIMInputEmoticonCatalog *catalog = [[NIMInputEmoticonCatalog alloc]init];
            catalog.catalogID = path.lastPathComponent;
            NSArray *resources = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:@"content"]];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *path in resources) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension;
                NIMInputEmoticon *icon  = [[NIMInputEmoticon alloc] init];
                icon.emoticonID = name.stringByDeletingPictureResolution;
                icon.filename   = path;
                [array addObject:icon];
            }
            catalog.emoticons = array;
            
            NSArray *icons     = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:@"icon"]];
            for (NSString *path in icons) {
                NSString *name  = path.lastPathComponent.stringByDeletingPathExtension.stringByDeletingPictureResolution;
                if ([name hasSuffix:@"normal"]) {
                    catalog.icon = path;
                }else if([name hasSuffix:@"highlighted"]){
                    catalog.iconPressed = path;
                }
            }
            [res addObject:catalog];
        }
    }
    return res;
}

- (NSArray *)defaultMediaItems
{
    return @[[NIMMediaItem item:@"onTapMediaItemPicture:"
                    normalImage:[UIImage nim_imageInKit:@"session_media_picture_normal"]
                  selectedImage:[UIImage nim_imageInKit:@"session_media_picture_normal"]
                          title:@"相册"],
             
             [NIMMediaItem item:@"onTapMediaItemShoot:"
                    normalImage:[UIImage nim_imageInKit:@"session_media_shoot_normal"]
                  selectedImage:[UIImage nim_imageInKit:@"session_media_shoot_normal"]
                          title:@"拍摄"],
             
             [NIMMediaItem item:@"onTapMediaItemContact:"
                    normalImage:[UIImage nim_imageInKit:@"session_media_contacts_normal"]
                  selectedImage:[UIImage nim_imageInKit:@"session_media_contacts_normal"]
                          title:@"联系人"],
             [NIMMediaItem item:@"onTapMediaItemMyGroup:"
                    normalImage:[UIImage nim_imageInKit:@"session_media_myGroup_normal"]
                  selectedImage:[UIImage nim_imageInKit:@"session_media_myGroup_normal"]
                          title:@"我的社群"],
             ];
}

@end

