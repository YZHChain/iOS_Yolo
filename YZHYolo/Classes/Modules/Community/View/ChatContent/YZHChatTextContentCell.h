//
//  YZHChatTextContentCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHChatTextContentCell : UITableViewCell

@property (nonatomic, strong) NIMSessionMessageContentView *bubbleView;           //内容区域
@property (nonatomic,strong) NIMMessageModel *model;

@property (nonatomic, weak)   id<NIMMessageCellDelegate> delegate;

- (void)refreshData:(NIMMessageModel *)data;

@end

NS_ASSUME_NONNULL_END
