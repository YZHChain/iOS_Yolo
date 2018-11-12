//
//  YZHAddBookSetNoteCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddBookDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YZHAddBookSetNoteCellTypeNoteName = 0,
    YZHAddBookSetNoteCellTypePhone,
    YZHAddBookSetNoteCellTypeCategoryTag,
} YZHAddBookSetNoteCellType;

@interface YZHAddBookSetNoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;
@property (weak, nonatomic) IBOutlet UITextField *subtitleTextField;
@property (nonatomic, assign) YZHAddBookSetNoteCellType cellType;
@property (nonatomic, strong) YZHAddBookDetailModel* model;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
