//
//  YZHMyplaceCityVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/26.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHMyinformationMyplaceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHMyplaceCityVC : YZHBaseViewController

@property (nonatomic, strong) YZHLocationWorldModel* viewModel;
@property (nonatomic, assign) BOOL isNextSelected;

@end

NS_ASSUME_NONNULL_END
