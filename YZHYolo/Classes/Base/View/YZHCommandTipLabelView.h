//
//  YZHCommandTipLabelView.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/11.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YZHSearchLabelSelectedView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZHCommandTipLabelView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YZHSearchLabelSelectedView *showLabelView;

@end

NS_ASSUME_NONNULL_END
