//
//  YZHAddFirendSubtitleCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddBookDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddFirendSubtitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) YZHAddBookDetailModel* model;

@end

NS_ASSUME_NONNULL_END
