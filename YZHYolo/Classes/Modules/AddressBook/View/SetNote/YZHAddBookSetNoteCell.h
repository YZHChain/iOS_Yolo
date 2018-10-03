//
//  YZHAddBookSetNoteCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YZHAddBookSetNoteCellNoteNameType = 0,
    YZHAddBookSetNoteCellPhoneType,           // Xib 将此类型Cell 交互关闭
    YZHAddBookSetNoteCellCategoryTagType,
} YZHAddBookSetNoteCellType;

@interface YZHAddBookSetNoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;
@property (weak, nonatomic) IBOutlet UITextField *subtitleTextField;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHAddBookSetNoteCellType)cellType;

@end

NS_ASSUME_NONNULL_END
