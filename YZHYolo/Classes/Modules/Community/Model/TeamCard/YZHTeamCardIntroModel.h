//
//  YZHTeamCardIntroModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHTeamCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamCardIntroModel : NSObject

@property (nonatomic, strong) YZHTeamHeaderModel* headerModel;
@property (nonatomic, strong) NSMutableArray<NSMutableArray <YZHTeamDetailModel *> *>* modelList;
@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, strong) NIMTeam* team;
@property (nonatomic, copy) NSString* teamOwner;
@property (nonatomic, copy) NSString* teamOwnerAvatarUrl;
@property (nonatomic, copy) NSString* teamOwnerName;
@property (nonatomic, assign) BOOL haveTeamData;
@property (nonatomic, strong) NSError* error; // 拉取数据时,返回的错误信息

- (instancetype)initWithTeam:(NIMTeam *)team;

- (void)updataTeamOwnerData:(NIMUser* )user;
- (void)updataHeaderModel:(NIMTeam* )team;

@end

NS_ASSUME_NONNULL_END
