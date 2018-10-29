//
//  NIMKitSetting.m
//  NIMKit
//
//  Created by chris on 2017/10/30.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NIMKitSetting.h"
#import "UIImage+NIMKit.h"

@implementation NIMKitSetting

- (instancetype)init:(BOOL)isRight
{
    self = [super init];
    if (self)
    {
        //Jersey:聊天气泡图
        if (isRight)
        {
            _normalBackgroundImage    =  [[UIImage nim_imageInKit:@"session_sender_node_normal"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
            _highLightBackgroundImage =  [[UIImage nim_imageInKit:@"session_sender_node_selected"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
            
            
        }
        else
        {
            _normalBackgroundImage    =  [[UIImage nim_imageInKit:@"session_receiver_node_normal"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
            _highLightBackgroundImage =  [[UIImage nim_imageInKit:@"session_receiver_node_selected"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
        }
    }
    return self;
}

@end

