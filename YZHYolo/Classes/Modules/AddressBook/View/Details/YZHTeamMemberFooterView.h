//
//  YZHTeamMemberFooterView.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMemberFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *senderMessageButton;
@property (nonatomic, copy) YZHButtonExecuteBlock addFriendBlock;
@property (nonatomic, copy) YZHButtonExecuteBlock senderMessageBlock;

@end

NS_ASSUME_NONNULL_END
