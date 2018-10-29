//
//  YZHUserCardAttachment.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHCustomAttachmentDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHUserCardAttachment : NSObject<NIMCustomAttachment, YZHCustomAttachmentInfo>

@property (nonatomic,copy) NSString *userName;

@property (nonatomic,copy) NSString *yoloID;

@property (nonatomic,copy) NSString *account;

@property (nonatomic,copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString* titleName;

@end

NS_ASSUME_NONNULL_END
