//
//  YZHSearchRecommendSectionView.h
//  YZHYolo
//
//  Created by Jersey on 2018/12/9.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YZHSearchRecommendViewProtocol <NSObject>

- (void)onTouchSwitch:(UIButton *)sender;
- (void)onTouchSwitchRange:(UIButton *)sender;

@end

@interface YZHSearchRecommendSectionView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<YZHSearchRecommendViewProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
