//
//  YZHAddBookSetNoteCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookSetNoteCell.h"

#import "NSString+YZHTool.h"

static NSString* const kNoteNameCellIdentifier = @"noteNameCellIdentifier";
static NSString* const kPhoneCellIdentifier =  @"phoneLocationCellIdentifier";
static NSString* const kCategoryTagCellIdentifier =  @"categoryTagCellIdentifier";
@interface YZHAddBookSetNoteCell()<UITextFieldDelegate>

@end

@implementation YZHAddBookSetNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    NSString* cellIdentifier;
    YZHAddBookSetNoteCellType cellType;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellIdentifier = kNoteNameCellIdentifier;
            cellType = YZHAddBookSetNoteCellTypeNoteName;
        } else {
            cellIdentifier = kPhoneCellIdentifier;
            cellType = YZHAddBookSetNoteCellTypePhone;
        }
    } else {
        cellIdentifier = kCategoryTagCellIdentifier;
        cellType = YZHAddBookSetNoteCellTypeCategoryTag;
    }
    YZHAddBookSetNoteCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YZHAddBookSetNoteCell" owner:nil options:nil] objectAtIndex:cellType];
        if (cellType == YZHAddBookSetNoteCellTypeNoteName) {
            cell.subtitleTextField.delegate = cell;
        }
    } else {
        NSLog(@"复用");
    }
    return cell;
}

- (void)setModel:(YZHAddBookDetailModel *)model {
    
    _model = model;
    
    //赋值备注,手机号,标签。
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    self.subtitleTextField.text = model.subtitle;
    
}

#pragma mark -- textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //对备注名输入限制.
    if (self.cellType == YZHAddBookSetNoteCellTypeNoteName) {
        
        if (string.length == 0) {
            return YES;
        } else {
            BOOL lengthQualified = [NSString  yzh_checkoutStringWithCurrenString:textField.text importString:string standardLength: 20];
            return lengthQualified;
        }
        
    } else {
        return YES;
    }
}

@end
