//
//  YZHChatContentManage.m
//  YZHYolo
//
//  Created by Jersey on 2018/12/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHChatContentManage.h"

#import "NSString+YZHTool.h"
@implementation YZHChatContentManage

- (instancetype)initWithSession:(NIMSession *)session searchOption:(NIMMessageSearchOption* )searchOption {
    
    self = [super init];
    if (self) {
        _session = session;
        _searchOption = searchOption;
    }
    return self;
}

- (void)searchImageViewMessagesCompletion:(YZHVoidBlock)completion {
    
    NIMMessageSearchOption* imageOption = [[NIMMessageSearchOption alloc] init];
    imageOption.limit = 0;
    imageOption.order = NIMMessageSearchOrderDesc;
    imageOption.messageTypes = @[@(NIMMessageTypeImage)];
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:_session option:imageOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (messages.count) {
            self.imageViewMessages = [[NSMutableArray alloc] init];
            self.imageViewTimers = [[NSMutableArray alloc] init];
            [self configurationMessageData:messages formatMessages:self.imageViewMessages formatTimers:self.imageViewTimers];
            if (self.imageViewMessages.count) {
                completion ? completion () : NULL;
            }
        }
    }];
}

- (void)searchUserCardMessagesCompletion:(YZHVoidBlock)completion {
  
    NIMMessageSearchOption* searchOption = [[NIMMessageSearchOption alloc] init];
    searchOption.limit = 0;
    searchOption.order = NIMMessageSearchOrderDesc;
    searchOption.messageTypes = @[@(NIMMessageTypeCustom)];
    [[[NIMSDK sharedSDK] conversationManager] searchMessages:_session option:searchOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (messages.count) {
            NSMutableArray<NIMMessage*> *mutableMessages = messages.mutableCopy;
            NSMutableArray* mutableCardMessages = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < mutableMessages.count; i++) {
                NIMCustomObject *customObject = (NIMCustomObject*)mutableMessages[i].messageObject;
                if ([customObject.attachment isKindOfClass:NSClassFromString(@"YZHUserCardAttachment")] || [customObject.attachment isKindOfClass:NSClassFromString(@"YZHTeamCardAttachment")]) {
                    [mutableCardMessages addObject:mutableMessages[i]];
                }
            }
            self.cardMessages = [[NSMutableArray alloc] init];
            self.cardTimers = [[NSMutableArray alloc] init];
            [self configurationMessageData:mutableCardMessages formatMessages:self.cardMessages formatTimers:self.cardTimers];
            if (self.cardMessages.count) {
                completion ? completion () : NULL;
            }
        }
    }];
}

- (void)searchURLMessagesCompletion:(YZHVoidBlock)completion {
    
    NIMMessageSearchOption* searchOption = [[NIMMessageSearchOption alloc] init];
    searchOption.limit = 0;
    searchOption.order = NIMMessageSearchOrderDesc;

    [[[NIMSDK sharedSDK] conversationManager] searchMessages:_session option:searchOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (messages.count) {
            
            NSMutableArray<NIMMessage*> *mutableMessages = messages.mutableCopy;
            NSMutableArray* mutableHTTPMessages = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < mutableMessages.count; i++) {
                if ([mutableMessages[i].text yzh_isHTTP]) {
                    [mutableHTTPMessages addObject:mutableMessages[i]];
                }
            }
            self.urlMessages = [[NSMutableArray alloc] init];
            self.urlTimers = [[NSMutableArray alloc] init];
            [self configurationMessageData:mutableHTTPMessages formatMessages:self.urlMessages formatTimers:self.urlTimers];
            if (self.urlMessages.count) {
                completion ? completion () : NULL;
            }
            self.allTextMessage = [[NSMutableArray alloc] init];
            self.allTextTimers = [[NSMutableArray alloc] init];
            [self configurationMessageData:mutableMessages formatMessages:self.allTextMessage formatTimers:self.allTextTimers];
        }
    }];
}

- (void)configurationMessageData:(NSArray<NIMMessage *>*)messageData formatMessages:(NSMutableArray* )messages formatTimers:(NSMutableArray *)timers {
    
    NSMutableArray* messageMonths;
    for (NIMMessage* message in messageData) {
        
        NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSDateComponents *components = [dateFormatter.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:messageDate];
        NSDate* currentDate = [NSDate date];
        NSDateComponents *currentComponents = [dateFormatter.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        NSInteger currentbillYear = [currentComponents year];
        NSInteger currentbillMonth = [currentComponents month];
        
        NSInteger billYear = [components year];
        NSInteger billMonth = [components month];
        
        NSString* yearAndMonth = [NSString stringWithFormat:@"%ld/%ld", billYear, billMonth];
        if (currentbillYear == billYear && currentbillMonth == billMonth) {
            if (![timers containsObject:@"最近一个月"]) {
                messageMonths = [[NSMutableArray alloc] init];
                [timers addObject:@"最近一个月"];
                [messages addObject:messageMonths];
            }
        } else {
            if (![timers containsObject:yearAndMonth]) {
                messageMonths = [[NSMutableArray alloc] init];
                [timers addObject:yearAndMonth];
                [messages addObject:messageMonths];
            }
        }
        [messageMonths addObject:message];
    }
}

@end
