//
//  YZHTeamModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIMKitInfoFetchOption.h"
#import "YZHContactMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamModel : NSObject

@property (nonatomic, strong) NSArray<NIMTeam* >* allTeamModel;

@end

NS_ASSUME_NONNULL_END
