//
//  YZHAddBookAdditionalCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMBadgeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookAdditionalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NIMBadgeView* badgeView;

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)refreshUnreadCount:(NSInteger)unreadCount;


@end

NS_ASSUME_NONNULL_END
