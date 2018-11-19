//
//  YZHAddBookDetailsVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHAddBookDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookDetailsVC : YZHBaseViewController

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) YZHAddBookDetailsModel* userDetailsModel;
@property (nonatomic, assign) BOOL isSearch;

@end

NS_ASSUME_NONNULL_END
