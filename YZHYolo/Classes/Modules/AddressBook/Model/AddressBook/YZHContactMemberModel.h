//
//  YZHContactMemberModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/4.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHContactMemberModel : NSObject

@property (nonatomic, strong) NIMKitInfo* info;

- (instancetype)initWithInfo:(NIMKitInfo *)info;

@end

NS_ASSUME_NONNULL_END
