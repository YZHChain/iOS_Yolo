//
//  YZHTeamMemberModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMember : NSObject

@end

@interface YZHTeamMemberModel : NSObject

@property (nonatomic, strong) NSArray<YZHTeamMember* >* members;

@end

NS_ASSUME_NONNULL_END
