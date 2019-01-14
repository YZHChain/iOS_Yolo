//
//  YZHTransferTeamVC.h
//  YZHYolo
//
//  Created by Jersey on 2019/1/14.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHTeamMemberModel.h"
#import "NIMContactSelectConfig.h"
#import "YZHTeamMemberVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTransferTeamVC : YZHTeamMemberVC

@property (nonatomic, copy) YZHVoidBlock transferCompletion;

@end

NS_ASSUME_NONNULL_END
