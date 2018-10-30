//
//  YZHAboutYoloCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/25.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAboutYoloModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAboutYoloCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) YZHAboutYoloModel* model;

@end

NS_ASSUME_NONNULL_END
