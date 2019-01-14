//
//  YZHTeamMemberVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHTeamMemberModel.h"
#import "NIMContactSelectConfig.h"
#import "YZHTeamMemberCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMemberVC : YZHBaseViewController

@property (nonatomic, copy) NSString* teamId;

@property (nonatomic, strong, readonly) id<NIMContactSelectConfig> config;

@property (nonatomic, assign) BOOL isManage;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) YZHTeamMemberModel* viewModel;
/**
 *  初始化方法
 *
 *  @param config 联系人选择器配置
 *
 *  @return 选择器
 */
- (instancetype)initWithConfig:(id<NIMContactSelectConfig>) config withIsManage:(BOOL)isManage;

@end

NS_ASSUME_NONNULL_END
