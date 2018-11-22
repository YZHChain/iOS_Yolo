//
//  YZHSetTagModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZHUserModelManage.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YZHSetTagModelTypeUser,
    YZHSetTagModelTypeTeam,
} YZHSetTagModelType;
@interface YZHSetTagModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray <YZHUserCustomTagModel *>*>* userTagModel;
@property (nonatomic, strong) NSMutableArray<NSMutableArray <YZHUserGroupTagModel *>*>* userTeamTagModel;


+ (instancetype)sharedSetTagModel;
- (NSInteger)tagNumberOfRowsInSection:(NSInteger)section type:(YZHSetTagModelType)type;

- (NSIndexPath *)findtargetUserTagName:(NSString *)tagName type:(YZHSetTagModelType)type;
- (void)addUserCustomTag:(NSString *)tagName type:(YZHSetTagModelType)type WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (void)removeUserCustomTagIndex:(NSInteger)index type:(YZHSetTagModelType)type  WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (BOOL)checkoutContainCustomTagName:(NSString *)tagName type:(YZHSetTagModelType)type;
- (void)updateTargetUserTag;
- (void)updateTargetTeamTag;

@end

NS_ASSUME_NONNULL_END
