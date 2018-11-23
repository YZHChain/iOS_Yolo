//
//  YZHCommunityAtMemberVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/22.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "NIMContactSelectConfig.h"
typedef void(^ContactSelectFinishBlock)(NSArray *);
typedef void(^ContactSelectCancelBlock)(void);

@protocol YZHContactSelectDelegate <NSObject>

@optional

- (void)didFinishedSelect:(NSArray *)selectedContacts; // 返回userID

- (void)didFinishedSelect:(NSArray *)selectedContacts isRespond:(BOOL)isRespond;

- (void)didCancelledSelect;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YZHCommunityAtMemberVC : YZHBaseViewController

@property (nonatomic, assign) BOOL isManage;

@property (nonatomic, strong, readonly) id<NIMContactSelectConfig> config;
//回调处理
@property (nonatomic, weak) id<YZHContactSelectDelegate> delegate;

@property (nonatomic, copy) ContactSelectFinishBlock finshBlock;

@property (nonatomic, copy) ContactSelectCancelBlock cancelBlock;

/**
 *  初始化方法
 *
 *  @param config 联系人选择器配置
 *
 *  @return 选择器
 */
- (instancetype)initWithConfig:(id<NIMContactSelectConfig>) config withIsManage:(BOOL)isManage;

/**
 *  弹出联系人选择器
 */
- (void)show;
@end

NS_ASSUME_NONNULL_END
