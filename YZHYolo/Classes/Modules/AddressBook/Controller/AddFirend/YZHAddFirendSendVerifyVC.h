//
//  YZHAddFirendSendVerifyVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface YZHAddFirendSendVerifyVC : YZHBaseViewController

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NIMSession* session;
@property (nonatomic, assign) BOOL isPrivate;

@end

NS_ASSUME_NONNULL_END
