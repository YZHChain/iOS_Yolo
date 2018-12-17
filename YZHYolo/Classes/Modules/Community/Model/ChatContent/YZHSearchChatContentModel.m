//
//  YZHSearchChatContentModel.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHSearchChatContentModel.h"

@implementation YZHSearchChatContentModel

- (instancetype)initWithSession:(NIMSession *)session allTextMessages:(NSArray *)allTextMessage {
    
    self = [super init];
    if (self) {
        _session = session;
        _allTextMessages = allTextMessage;
//        [self configuration];
    }
    return self;
}

- (void)configuration {
    
    NIMMessageSearchOption* option = [[NIMMessageSearchOption alloc] init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:_session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (messages.count) {
            self.allTextMessages = messages.mutableCopy;
        }
    }];
}

- (void)searchPrivateContentKeyText:(NSString *)keyText {
    
    if (self.allTextMessages) {
        [self.searchTextMessages removeAllObjects];
        for (NIMMessage* message in self.allTextMessages) {
            if ([message.text containsString:keyText]) {
                [self.searchTextMessages addObject:message];
            }
        }
    }
}

- (NSMutableArray<NIMMessage *> *)searchTextMessages {
    
    if (!_searchTextMessages) {
        _searchTextMessages = [[NSMutableArray alloc] init];
    }
    return _searchTextMessages;
}

@end
