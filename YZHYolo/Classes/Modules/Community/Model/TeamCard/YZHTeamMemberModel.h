//
//  YZHTeamMemberModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//
#import "YZHGroupedDataCollection.h"

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMemberModel : YZHGroupedDataCollection

@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, assign) BOOL isManage;
@property (nonatomic, strong) NSMutableArray<YZHContactMemberModel *>* memberArray;

- (instancetype)initWithTeamId:(NSString *)teamId;

@end

NS_ASSUME_NONNULL_END
