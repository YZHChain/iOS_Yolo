//
//  YZHTeamMemberCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/27.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHContactMemberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHTeamMemberCell : UITableViewCell

@property (nonatomic, strong) YZHContactMemberModel* member;
@property (nonatomic, copy) NSString* teamId;

- (void)refresh:(YZHContactMemberModel *)member;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath teamOwner:(BOOL)teamOwner;

@end

NS_ASSUME_NONNULL_END
