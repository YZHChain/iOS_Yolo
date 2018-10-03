//
//  YZHPhoneContactCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YZHPhoneContactCellTypeDating = 0,
    YZHPhoneContactCellTypeReview,
} YZHPhoneContactCellType;

@interface YZHPhoneContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHPhoneContactCellType)cellType;

@end

NS_ASSUME_NONNULL_END
