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
@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, copy) NSString* teamOwner;
@property (nonatomic, copy) NSString* teamOwnerAvatarUrl;
@property (nonatomic, strong) NIMTeam* teamModel;
@property (nonatomic, copy) NSString* teamOwnerName;

- (instancetype)initWithTeamId:(NSString *)teamId;

- (void)updataTeamOwnerData;
- (void)updataHeaderModel;

@end

NS_ASSUME_NONNULL_END
