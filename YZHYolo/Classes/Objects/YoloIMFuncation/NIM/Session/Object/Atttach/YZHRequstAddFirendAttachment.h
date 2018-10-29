//
//  YZHRequstAddFirendAttachment.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

#import "YZHCustomAttachmentDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHRequstAddFirendAttachment : NSObject<NIMCustomAttachment, YZHCustomAttachmentInfo>

@property (nonatomic, copy) NSString* addFirendTitle;

@end

NS_ASSUME_NONNULL_END
