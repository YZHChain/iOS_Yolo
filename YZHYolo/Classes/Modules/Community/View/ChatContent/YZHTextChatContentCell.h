//
//  YZHTextChatContentCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/17.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIMAvatarImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHTextChatContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END
