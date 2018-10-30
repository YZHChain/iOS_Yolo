//
//  YZHAddBookAddFirendRecordCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YZHAddFirendRecordCellTypeDating = 0,
    YZHAddFirendRecordCellTypeReview,
} YZHAddFirendRecordCellType;
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookAddFirendRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *datingButton;
@property (weak, nonatomic) IBOutlet UILabel *rusultLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHAddFirendRecordCellType)cellType;

@end

NS_ASSUME_NONNULL_END
