//
//  YZHAddBookUserAskFooterView.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookUserAskFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

- (IBAction)sendMessage:(id)sender;

@end

NS_ASSUME_NONNULL_END
