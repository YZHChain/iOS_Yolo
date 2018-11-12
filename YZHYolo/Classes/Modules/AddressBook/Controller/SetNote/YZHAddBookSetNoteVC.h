//
//  YZHAddBookSetNoteVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

#import "YZHAddBookDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookSetNoteVC : YZHBaseViewController

@property (nonatomic, strong) YZHAddBookDetailsModel* userDetailsModel;

@property (nonatomic, strong) NSMutableArray<YZHAddBookDetailModel*>* noteModel;
@property (nonatomic, strong) YZHAddBookDetailModel* classTagModel;
@property (nonatomic, weak) UITableView* detailsTableView;

@end

NS_ASSUME_NONNULL_END
