//
//  UIImageView+YZHImage.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/14.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (YZHImage)

- (void)yzh_setImageWithString:(NSString *)aString;
- (void)yzh_setImageWithString:(NSString *)aString placeholder:(NSString *__nullable)placeholder;
- (void)yzh_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

@end

NS_ASSUME_NONNULL_END
