//
//  UIView+YZHTool.h
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YZHTool)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

+ (id)yzh_viewWithFrame:(CGRect)frame;

- (void)yzh_showOnWindowAnimations:(void (^)(void))animations;
- (void)yzh_hideFromWindowAnimations:(void (^)(void))animations;
- (void)yzh_showOnWindowCallShowBlock:(YZHVoidBlock)callShowBlock;

- (UIViewController *)viewController;

@end
