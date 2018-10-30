//
//  YZHMyInformationMyPlaceCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/23.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZHMyInformationMyPlaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *positioningResultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
