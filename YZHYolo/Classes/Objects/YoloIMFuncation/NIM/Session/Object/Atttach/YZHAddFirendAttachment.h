//
//  YZHAddFirendAttachment.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHCustomAttachmentDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddFirendAttachment :  NSObject<NIMCustomAttachment, YZHCustomAttachmentInfo>

@property (nonatomic, copy) NSString* addFirendTitle;
@property (nonatomic, copy) NSString* addFirendButtonTitle;
@property (nonatomic, copy) NSString* fromAccount;

@end

NS_ASSUME_NONNULL_END
