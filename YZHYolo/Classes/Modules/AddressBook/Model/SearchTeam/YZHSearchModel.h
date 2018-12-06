//
//  YZHSearchModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTTTTeamModel : NSObject

@property (nonatomic, strong) NSString* teamIcon;
@property (nonatomic, strong) NSString* teamName;
@property (nonatomic, strong) NSString* teamId;

@end

@interface YZHSearchModel : NSObject

@property (nonatomic, strong) NSMutableArray<YZHTTTTeamModel *>* searchArray;
@property (nonatomic, strong) NSMutableArray<YZHTTTTeamModel *>* recommendArray;

@end

NS_ASSUME_NONNULL_END
