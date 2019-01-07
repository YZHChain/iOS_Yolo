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

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isTeam;
@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, strong) YZHAddBookDetailsModel* userDetailsModel;
// 通讯录直接进入 -- > 聊天 -->
// 私聊直接进入
// 搜索直接进入
// 群聊
// 打开聊天窗时, 先判断是否包含聊天窗,包含在判断是否属于同一个聊天窗,属于则POP,不属于则到顶部 Push, 不包含则直接 Push。


@end

NS_ASSUME_NONNULL_END
