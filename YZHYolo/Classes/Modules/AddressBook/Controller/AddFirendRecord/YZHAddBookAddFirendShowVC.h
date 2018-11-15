//
//  YZHAddBookAddFirendShowVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHAddBookAddFirendShowModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookAddFirendShowVC : YZHBaseViewController

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* addMessage;
@property (nonatomic, assign) BOOL isMySend;
@property (nonatomic, assign) BOOL messageTimeout;
@property (nonatomic, strong) NIMSystemNotification* addFriendNotification;
@property (nonatomic, strong) YZHAddBookAddFirendShowModel* userDetailsModel;

@end

NS_ASSUME_NONNULL_END
