//
//  YZHTeamNoticeSelectTeamModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamNoticeSelectTeamModel : NSObject

@property (nonatomic, strong) NSArray<NIMTeam* >* allMyOnwerTeam;
@property (nonatomic, strong) NSIndexPath* currentTeamPath;
@property (nonatomic, copy) NSString* teamId;

- (instancetype)initWithTeamId:(NSString *)teamId;

@end

NS_ASSUME_NONNULL_END
