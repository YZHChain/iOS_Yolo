//
//  YZHChatContentManage.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHChatContentManage : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray <NIMMessage* >*>* urlMessages;
@property (nonatomic, strong) NSMutableArray* urlTimers;

@property (nonatomic, strong) NSMutableArray<NSMutableArray <NIMMessage* >*>* cardMessages;
@property (nonatomic, strong) NSMutableArray* cardTimers;

@property (nonatomic, strong) NSMutableArray<NSMutableArray <NIMMessage* >*>* imageViewMessages;
@property (nonatomic, strong) NSMutableArray* imageViewTimers;

@property (nonatomic, strong) NSMutableArray<NSMutableArray <NIMMessage* >*>* allTextMessage;
@property (nonatomic, strong) NSMutableArray* allTextTimers;
@property (nonatomic, strong) NSArray<NIMMessage* >* allSearchTextMessage; //提供给搜索

@property (nonatomic, strong) NIMSession* session;
@property (nonatomic, strong) NIMMessageSearchOption* searchOption;

- (instancetype)initWithSession:(NIMSession *)session searchOption:(NIMMessageSearchOption* )searchOption;
- (void)searchImageViewMessagesCompletion:(YZHVoidBlock)completion;
- (void)searchUserCardMessagesCompletion:(YZHVoidBlock)completion;
- (void)searchURLMessagesCompletion:(YZHVoidBlock)completion;

@end

NS_ASSUME_NONNULL_END
