//
//  YZHTeamNoticeSelectTeamVC.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamNoticeSelectTeamVC : YZHBaseViewController

@property (nonatomic, copy) NSString* teamId;
@property (nonatomic, copy) void(^selectedTeamBlock)(NSArray* selectedTeamArray);

@end

NS_ASSUME_NONNULL_END
