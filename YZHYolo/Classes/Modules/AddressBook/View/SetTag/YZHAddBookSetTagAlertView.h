//
//  YZHAddBookSetTagAlertView.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/29.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookSetTagAlertView : UIView

@property (weak, nonatomic) IBOutlet UITextField *customTagTextField;
@property (weak, nonatomic) IBOutlet UIButton *affirmButton;

@property (nonatomic, copy) void(^YZHButtonExecuteBlock)(UITextField *customTagTextField);

@end

NS_ASSUME_NONNULL_END
