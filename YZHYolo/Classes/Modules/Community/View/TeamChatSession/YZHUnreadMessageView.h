//
//  YZHUnreadMessageView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHUnreadMessageView : UIView

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* readButton;
@property (nonatomic, assign) NSInteger unreadNumber;

- (instancetype)initWithUnreadNumber:(NSInteger)number;
//- (instancetype)initWithAtMessageNumber:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END
