//
//  YZHSearchChatContentVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHSearchChatContentVC : YZHBaseViewController

@property (nonatomic, strong) NIMSession* session;
@property (nonatomic, strong) NSArray<NIMMessage *>* allTextMessages;

@end

NS_ASSUME_NONNULL_END
