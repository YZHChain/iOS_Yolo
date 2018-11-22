//
//  YZHTeamDataEditVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/20.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHTeamCardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamDataEditVC : YZHBaseViewController

@property (nonatomic, strong) YZHTeamHeaderModel* viewModel;
@property (nonatomic, copy) YZHVoidBlock teamDataSaveSucceedBlock;

@end

NS_ASSUME_NONNULL_END
