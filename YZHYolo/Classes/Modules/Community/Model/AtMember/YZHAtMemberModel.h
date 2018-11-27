//
//  YZHAtMemberModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHGroupedDataCollection.h"

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAtMemberModel : YZHGroupedDataCollection

@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, assign) BOOL isManage;

- (instancetype)initWithTeamId:(NSString *)teamId;

@end

NS_ASSUME_NONNULL_END
