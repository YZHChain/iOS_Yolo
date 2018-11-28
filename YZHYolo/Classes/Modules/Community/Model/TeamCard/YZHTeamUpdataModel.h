//
//  YZHTeamUpdataModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamUpdataModel : NSObject

@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, copy) NSDictionary* params;
@property (nonatomic, assign) BOOL isCreatTeam;
- (instancetype)initWithTeamId:(NSString *)teamId isCreatTeam:(BOOL)isCreatTeam; //1 创建 0 修改

@end

NS_ASSUME_NONNULL_END
