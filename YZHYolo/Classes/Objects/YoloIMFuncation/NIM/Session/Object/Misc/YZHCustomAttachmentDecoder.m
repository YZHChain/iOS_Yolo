//
//  YZHCustomAttachmentDecoder.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHCustomAttachmentDecoder.h"
#import "YZHCustomAttachmentDefines.h"
#import "YZHUserCardAttachment.h"
#import "NSDictionary+NTESJson.h"
#import "YZHTeamCardAttachment.h"
#import "YZHAddFirendAttachment.h"
#import "YZHRequstAddFirendAttachment.h"

@implementation YZHCustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content {
    
    id<NIMCustomAttachment> attachment = nil;
    
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (YZHIsDictionary(dict)) {
            NSInteger type     = [dict jsonInteger:CustomMessageType];
            NSDictionary *data = [dict jsonDict:CustomMessageData];
            switch (type) {
                case CustomMessageTypeUserCard:
                    attachment = [YZHUserCardAttachment YZH_objectWithKeyValues:data];
                    break;
                case CustomMessageTypeTeamCard:
                    attachment = [YZHTeamCardAttachment YZH_objectWithKeyValues:data];
                case CustomMessageTypeAddFirend:
                    attachment = [YZHAddFirendAttachment YZH_objectWithKeyValues:data];
                    break;
                case CustomMessageTypeRequstAddFirend:
                    attachment = [YZHRequstAddFirendAttachment YZH_objectWithKeyValues:data];
                    break;
                default:
                    //TODO: 有空可以添加个父类消息解析器,这样在遇到自定义消息的时候,未处理的可以放这里进行处理并且展示. 附件返回 nil 直接super 的未知消息处理.
                    break;
            }
        }
        attachment = [self checkAttachment:attachment] ? attachment : nil;
                            
    }
    
    return attachment;
    
}

- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment{
    
    return YES;
}

@end
