//
//  YZHCardContentCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHSessionMsgConverter.h"
#import "YZHUserCardContentView.h"
#import "YZHTeamCardContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHCardContentCell : UITableViewCell

@property (nonatomic, strong) NIMSessionMessageContentView* cardView;

@property (nonatomic,strong) NIMMessage *message;

- (void)refreshData:(NIMMessage *)data;

@end

NS_ASSUME_NONNULL_END
