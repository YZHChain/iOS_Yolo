//
//  YZHTeamMemberManageModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHTeamMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMemberManageModel : NSObject

@property (nonatomic, strong) YZHTeamMemberModel* memberModel;

- (instancetype)initWithMemberModel:(YZHTeamMemberModel *)memberModel;

@end

NS_ASSUME_NONNULL_END
