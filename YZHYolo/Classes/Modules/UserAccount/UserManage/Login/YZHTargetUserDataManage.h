//
//  YZHTargetUserDataManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTargetUserExtManage : NSObject

@property (nonatomic, copy) NSString* friend_phone;
@property (nonatomic, copy) NSString* friend_tagName;
@property (nonatomic, copy) NSString* requstAddText; // 请求添加好友验证消息
@property (nonatomic, assign) BOOL requteAddFirend; // 是否发送过好友请求.

+ (instancetype)targetUserExtWithUserId:(NSString* )userId;

@end

NS_ASSUME_NONNULL_END
