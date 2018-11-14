//
//  YZHAddBookAddFirendShowModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHAddBookDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookAddFirendShowModel : YZHAddBookDetailsModel

- (instancetype)initDetailsModelWithUserId:(NSString *)userId addMessage:(NSString *)addMessage isMySend:(BOOL)isMysend;

@end

NS_ASSUME_NONNULL_END
