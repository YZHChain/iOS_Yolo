//
//  YZHAddBookFriendsCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHContactMemberModel.h"
#import "NIMContactDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)refreshUser:(YZHContactMemberModel *)member;

@end

NS_ASSUME_NONNULL_END
