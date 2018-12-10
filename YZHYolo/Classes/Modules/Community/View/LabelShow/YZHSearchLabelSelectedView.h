//
//  YZHSearchLabelSelectedView.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YZHSearchLabelSelectedProtocol <NSObject>

- (void)selectedTagLabel:(UIButton *)tagLabel;

@end

@interface YZHSearchLabelSelectedView : UIView

- (CGFloat)refreshLabelButtonWithLabelArray:(NSArray *)labelArray;
@property (nonatomic, weak) id<YZHSearchLabelSelectedProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
