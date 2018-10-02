//
//  UIView+YZHTool.m
//  YZHYolo
//
//  Created by Jersey on 2018/9/18.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIView+YZHTool.h"

#import "BlocksKit+UIKit.h"

#import "Masonry.h"
@implementation UIView (YZHTool)

#pragma mark - Frame

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - Private Method

/**
 *  优先从同名xib加载view，若不存在则通过initWithFrame:初始化
 *
 *  @param frame view的frame
 *
 *  @return 初始化后的view
 */
+ (id)yzh_viewWithFrame:(CGRect)frame
{
    UIView *view = [self yzh_loadXibWithFrame:frame];
    if (view == nil) {
        view = [[[self class] alloc] initWithFrame:frame];
    }
    return view;
}

+ (id)yzh_loadFromXib
{
    UIView *view = nil;
    @try {
        view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    } @catch (NSException *exception) {
        
        NSLog(@"YZH异常捕获:%@ ---- %s",exception, __func__);
    } @finally {
        
    }
    //UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}

+ (id)yzh_loadXibWithFrame:(CGRect)frame
{
    UIView *view = [self yzh_loadFromXib];
    view.frame = frame;
    return view;
}

#pragma mark - Show On Window

- (void)yzh_showOnWindowAnimations:(void (^)(void))animations
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *bgView = [[UIView alloc] initWithFrame:window.bounds];
    UIButton *tapButton = [[UIButton alloc] initWithFrame:bgView.bounds];
    [tapButton bk_addEventHandler:^(id sender) {
        [self yzh_hideFromWindowAnimations:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:bgView];
    [bgView addSubview:tapButton];
    [bgView addSubview:self];

    if (animations) {
        bgView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
            animations();
        }];
    } else {
        bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    }
}

- (void)yzh_hideFromWindowAnimations:(void (^)(void))animations
{
    if (animations) {
        [UIView animateWithDuration:0.3 animations:^{
            self.superview.backgroundColor = [UIColor clearColor];
            animations();
        } completion:^(BOOL finished) {
            [self.superview removeFromSuperview];
        }];
    } else {
        [self.superview removeFromSuperview];
    }
}

@end
