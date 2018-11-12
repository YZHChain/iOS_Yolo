//
//  YZHAddBookSettingCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddBookDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;

@property (nonatomic, strong) YZHAddBookDetailModel* model;

@end

NS_ASSUME_NONNULL_END
