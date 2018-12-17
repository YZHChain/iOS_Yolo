//
//  YZHSearchChatContentModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHSearchChatContentModel : NSObject

@property (nonatomic, strong) NSMutableArray<NIMMessage*> * searchTextMessages;
@property (nonatomic, strong) NSArray<NIMMessage* >* allTextMessages;
@property (nonatomic, strong) NIMSession* session;

- (instancetype)initWithSession:(NIMSession *)session allTextMessages:(NSArray *)allTextMessage;
- (void)searchPrivateContentKeyText:(NSString *)keyText; // 搜索私聊回话内容列表

@end

NS_ASSUME_NONNULL_END
