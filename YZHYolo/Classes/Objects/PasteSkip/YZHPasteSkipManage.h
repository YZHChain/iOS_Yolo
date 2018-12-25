//
//  YZHPasteSkipManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHPasteSkipManage : NSObject

+ (instancetype)sharedInstance;

- (void)checkoutTeamPasteboard;

@end

NS_ASSUME_NONNULL_END
