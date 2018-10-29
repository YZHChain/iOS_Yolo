//
//  YZHTeamCardAttachment.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHCustomAttachmentDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamCardAttachment : NSObject<NIMCustomAttachment, YZHCustomAttachmentInfo>

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, copy) NSString *groupSynopsis;

@property (nonatomic, copy) NSString *groupUrl;

@property (nonatomic, copy) NSString* titleName;

@property (nonatomic, copy) NSString* avatarUrl;

@end

NS_ASSUME_NONNULL_END
