//
//  YZHTeamMemberManageVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHTeamMemberManageModel.h"
#import "YZHTeamMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMemberManageVC : YZHBaseViewController

@property (nonatomic, strong) YZHTeamMemberManageModel* manageModel;
@property (nonatomic, strong) YZHTeamMemberModel* viewModel;

//- (instancetype)initWithmemberModel:(YZHTeamMemberModel* )memberModel;

@end

NS_ASSUME_NONNULL_END
