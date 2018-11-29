//
//  YZHBaseViewController.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/10.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZHBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hideNavigationBarLine;
@property (nonatomic, assign) BOOL hideNavigationBar;

- (void)setStatusBarBackgroundColor:(UIColor *)color;
- (void)setStatusBarBackgroundGradientColorFromLeftToRight:(UIColor *)color withEndColor:(UIColor*) endColor;

@end
