//
//  YZHAddBookAddFirendRecordCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddFirendRecordManage.h"

typedef enum : NSUInteger {
    YZHAddFirendRecordCellTypeDating = 0,
    YZHAddFirendRecordCellTypeReview,
} YZHAddFirendRecordCellType;

typedef NS_ENUM(NSInteger, YZHNotificationHandleType) {
    YZHNotificationHandleTypePending = 0,
    YZHNotificationHandleTypeOk,
    YZHNotificationHandleTypeNo,
    YZHNotificationHandleTypeOutOfDate
};
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookAddFirendRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *datingButton;
@property (weak, nonatomic) IBOutlet UILabel *rusultLabel;
@property (nonatomic, strong) YZHAddFriendRecordModel* model;

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHAddFirendRecordCellType)cellType;

- (void)update:(YZHAddFriendRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
