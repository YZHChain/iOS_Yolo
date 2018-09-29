//
//  YZHAddBookSetNoteCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetNoteCell.h"

static NSString* const kNoteNameCellIdentifier = @"noteNameCellIdentifier";
static NSString* const kPhoneCellIdentifier =  @"phoneLocationCellIdentifier";
static NSString* const kCategoryTagCellIdentifier =  @"categoryTagCellIdentifier";
@implementation YZHAddBookSetNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"未服用");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHAddBookSetNoteCellType)cellType {
    
    NSString* cellIdentifier;
    switch (cellType) {
        case 0:
            cellIdentifier = kNoteNameCellIdentifier;
            break;
        case 1:
            cellIdentifier = kPhoneCellIdentifier;
            break;
        default:
            cellIdentifier = kCategoryTagCellIdentifier;
            break;
    }
    YZHAddBookSetNoteCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YZHAddBookSetNoteCell" owner:nil options:nil] objectAtIndex:cellType];
    } else {
    }
    return cell;
}

@end
