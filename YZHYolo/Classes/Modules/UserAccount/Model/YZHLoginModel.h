//
//  YZHLoginModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHLoginModel : NSObject

@property (nonatomic, copy) NSString* appKey;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* acctId;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* orderFlag;
@property (nonatomic, copy) NSString* phone;

@end

NS_ASSUME_NONNULL_END
