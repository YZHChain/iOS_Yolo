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

@interface YZHSetTagModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray <YZHUserGroupTagModel *>*>* userTagModel;


+ (instancetype)sharedSetTagModel;
- (NSInteger)tagNumberOfRowsInSection:(NSInteger)section;

- (NSIndexPath *)findtargetUserTagName:(NSString *)tagName;
- (void)addUserCustomTag:(NSString *)tagName WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (void)removeUserCustomTagIndex:(NSInteger)index WithsuccessCompletion:(YZHVoidBlock)successCompletion failureCompletion:(YZHErrorBlock)failureCompletion;
- (BOOL)checkoutContainCustomTagName:(NSString *)tagName;
- (void)updateTargetUserTag;

@end

NS_ASSUME_NONNULL_END
