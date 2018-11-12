//
//  YZHAddFirendSearchVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/12.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHAddFirendSearchModel.h"

typedef enum : NSUInteger {
    YZHAddFirendSearchStatusSucceed = 1,
    YZHAddFirendSearchStatusEmpty,
    YZHAddFirendSearchStatusNotImput,
} YZHAddFirendSearchStatus;

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddFirendSearchVC : YZHBaseViewController

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* reminderView;
@property (nonatomic, assign) YZHAddFirendSearchStatus searchStatus;
@property (nonatomic, strong) YZHAddFirendSearchModel* viewModel;

@end

NS_ASSUME_NONNULL_END
