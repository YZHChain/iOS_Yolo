//
//  YZHMyInformationMyPlaceCell.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "YZHMyInformationMyPlaceCell.h"

static NSString* const kPositioningCellIdentifier = @"positioningCellIdentifier";
static NSString* const kSelectedLocationCellIdentifier =  @"selectedLocationCellIdentifier";
@implementation YZHMyInformationMyPlaceCell

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
    switch (indexPath.section) {
        case 0:
            cellIdentifier = kPositioningCellIdentifier;
            break;
        case 1:
            cellIdentifier = kSelectedLocationCellIdentifier;
            break;
        default:
            cellIdentifier = kSelectedLocationCellIdentifier;
            break;
    }
    YZHMyInformationMyPlaceCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        // TODO: 写个异常捕获
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:indexPath.section];
    } else {
        NSLog(@"复用了哦");
    }
    
    return cell;
}

@end
