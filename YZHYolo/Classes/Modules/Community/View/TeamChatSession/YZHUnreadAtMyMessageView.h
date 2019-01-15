//
//  YZHUnreadAtMyMessageView.h
//  YZHYolo
//
//  Created by Jersey on 2019/1/15.
//  Copyright © 2019年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHUnreadAtMyMessageView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)refreshAtUnreadCount:(NSInteger)atUnreadCount;

@end

NS_ASSUME_NONNULL_END
