//
//  YZHAddBookAddFirendRecordCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHAddBookAddFirendRecordCell.h"

#import "YZHPublic.h"
static NSString* kAddFirendRecordCellDating = @"addFirendRecordCellDating";
static NSString* kAddFirendRecordCellReview = @"addFirendRecordCellReview";
@implementation YZHAddBookAddFirendRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (self.datingButton) {
        self.datingButton.layer.borderWidth = 1;
        self.datingButton.layer.borderColor = [UIColor yzh_backgroundThemeGray].CGColor;
    }
    // TODO: 需要 masksToBounds 则调用此方法来解决性能问题,此方法必须在 image 赋值之前圆角才生效.
    [self.photoImageView zy_cornerRadiusAdvance:3.0f rectCornerType:UIRectCornerAllCorners];
    self.photoImageView.image = [UIImage imageNamed:@"addBook_cover_cell_photo_default"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)tempTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cellType:(YZHAddFirendRecordCellType)cellType {
    
    NSString* identifierID;
    if (cellType == YZHAddFirendRecordCellTypeDating) {
        identifierID = kAddFirendRecordCellDating;
    } else {
        identifierID = kAddFirendRecordCellReview;
    }
    
    YZHAddBookAddFirendRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (cell == nil) {
        UINib* nib = [UINib nibWithNibName:@"YZHAddBookAddFirendRecordCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:cellType];
    }
    
    return cell;
}

@end
