//
//  YZHTeamTagSelectedVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"
#import "CYLClassifyMenuViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamTagSelectedVC : CYLClassifyMenuViewController

@property (nonatomic, copy) YZHExecuteBlock selectedLabelSaveHandle;
@property (nonatomic, strong) NSMutableArray<NSString *>* selectedLabelArray;

@end

NS_ASSUME_NONNULL_END
