//
//  YZHAddBookAddFirendCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddBookFirendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookAddFirendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) YZHAddBookFirendModel* model;

@end

NS_ASSUME_NONNULL_END
