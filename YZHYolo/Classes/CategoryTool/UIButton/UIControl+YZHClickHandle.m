//
//  UIControl+YZHClickHandle.m
//  YZHYolo
//
//  Created by Jersey on 2018/10/6.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import "UIControl+YZHClickHandle.h"

#import <objc/runtime.h>

static void *strKey = &strKey;
@implementation UIButton (YZHClickHandle)

//+ (void)load {
//
//    Method originMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method customMethod = class_getInstanceMethod(self, @selector(yzh_sendAction:to:forEvent:));
//
//    method_exchangeImplementations(originMethod, customMethod);
//}

#pragma mark -- Event Response

- (void)yzh_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    
    if ([NSDate date].timeIntervalSince1970 - self.yzh_acceptEventTime < self.yzh_acceptEventInterval) {
        return;
    }
    if (self.yzh_acceptEventInterval) {
        self.yzh_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self yzh_sendAction:action to:target forEvent:event];
}

#pragma mark -- Get && Set

- (NSTimeInterval)yzh_acceptEventTime {
    
    return [objc_getAssociatedObject(self, strKey) boolValue];
}

- (void)setYzh_acceptEventTime:(NSTimeInterval)yzh_acceptEventTime {
    
    objc_setAssociatedObject(self, strKey, @(yzh_acceptEventTime), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)yzh_acceptEventInterval {
    
    return [objc_getAssociatedObject(self, strKey) boolValue];
}


- (void)setYzh_acceptEventInterval:(NSTimeInterval)yzh_acceptEventInterval {
    
    objc_setAssociatedObject(self, strKey, @(yzh_acceptEventInterval), OBJC_ASSOCIATION_ASSIGN);
}

@end
