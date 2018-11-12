//
//  YZHAddBookUserIDCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/28.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHAddBookDetailsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookUserIDCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userpicImageView;
@property (weak, nonatomic) IBOutlet UILabel *notoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userYoloIDLabel;

@property (nonatomic, strong) YZHAddBookHeaderModel* model;

@end

NS_ASSUME_NONNULL_END
