//
//  YZHImageContentCell.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/3.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIMSessionImageContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHImageContentCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* imageContentView;

@property (nonatomic,strong) NIMMessageModel *model;

@property (nonatomic, weak)  id<NIMMessageCellDelegate> delegate;

- (void)refreshData:(NIMMessageModel *)data;

@end

NS_ASSUME_NONNULL_END
