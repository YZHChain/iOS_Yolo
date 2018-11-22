//
//  YZHChatContentHeaderView.h
//  YZHYolo
//
//  Created by Jersey on 2018/11/21.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kYZHChatContentTypeImage = 0,
    kYZHChatContentTypeCard,
    kYZHChatContentTypeURL,
} kYZHChatContentType;

NS_ASSUME_NONNULL_BEGIN

@interface YZHChatContentHeaderView : UIView

@property (nonatomic, copy) void(^switchTypeBlock)(kYZHChatContentType currentType);

@end

NS_ASSUME_NONNULL_END
