//
//  YZHPrivateChatConfig.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHPrivateChatConfig : NSObject<NIMSessionConfig>

@property (nonatomic, strong) NIMSession* session;

@end

NS_ASSUME_NONNULL_END
