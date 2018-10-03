//
//  YZHAddBookFirendModel.h
//  YZHYolo
//
//  Created by Jersey on 2018/10/2.
//  Copyright © 2018年 YZHChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZHAddBookFirendModel : NSObject

@property (nonatomic, copy) NSString* title;

@end

@interface YZHFirendContentModel : NSObject

@property (nonatomic, copy) NSArray<YZHAddBookFirendModel *>*  list;

@end

NS_ASSUME_NONNULL_END
