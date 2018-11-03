//
//  JKRSearchTextField.m
//  JKRSearchDemo
//
//  Created by Joker on 2017/4/5.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "JKRSearchTextField.h"

@implementation JKRSearchTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.canTouch = YES;
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    if (_canTouch) {
        return result;
    } else {
        return NO;
    }
}

//- (CGRect)leftViewRectForBounds:(CGRect)bounds {
//    
////    self.textInputView.frame
//    
//    return CGRectMake(20, 15, 20, 20);
//}
//
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    
//    NSLog(@"执行");
//    CGRect rect = CGRectMake(50, 10, bounds.size.width, bounds.size.height);
//    return rect;
//}

- (void)dealloc {
    NSLog(@"JKRSearchTextField dealloc");
}

@end
