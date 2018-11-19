//
//  YZHSharedContactCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/19.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHSharedContactCell : UITableViewCell

@property (nonatomic, strong) UIImageView* selectedImageView;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)refreshUser:(YZHContactMemberModel *)member;
- (void)refreshTeam:(NIMTeam *)team;

@end

NS_ASSUME_NONNULL_END
